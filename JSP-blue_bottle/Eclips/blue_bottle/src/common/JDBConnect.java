package common;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletContext;

public class JDBConnect {
	
	private Connection conn; // DB를 연결하는 connection 객체 (java.sql)
	protected PreparedStatement pstmt;
	protected ResultSet rs;
	
	public Connection getConnection() { // Connection conn 가 private 이기 때문에 메소드를 하나 생성함
		return conn;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// [[ 1. 기본 생성자를 이용한 DB 연결 ]]
	public JDBConnect() { 
		// ojdbc6.jar JDBC 드라이버를 로드하는 코드
		try {
			Class.forName("oracle.jdbc.OracleDriver"); // 예외처리가 필요함
			String url = "jdbc:oracle:thin:@localhost:1521:xe"; // DB 접속 URL, xe -> DB이름
			String id = "musthave"; // 계정 id
			String pwd = "1234"; // 계정 pw
			
			conn = DriverManager.getConnection(url, id, pwd); // DB 연결 (java.sql)
			System.out.println("DB 연결 성공(기본 생성자)");
		}
		catch(Exception e) {
			System.out.println("Exception[JDBConnect] : " + e.getMessage()); // 예외가 발생한 이유를 출력해줌
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// [[ 2. application context를 이용한 DB 연결 (WEB-INF -> web.xml 파일) ]]
	public JDBConnect(ServletContext application) { 
		// ojdbc6.jar JDBC 드라이버를 로드하는 코드
		try {
			Class.forName(application.getInitParameter("oracleDriver"));
			String url = application.getInitParameter("oracleUrl");
			String id = application.getInitParameter("oracleId");
			String pwd = application.getInitParameter("oraclePwd");
			
			conn = DriverManager.getConnection(url, id, pwd); // DB 연결 (java.sql)
			System.out.println("DB 연결 성공(web.xml)");
		}
		catch(Exception e) {
			System.out.println("Exception[JDBConnect] : " + e.getMessage()); // 예외가 발생한 이유를 출력해줌
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// [[ 3. jsp 파일에서 직접 받아와서 DB 연결 ]]
	public JDBConnect(String driver, String url, String id, String pwd) { 
		// ojdbc6.jar JDBC 드라이버를 로드하는 코드

		try {
			Class.forName(driver);
			
			conn = DriverManager.getConnection(url, id, pwd); // DB 연결 (java.sql)
			System.out.println("DB 연결 성공(인수 생성자)");
		}
		catch(Exception e) {
			System.out.println("Exception[JDBConnect] : " + e.getMessage()); // 예외가 발생한 이유를 출력해줌
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// DB를 종료하는 메소드
	public void close() { 
		try {
			if(rs != null) {
				rs.close();
			}
			if(pstmt != null) {
				pstmt.close();
			}
			if(conn != null) { // conn이 null이 아닐때만 close
				conn.close(); // 예외처리가 필요함
			}
		}
		catch(Exception e) {
			System.out.println("Exception[close] : " + e.getMessage());
		}
	}
	
	
}
