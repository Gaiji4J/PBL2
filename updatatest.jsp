<%@ page import="java.net.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>DBテスト</title>
</head>
<body>

<%
    int cnt=0;
    Context ctx = null;
    DataSource ds = null;
    Connection con = null;
    String strSql = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    ResultSet rs2 = null;
    ResultSet rs3 = null;
    try {
        ctx = new InitialContext();
        ds = (DataSource) ctx.lookup("java:comp/env/jdbc/Ikitter");
        con = ds.getConnection();
        strSql = "select * from category";
        ps = con.prepareStatement(strSql);
        rs = ps.executeQuery();

        while (rs.next()) { //読み出したカテゴリに登録されているユーザーを１人ずつ呼び出し
          out.println(cnt);
            strSql = "select * from user where category = ? ";
            ps = con.prepareStatement(strSql);
            ps.setString(1,rs.getString("name"));
            rs2 = ps.executeQuery();
                while(rs2.next()){
                    out.println(rs2.getString("name"));
                }
                cnt++;
          out.println("<br>");
        }

    } catch (Exception e) {
        System.out.println("try block : " + e.getMessage());
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (con != null) con.close();
            if (ps != null) ps.close();
        } catch (Exception e) {
            System.out.println("finally block : " + e.getMessage());
            e.printStackTrace();
        }
    }
%>
<a href="test2.jsp">
    <button>消す</button>
</a>
<a href="test3.jsp">
    <button>Gaiji4j推薦枠追加！</button>
</a>
</body>
</html>
