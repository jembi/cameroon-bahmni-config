const express = require('express');
const app = express();
const mysql = require('mysql');
var server = require('http').Server(app);

const port = 3000;

const con = mysql.createConnection({
  multipleStatements: true,
  host: "localhost",
  user: "root",
  password: "Admin@123",
  database: "openmrs"
});

con.connect(function(err) {
    if (err) throw err;
    console.log("Connected!");
  });

app.get('/', (req, res) => {
    res.send('done');
});

const deletedObs = function() {
    return new Promise(resolve => {
        con.query('SELECT * FROM obs ORDER BY obs_id DESC', (err, result) => {
            let deleteQuery = '';
            for(let i=0;i<result.length;i++) {
                deleteQuery += `DELETE FROM obs WHERE obs_id = ${result[i]['obs_id']};`;
            }
            con.query(deleteQuery, (err, result) => {
                resolve();
            });
        });
    });
}

const deletedOrders = function() {
    return new Promise(resolve => {
        con.query('SELECT * FROM orders ORDER BY order_id DESC', (err, result) => {
            let deleteQuery = '';
            for(let i=0;i<result.length;i++) {
                deleteQuery += `DELETE FROM orders WHERE order_id = ${result[i]['order_id']};`;
            }
            con.query(deleteQuery, (err, result) => {
                resolve();
            });
        });
    });
}

app.get('/cleanup', async (req, res) => {

    await deletedObs();
    await deletedOrders();

    let query = '';
    query += 'DELETE FROM person_merge_log;';
    query += 'DELETE FROM patient_appointment_audit;';
    query += 'DELETE FROM patient_appointment WHERE patient_id > 72;';
    query += 'DELETE FROM person_address WHERE person_id > 72;';
    query += 'DELETE FROM patient_identifier WHERE patient_id > 72;';
    query += 'DELETE FROM person_name WHERE person_id > 72;';
    query += 'DELETE FROM person_attribute WHERE person_id > 72;';
    query += 'DELETE FROM relationship WHERE person_a > 72 OR person_b > 72;';
    query += 'DELETE FROM drug_order;';
    query += 'DELETE FROM encounter_provider;';
    query += 'DELETE FROM encounter;';
    query += 'DELETE FROM patient_program_attribute;';
    query += 'DELETE FROM patient_program_attribute_history;';
    query += 'DELETE FROM episode_patient_program;';
    query += 'DELETE FROM patient_state;';
    query += 'DELETE FROM patient_program;';
    query += 'DELETE FROM visit_attribute;';
    query += 'DELETE FROM visit;';
    query += 'DELETE FROM audit_log;';
    query += 'DELETE FROM patient WHERE patient_id > 73;';
    query += 'DELETE FROM person WHERE person_id > 73;';

    con.query(query,
        function (err, rowsBook, fields) { // another Way
            if (err) {
                res.status(500).send(JSON.stringify(err));
            } else {
                res.send('done');
            }        
    });
    
});

server.listen(port, "0.0.0.0", () => console.log(`DB cleanup service listening on port ${port}!`))