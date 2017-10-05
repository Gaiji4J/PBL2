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
    <link href="css/ikitter.css" rel="stylesheet">
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
    <title>Ikitter</title>
</head>

<body>

    <dvi id="test"></dvi>
    <header id="start_header">&nbsp;</header>
    <!--ヘッダーらしい-->
    <div id="start_header2"></div>
    <!--上のヘッダー-->
    <a href="home.html" id="ikitter_log">Ikitter</a>
    <!--左上のロゴボタン-->
    <a href="test.html" id="login_botan">Login</a>
    <!--右上のログインボタン-->
    <img id="start_image" src="image\DSC_00042.jpg" />
    <!--画像-->

    <!--------------個人プロフィール枠------------>
    <div id="people_space"></div>
    <img id="people_backcolor" src="image\aki1.jpg" />
    <img id="people_backcolor" src="image\aki.jpg" />
    <img class="people_icon" src="image\ico.jpg" />

        <%

          Context ctx = null;
          DataSource ds = null;
          Connection con = null;
          String strSql = null;
          PreparedStatement ps = null;
          PreparedStatement ps2 = null;
          ResultSet rs = null;
          ResultSet rs2 = null;


          try {
          ctx = new InitialContext( );
          ds = (DataSource)ctx.lookup("java:comp/env/jdbc/Ikitter");
          con = ds.getConnection();

          strSql = "select * from score where id='ABC'";
          ps = con.prepareStatement(strSql);
          rs = ps.executeQuery( );

          strSql = "select * from user where userid='ABC'";
          ps2 = con.prepareStatement(strSql);
          rs2 = ps2.executeQuery( );


            /*1:ゆーざ１、
            akiirokoutya
            114514点*/
            rs.next( );
            rs2.next();
            out.println("<p id=\"people_name\">"+ rs.getString("name") +
            "</p><p id=\"people_id\">" + rs.getString("id") + "</p>" +
            "<hr id=\"people_hr\">" +
            "<p id=\"people_category\">選択中のカテゴリ："+ rs2.getString("category") + "</p>");

            /*カテゴリ選択画面*/

            out.println("<div id=\"profile_up_top\">プロフィール更新</div>" +
            "<div id=\"profile_up_back\"></div>" +
            "<img class=\"profile_up_icon\" src=\"image/ico.jpg\" />" +
            "<p id=\"profile_up_name\">"+ rs.getString("name") + "</p>" +
            "<p id=\"profile_up_id\">" + rs.getString("name") + "</p>" +
            "<hr id=\"profile_up_hr\">" +
            "<p id=\"profile_up_category\">カテゴリ「" + rs2.getString("category") + "」</p>" +
            "<p id=\"profile_up_score\">スコア:"+ "5000000000000" +"点</p>" +
            "<hr id=\"profile_up_hr2\">" +
            "<p id=\"profile_up_fav\">  ファボ　：" + rs.getInt("fabo") + "点</p>" +
            "<p id=\"profile_up_rt\">   RT　　：" + rs.getInt("RT") +"点</p>" +
            "<p id=\"profile_up_rp\">   リプライ：" + rs.getInt("RP") + "点</p>" +
            "<p id=\"profile_up_other\">その他　：" + rs.getInt("other") + "点</p>");


          } catch(Exception e) {
            out.println("try block : " + e.getMessage( ));
            e.printStackTrace( );
          } finally {
            try {
              if (rs != null) rs.close( );
              if (rs2 != null) rs2.close( );
              if (con != null) con.close( );
              if (ps != null) ps.close( );
              if (ps2 != null) ps2.close( );
            } catch(Exception e) {
              System.out.println("finally block : " + e.getMessage( ));
              e.printStackTrace( );
            }
          }

        %>

    <!-------------カテゴリ選択画面------------------>



    <input id="profile_up_button" type="button" value="更新" onclick="#">
    </form>
    <main>
    </main>
</body>
</html>
