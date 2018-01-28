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
    int sum=0;
    int cnt=0;
    Context ctx = null;
    DataSource ds = null;
    Connection con = null;
    String strSql = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    ResultSet rs2 = null;
    try {
        ctx = new InitialContext();
        ds = (DataSource) ctx.lookup("java:comp/env/jdbc/Ikitter");
        con = ds.getConnection();
        strSql = "select * from category";
        ps = con.prepareStatement(strSql);
        rs = ps.executeQuery();

        while (rs.next()) { //読み出したカテゴリに登録されているユーザーを１人ずつ呼び出し
          sum = 0;
            out.println(rs.getString("name"));
            strSql = "select * from user where category = ? ";
            ps = con.prepareStatement(strSql);
            ps.setString(1,rs.getString("name"));
            rs2 = ps.executeQuery();
                while(rs2.next()){
                    sum+= rs2.getInt("score");
                }

                strSql = "UPDATA category SET score = ? where name = ?";
                ps = con.prepareStatement(strSql);
                ps.setInt(1,sum);
                ps.setString(2,rs.getString("name"));
                ps.executeUpdate( );

          out.println("<br>");
        }
        rs = null;
        rs2 = null;

        strSql = "delete  from picranking";
        ps = con.prepareStatement(strSql);
        ps.executeUpdate( );

        strSql = "select * from category ORDER BY score desc";
        ps = con.prepareStatement(strSql);
        rs = ps.executeQuery();
        while (rs.next()) {
          cnt=1
          strSql = "select * from user where category = ? ";
          ps = con.prepareStatement(strSql);
          ps.setString(1,rs.getString("name"));
          rs2 = ps.executeQuery();
            while (rs2.next()) {
            strSql = "insert into picranking(rank, category, name, userid, score) values(?,?,?,?,?)";
            ps = con.prepareStatement(strSql);
            ps.setInt(1,cnt);
            ps.setString(2,rs.getString("name"));
            ps.setString(3,rs2.getString("name"));
            ps.setString(4,rs2.getString("userid"));
            ps.setInt(5,rs.getInt("score"));
            ps.executeUpdate();
          }
        }

    } catch (Exception e) {
        System.out.println("try block : " + e.getMessage());
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (rs2 != null) rs.close();
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
