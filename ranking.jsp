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

<html lang="ja">
<head>
    <meta charset="utf-8">
    <link rel="stylesheet" href="css/bootstrap.css">
    <link href="css/ikitter.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-2.2.3.js"></script>
    <script src="js/bootstrap.js"></script>
    <title>テスト</title>
    <nav class="navbar navbar-toggleable-md navbar-light bg-faded" style="background-color: #83BA3B">
        <button class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse"
                data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false"
                aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <a class="navbar-brand" href="#">Ikitter</a>

    </nav>
    <div class="container">
        <div class="card" style="max-width: 20rem;">
            <div class="card-header">ヘッダー</div>
            <%

                Context ctx = null;
                DataSource ds = null;
                Connection con = null;
                String strSql = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {
                    ctx = new InitialContext();
                    ds = (DataSource) ctx.lookup("java:comp/env/jdbc/Ikitter");
                    con = ds.getConnection();
                    strSql = "select * from user order by score desc";
                    ps = con.prepareStatement(strSql);
                    rs = ps.executeQuery();

                    int cnt = 1;
                    while (rs.next()) {
                        ;
    /*1:ゆーざ１、
    akiirokoutya
    114514点*/
                        out.println(cnt + "位:" + rs.getString("name") + "<br>ID:@" + rs.getString("userid") + "<br>カテゴリ" + rs.getString("category") + "<br>" + rs.getInt("score") + "<br><br>");
                        cnt++;
                    }

                } catch (Exception e) {
                    out.println("try block : " + e.getMessage());
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
            <div class="card-footer">
                フッター
            </div>
        </div>
    </div>
</head>
<body>
</body>
</html>
