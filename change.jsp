<%@ page import="java.net.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="java.util.*" %>

<%
    request.setCharacterEncoding("UTF-8");
    String cname = request.getParameter("cname");
    String userid = request.getParameter("userid");

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

  strSql = "UPDATE user SET category= ? where userid=?";
  ps = con.prepareStatement(strSql);
  ps.setString(1,cname);
  ps.setString(2,userid);
  ps.executeUpdate( );

} catch(Exception e) {
  out.println("try block : " + e.getMessage( ));
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


  String url="category.jsp";
  response.sendRedirect(url);
%>
