let reportData = [];


const updatePeriod = function() {
    $('[id^="report-data-"]').html('');
    $('[id^="generate-report-"]').show();
}

const prePopulateDateField = function () {
    let month = new Date().getMonth() < 9 ? `0${new Date().getMonth() + 1}` : `${new Date().getMonth() + 1}`;
    $('#month').val(month);
    $('#year').val(new Date().getFullYear());
}

const generateReport = function(reportIndex) {
    $(`#generate-report-${reportIndex}`).hide();

    let date1 = new Date($('#year').val(), parseInt($('#month').val()) -1, 1, 10).toISOString().slice(0, 10);
    let date2 = new Date($('#year').val(), parseInt($('#month').val()), 0, 10).toISOString().slice(0, 10);

    $.get(`generate-report?reportIndex=${reportIndex}&startDate=${date1}&endDate=${date2}`, function (data, status) {
        $('#report-data-' + reportIndex).html(renderReportData(data));
    });
}

const renderReportData = function(data) {
    reportData[data.reportName] = data;
    let result = '<div>';

    data.dataElements.forEach(dataElement => {
        result += `<hr><div class="data-element">${dataElement.dataElementName}</div>`;
        result += '<table>';
        dataElement.values.forEach(value => {
            result +=
            `<tr>
                <td><div class="label">${value.label}</div></td>        
                <td><div class="report-value">${value.value}</div></td>        
            </tr>`;
        });
        result += '</table>';
    });

    result += '<hr>';
    result += `<button type="button" class="btn button" id="button-${data.reportName.replace(' ','')}" onclick="pushToDhis2('${data.reportName}',this)">Validate and push to DHIS 2</button>`;
    result += `<div id="message-${data.reportName.replace(' ','')}"></div>`;

    result += '</div>';

    return result;
}

const pushToDhis2 = function(reportName) {
    $(`#button-${reportName.replace(' ','')}`).hide();

    $.ajax('save-report', {
        data : JSON.stringify(reportData[reportName]),
        contentType : 'application/json',
        type : 'POST',
    });

    $(`#message-${reportName.replace(' ','')}`).html(`
    <div class="alert alert-success" role="alert">
        Done
    </div>
    `);

}

const getListOfReports = function () {
    return new Promise((resolve => {
        $.get('report-names', function (data, status) {
            let result = '<div class="report-panel">';
            let i = 0;
            data.forEach(reportName => {
                result += `
                
                    <div class="row"><div class="col-9 section-title">&nbsp;&nbsp;&nbsp;<img src="report.png"> &nbsp;&nbsp;&nbsp;${reportName}</div> <div class="col-3"><button type="button" id="generate-report-${i}" class="btn button" onclick="generateReport(${i})">Generate this report</button></div></div>
                    <div class="row" id="report-data-${i}"></div>
                `;
                i++;
            });
            result += '</div>';
            resolve(result);
        });
    }));
}
