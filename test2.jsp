<%@ page import="java.net.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="java.util.*" %>


<%

  Context ctx = null;
  DataSource ds = null;
  Connection con = null;
  String strSql = null;
  PreparedStatement ps = null;
  ResultSet rs = null;
  try {
    ctx = new InitialContext( );
    ds = (DataSource)ctx.lookup("java:comp/env/jdbc/Ikitter");
    con = ds.getConnection();
    strSql = "select * from sample";
    ps = con.prepareStatement(strSql);
    rs = ps.executeQuery( );
    while(rs.next( )){
      out.println("name = " + rs.getString("name") + ", id= " + rs.getString("userid") + "<br>");
    }
  } catch(Exception e) {
    System.out.println("try block : " + e.getMessage( ));
    e.printStackTrace( );
  } finally {
    try {
      if (rs != null) rs.close( );
      if (con != null) con.close( );
      if (ps != null) ps.close( );
    } catch(Exception e) {
      System.out.println("finally block : " + e.getMessage( ));
      e.printStackTrace( );
    }
  }
%>
