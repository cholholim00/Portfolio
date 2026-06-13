package common;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class DBConnPool {
	protected Connection con;
	protected PreparedStatement pstmt;
	protected ResultSet rs;
	
	public DBConnPool() {
		try {
			Context initCtx =  new InitialContext();
			Context ctx = (Context)initCtx.lookup("java:comp/env");
			DataSource source = (DataSource)ctx.lookup("dbcp_myoracle");
			con = source.getConnection();
			System.out.println("DB Connection Pool 성공!");
		}
		catch(Exception e){
			System.out.println("Exception[DBConnPool]: " + e.getMessage());
		}
	}
	
	public void close() { 
		try {
			if(rs != null) {
				rs.close();
			}
			if(pstmt != null) {
				pstmt.close();
			}
			if(con != null) { // con 이 null이 아닐때만 close
				con.close(); // 예외처리가 필요함
			}
		}
		catch(Exception e) {
			System.out.println("Exception[close] : " + e.getMessage());
		}
	}
	
}
