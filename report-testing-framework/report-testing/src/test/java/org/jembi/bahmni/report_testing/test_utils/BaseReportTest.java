package org.jembi.bahmni.report_testing.test_utils;

import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

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
	public void closeDatabaseConnection() throws SQLException {
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

	public ResultSet getIndicatorResult(String query) throws Exception {
		ResultSet rs = stmt.executeQuery(query);
		rs.next();
		return rs;
	}

	public int getNumberRecords(String query) throws Exception {
		ResultSet rs = stmt.executeQuery(query);
		rs.last();
		return rs.getRow();
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

	private void cleanTestingData() throws SQLException {
		// Remove patient identifiers
		executeUpdateQuery("DELETE FROM patient_identifier WHERE patient_id > 72");

		// Remove person names
		executeUpdateQuery("DELETE FROM person_name WHERE person_id > 72");

		// Remove person attributes
		executeUpdateQuery("DELETE FROM person_attribute WHERE person_id > 72");

		// Remove relationships
		executeUpdateQuery("DELETE FROM relationship WHERE person_a > 72 OR person_b > 72");

		// Remove persons
		executeUpdateQuery("DELETE FROM person WHERE person_id > 72");
		
		// Remove patients
		executeUpdateQuery("DELETE FROM patient WHERE patient_id > 72");

		// Remove patient program attributes
		executeUpdateQuery("DELETE FROM patient_program_attribute");

		// Remove patient programs
		executeUpdateQuery("DELETE FROM patient_program");

		// Remove visits
		executeUpdateQuery("DELETE FROM visit");

		// Remove observations
		executeUpdateQuery("DELETE FROM obs");

		// Remove drug orders
		executeUpdateQuery("DELETE FROM drug_order");

		// Remove orders
		executeUpdateQuery("DELETE FROM orders");

		// Remove encounters
		executeUpdateQuery("DELETE FROM encounter");
	}

	private void executeUpdateQuery(String query) throws SQLException {
		stmt.executeUpdate(query);
	}
}
