const { v4: uuidv4 } = require('uuid');
const express = require('express');
const mysql = require('mysql');
const fs = require('fs');
const { Tree } = require('./server-utils');

const app = express();
app.use(express.json());

const port = 3000;

var con = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "Jembi@123",
  database: 'openmrs'
});

con.connect(function (err) {
  if (err) throw err;
  console.log("Connected to MySQL!");
});

app.use((req, res, next) => {
  const config = JSON.parse(fs.readFileSync('config.json'));
  const auth = { login: config.username, password: config.password } // change this

  // parse login and password from headers
  const b64auth = (req.headers.authorization || '').split(' ')[1] || ''
  const [login, password] = Buffer.from(b64auth, 'base64').toString().split(':')

  // Verify login and password are set and correct
  if (login && password && login === auth.login && password === auth.password) {
    // Access granted...
    return next()
  }

  // Access denied...
  res.set('WWW-Authenticate', 'Basic realm="401"') // change this
  res.status(401).send('Authentication required.') // custom message
});

app.use(express.static('public'))

app.get('/', (req, res) => {
  res.send('Hello World, from express');
});

app.get('/report-names', (req, res) => {
  res.send(getListOfReports());
});

app.get('/generate-report', (req, res) => {
  generateReport(req.query.reportIndex, new Date(req.query.startDate),new Date(req.query.endDate)).then(result => {
    res.send(result);
  });
});

app.post('/save-report', (req, res) => {
  saveReportDataLocally(req.body);
  res.send();
});

app.listen(port, () => console.log(`Data agent UI listening on port ${port}!`))

const getListOfReports = function () {
  const config = JSON.parse(fs.readFileSync('config.json'));
  const metadata = JSON.parse(fs.readFileSync(config.path_metadata_config));

  return metadata.reports.map(r => r.reportName);
}

const generateReport = async function (reportIndex, startDate, endDate) {
  const config = JSON.parse(fs.readFileSync('config.json'));
  const metadata = JSON.parse(fs.readFileSync(config.path_metadata_config));
  const reportConfig = metadata.reports[reportIndex];

  const parameterTree = new Tree(uuidv4(), 'root');

  reportConfig.parameters.forEach(param => {
    let leaves = [...parameterTree.getLeaves()];


    if (param.options) {
      param.options.forEach(option => {
        leaves.forEach(leave => {
          parameterTree.insert(
            leave.key,
            uuidv4(),
            [{
              key: param.key,
              value: option
            }]
          );
        });
      });
    } else if (param.ranges) {
      leaves.forEach(leaf => {
        param.ranges.forEach(range => {
          parameterTree.insert(
            leaf.key,
            uuidv4(),
            [{
              key: `${param.key}.min`,
              value: range.min
            },{
              key: `${param.key}.max`,
              value: range.max
            }]
          );
        });
      });
    }
  });

  let leaves = [...parameterTree.getLeaves()];

  let disaggregations = [];

  leaves.forEach(leave => {
    let path = [... parameterTree.getPath(leave)];

    let disaggregation = [];
    path.forEach(node => {
      disaggregation.push(...node.value);
    });

    disaggregations.push(disaggregation);

  });

  // generate queries and result
  let result = {
    metadataVersion: metadata.metadata.version,
    period: startDate.getFullYear() + '' + (startDate.getMonth()+1).toString().padStart(2, '0'),
    orgUnitId: config.dhis2_org_unit,
    reportName: reportConfig.reportName,
    dataElements: []
  }

    for (let k=0;k<reportConfig.dataElements.length;k++){
      let de = reportConfig.dataElements[k];
  
      let dataElementRecord = {
        dataElementName: de.dataElementName,
        values: []
      }

      for (let i=0;i<disaggregations.length;i++) {
        let d = disaggregations[i];
        let query = de.query;
        query = query.replace('#startDate#', startDate.toISOString().slice(0, 10));
        query = query.replace('#endDate#', endDate.toISOString().slice(0, 10));

        d.forEach(template => {
          query = query.replace(`#${template.key}#`, template.value);
        });

        let value = await evaluateQuery(query);
        
        dataElementRecord.values.push(buildDataElementValue(value, d, reportConfig));
      }

      result.dataElements.push(dataElementRecord);
    }

  return result;

}

const buildDataElementValue = function(value, mappingTable, reportConfig) {
  let res = {
    disaggregations: [],
    value: value,
    label: getAggregationLabels(mappingTable)
  }

  for(let i=0;i<mappingTable.length;i++) {
    let template = mappingTable[i];
    if (!template.key.includes('.')) {
      res.disaggregations.push(
        {
          key: template.key,
          index: findIndexOfOption(template.key, template.value, reportConfig)
        }
      );
    } else {
      let key = template.key.split('.')[0];

      res.disaggregations.push(
        {
          key: key,
          index: findIndexOfRange(key, template.value, mappingTable[i + 1].value, reportConfig)
        }
      );
      i++;
    }
  }

  return res;
}

const getAggregationLabels = function(mappingTable) {
  result = '';
  for(let i=0;i<mappingTable.length;i++) {
    let template = mappingTable[i];
    if (!template.key.includes('.')) {
      result +=  template.key + ' : ' + template.value + ' | ';
    } else {
      let key = template.key.split('.')[0];
      result += key+ ' : ' + template.value + ' - ' + mappingTable[i+1].value + ' | ';
      i++;
    }
  }

  return result.slice(0, -2);;
}

const findIndexOfOption = function(key, value, reportConfig) {
  let parameter = reportConfig.parameters.filter(param => param.key === key)[0];
  return parameter.options.indexOf(value);
}

const findIndexOfRange = function(key, value1, value2, reportConfig) {
  let parameter = reportConfig.parameters.filter(param => param.key === key)[0];
  for(let i=0;i<parameter.ranges.length;i++) {
    let range = parameter.ranges[i];
    if (range.min === value1 && range.max === value2) {
      return i;
    }
  }

  return -2;
}

const evaluateQuery = function(sql) {
  return new Promise(resolve => {
    con.query(sql, function (err, result) {
      if (err) {
        console.log(JSON.stringify(err));
        throw err;
      }
      let firstRecord = result[0];
      resolve(firstRecord[Object.keys(firstRecord)[0]]);
    });
  });
}

const saveReportDataLocally = function(reportData) {
  const config = JSON.parse(fs.readFileSync('config.json'));

  reportData.dataElements.forEach(de => {
    de.values.forEach(value => {
      delete value.label;
    });
  });

  fs.writeFileSync(config.path_report_folder + '/' + reportData.reportName + '-' + reportData.period + '.json', JSON.stringify(reportData, null, 2) , 'utf-8'); //
}

