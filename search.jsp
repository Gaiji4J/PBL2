<%@ page import="javax.naming.Context" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%
  request.setCharacterEncoding("UTF-8");
  String cname = request.getParameter("cname");
  String categoryArray [] = new String[5];
  int flag=0;
  int i=0;
  int cnt=0;

  if(cname == "" || cname==null || cname.length()=>20 ){
    flag=-1;
  }

  Context ctx = null;
  DataSource ds = null;
  Connection con = null;
  String strSql = null;
  PreparedStatement ps = null;
  PreparedStatement ps3 = null;
  ResultSet rs = null;
  ResultSet rs3 = null;

    try {
    ctx = new InitialContext( );
    ds = (DataSource)ctx.lookup("java:comp/env/jdbc/Ikitter");
    con = ds.getConnection();

    strSql = "select * from category where name= ?";
    ps = con.prepareStatement(strSql);
    ps.setString(1,cname);
    rs = ps.executeQuery( );

      while(rs.next()){
        flag=1;
      }

      strSql="select * from category where name LIKE ?";
      ps3 = con.prepareStatement(strSql);
      ps3.setString(1,"%"+cname+"%");
      rs3 = ps3.executeQuery( );
        while(rs3.next() && cnt<=4){
          categoryArray[cnt] = rs3.getString("name");
          cnt++;
        /*メモ
        strSql="select * from category where name LIKE %?%;
        ps3.setString(1,cname);
        この書き方だとエラーが起きる*/
  }
    } catch(Exception e) {
      out.println("try block : " + e.getMessage( ));
      e.printStackTrace( );
      } finally {
        try {
          if (rs != null) rs.close( );
          if (rs3 != null) rs3.close( );
          if (con != null) con.close( );
          if (ps != null) ps.close( );
          if (ps3 != null) ps3.close( );
        } catch(Exception e) {
          System.out.println("finally block : " + e.getMessage( ));
          e.printStackTrace( );
          }
      }

%>
