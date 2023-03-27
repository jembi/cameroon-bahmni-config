package org.jembi.bahmni.report_testing.test_utils;

import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.jembi.bahmni.report_testing.test_utils.models.ReportEnum;
import org.joda.time.LocalDate;
import org.junit.After;
import org.junit.Before;

public class BaseReportTest {
	private Connection con;
	public Statement stmt;
	protected TestDataGenerator testDataGenerator = new TestDataGenerator();

	@Before
	public void connectToDatabase() throws ClassNotFoundException, SQLException {
		Class.forName("com.mysql.jdbc.Driver");
		con = DriverManager.getConnection("jdbc:mysql://localhost:3306/openmrs", "root", "dbtest"); // TODO move the connection details into parameters
		stmt = con.createStatement();
		testDataGenerator.setStatement(stmt);
	}

	@After
	public void closeDatabaseConnection() throws Exception {
		cleanTestingData();
		stmt.close();
		con.close();
	}

	public String getFunctionCallResult(String query) throws Exception {
			ResultSet rs = stmt.executeQuery(query);
			while (rs.next()) {
				return rs.getString(1);
			}
			throw new Exception("No result found");
	}

	public List<Map<String,Object>> getReportResult(String query) throws Exception {
		List<Map<String,Object>> result = new ArrayList<Map<String,Object>>();
		ResultSet rs = stmt.executeQuery(query);

		while (rs.next()) {
			Map<String,Object> record = new HashMap<String,Object>();
			for(int i = 0; i < rs.getMetaData().getColumnCount(); i++) {
				if (rs.getObject(i+1) instanceof Date) {
					record.put(rs.getMetaData().getColumnName(i+1), rs.getObject(i+1).toString());
				} else {
					record.put(rs.getMetaData().getColumnName(i+1), rs.getObject(i+1));
				}
				
			}
			result.add(record);
		}
		return result;
	}

	protected String readReportQuery(ReportEnum reportFolder, String reportFileName, LocalDate startDate, LocalDate endDate) throws IOException {
		String currentDirectory = System.getProperty("user.dir");
		File file = new File(currentDirectory);

		file = file
				.getParentFile()
				.getParentFile()
				.listFiles(createFilenameFilter("openmrs"))[0]
				.listFiles(createFilenameFilter("apps"))[0]
				.listFiles(createFilenameFilter("reports"))[0]
				.listFiles(createFilenameFilter(reportFolder.toString()))[0]
				.listFiles(createFilenameFilter("sql"))[0]
				.listFiles(createFilenameFilter(reportFileName))[0];

		String sqlQuery = readFileIntoString(file.getPath());
		
		sqlQuery = sqlQuery.replace("#startDate#", startDate.toString());
		sqlQuery = sqlQuery.replace("#endDate#", endDate.toString());

		return sqlQuery;
	}

	private String readFileIntoString(String filePath) throws IOException {
	    return new String (Files.readAllBytes(Paths.get(filePath)));
	}

	FilenameFilter createFilenameFilter(final String folderName) {
		return  new FilenameFilter() {
			public boolean accept(File dir, String name) {
				return name.equals(folderName);
			}
		};
	}

	private void cleanTestingData() throws Exception {
		// Remove appointments
		executeUpdateQuery("DELETE FROM patient_appointment WHERE patient_id > 72");

		// Remove person addresses 
		executeUpdateQuery("DELETE FROM person_address WHERE person_id > 72");

		// Remove patient identifiers
		executeUpdateQuery("DELETE FROM patient_identifier WHERE patient_id > 72");

		// Remove person names
		executeUpdateQuery("DELETE FROM person_name WHERE person_id > 72");

		// Remove person attributes
		executeUpdateQuery("DELETE FROM person_attribute WHERE person_id > 72");

		// Remove relationships
		executeUpdateQuery("DELETE FROM relationship WHERE person_a > 72 OR person_b > 72");

		// Remove drug orders
		executeUpdateQuery("DELETE FROM drug_order");

		// Remove observations
		String obsQuery = "SELECT obs_id FROM obs ORDER BY obs_id DESC";

		List<Map<String,Object>> result = getReportResult(obsQuery);

		for (Map<String,Object> obs : result) {
			executeUpdateQuery("DELETE FROM obs WHERE obs_id=" + obs.get("obs_id"));
		}
		//Remove patient state
		String patientStateQuery = "SELECT patient_state_id FROM patient_state ORDER BY patient_state_id DESC";

		List<Map<String,Object>> patientStateResult = getReportResult(patientStateQuery);

		for (Map<String,Object> state : patientStateResult) {
			executeUpdateQuery("DELETE FROM patient_state WHERE patient_state_id=" + state.get("patient_state_id"));
		}
		
		// Remove orders
		executeUpdateQuery("DELETE FROM orders");

		// Remove encounter providers
		executeUpdateQuery("DELETE FROM encounter_provider");

		// Remove encounters
		executeUpdateQuery("DELETE FROM encounter");

		// Remove episode patient program
		executeUpdateQuery("DELETE FROM episode_patient_program");

		// Remove audit log
		executeUpdateQuery("DELETE FROM audit_log");

		// Remove patient program attributes
		executeUpdateQuery("DELETE FROM patient_program_attribute");

		// Remove program attribute history
		executeUpdateQuery("DELETE FROM patient_program_attribute_history");

		// Remove episode patient program 
		executeUpdateQuery("DELETE FROM episode_patient_program");

		// Remove patient programs
		executeUpdateQuery("DELETE FROM patient_program");

		// Remove visit attributes
		executeUpdateQuery("DELETE FROM visit_attribute");

		// Remove visits
		executeUpdateQuery("DELETE FROM visit");

		// Remove patients
		executeUpdateQuery("DELETE FROM patient WHERE patient_id > 73");

		// Remove persons
		executeUpdateQuery("DELETE FROM person WHERE person_id > 73");

	}

	private void executeUpdateQuery(String query) throws SQLException {
		stmt.executeUpdate(query);
	}
}
