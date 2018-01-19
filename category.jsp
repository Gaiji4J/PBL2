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
  String Aki = "TEST1";
  String username = "";
  String userid = "";
  String category = "";
  String categoryArray [] = new String[5];
  int flag=0;
  int i=0;
  int cnt=0;

  if(cname == "" || cname==null || cname.length()>20 ){
    flag=-1;
  }

  Context ctx = null;
  DataSource ds = null;
  Connection con = null;
  String strSql = null;
  PreparedStatement ps = null;
  PreparedStatement ps2 = null;
  PreparedStatement ps3 = null;
  ResultSet rs = null;
  ResultSet rs2 = null;
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

    strSql="select * from user where name =?";
    ps2 = con.prepareStatement(strSql);
    ps2.setString(1,Aki);
    rs2 = ps2.executeQuery( );


    while(rs2.next()){
      username = rs2.getString("name");
      userid =  rs2.getString("userid");
      category = rs2.getString("category");
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
          if (rs2 != null) rs2.close( );
          if (rs3 != null) rs3.close( );
          if (con != null) con.close( );
          if (ps != null) ps.close( );
          if (ps2 != null) ps2.close( );
          if (ps3 != null) ps3.close( );
        } catch(Exception e) {
          System.out.println("finally block : " + e.getMessage( ));
          e.printStackTrace( );
          }
      }

%>
<html lang="ja">

<head>
    <meta charset="utf-8">
    <link href="css/aki.css" rel="stylesheet">
    <link href="css/fab.css" rel="stylesheet">
    <link href="css/tk.css" rel="stylesheet">
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
    <title>Ikitter</title>
</head>

<body>

    <dvi id="test"></dvi>
    <header id="start_header">&nbsp;</header>
    <!--ヘッダーらしい-->
    <div id="start_header2"></div>
    <!--上のヘッダー-->
    <a href="home.jsp" id="ikitter_log">Ikitter</a>
    <!--左上のロゴボタン-->
    <a href="test.html" id="login_botan">Login</a>
    <!--右上のログインボタン-->
    <img id="start_image" src="image\DSC_00042.jpg" />
    <!--画像-->

    <!--------------個人プロフィール枠------------>

    <img class="people_backcolor" src="image/aki1.jpg" />
    <img class="people_backcolor" src="image/aki.jpg" />
    <div id="people_space">
        <img class="people_icon" src="image\ico.jpg" />
        <p id="people_name"><% out.print(username); %></p>
        <p id="people_id">@<% out.print(userid); %></p>
        <hr id="people_hr">
        <p id="people_category">選択中のカテゴリ：<br><% out.print(category); %></p>
    </div>

    <!-------------カテゴリ選択画面------------------>
    <div id="category_back">
        <div id="category_top">カテゴリ</div>
        <p id="category_p">カテゴリ名を入力してください。</p>
        <form action="category.jsp" method="post">
            <input id="category_s" type="search" name="cname" placeholder="カテゴリを入力">
            <input id="category_s_button" type="submit" name="submit" value="検索">
        </form>
        <!--小谷ぞーん-->
        <div id="category_body">
          <%

              if(cname!=null){
                if(flag==0){
                  //入力したカテゴリがない場合
                  out.println("検索ワード:" + cname +"<p>検索したカテゴリは存在しませんでした。");
                  out.println("<br>　新規で「" + cname + "」を作成しますか？");
                  out.println("<form action=\"insert.jsp\" method=\"post\">");
                  out.println("<input type=\"hidden\" name=\"cname\" value=\""+ cname +"\">");
                  out.println("<input type=\"hidden\" name=\"userid\" value=\""+ userid +"\">");
                  out.println("<input id=\"category_change\" type=\"submit\" value=\"作成\"></p>");
                  if(cnt>0){
                    out.println("<br><br><br>検索ワードを含むカテゴリ<br>");
                    for(i=0;cnt>=i&&categoryArray[i]!=null;i++){
                      if((cname.equals(categoryArray[i]))==false){
                        out.print("<a href=\"category.jsp?cname="+categoryArray[i]+"\">"+ categoryArray[i] +"</a><br>");
                      }
                    }
                  }

                }else if (flag==1){
                //入力したカテゴリがある場合
                  out.println("検索ワード:"+cname +"<p>検索したカテゴリは存在しました。");
                  if(category.length()==0){//categoryに参加してるか判定
                  out.println("<br>　カテゴリ「" + cname + "」に参加しますか？");
                  out.println("<form action=\"change.jsp\" method=\"post\">");
                  out.println("<input type=\"hidden\" name=\"cname\" value=\""+ cname +"\">");
                  out.println("<input type=\"hidden\" name=\"userid\" value=\""+ userid +"\">");
                  out.println("<input id=\"category_change\" type=\"submit\" value=\"参加\"></p>");
                  if(cnt>1){
                    out.println("<br><br><br>検索ワードを含むカテゴリ<br>");
                    for(i=0;cnt>=i&&categoryArray[i]!=null;i++){
                      if((cname.equals(categoryArray[i]))==false){
                      out.print("<a href=\"category.jsp?cname="+categoryArray[i]+"\">"+ categoryArray[i] +"</a><br>");
                      }
                    }
                  }

                }else   if((cname.equals(category))==false){//いま参加中のカテゴリと同じか判定
                  out.println("<br>　参加中のカテゴリを変更しますか？");
                  out.println("<form action=\"change.jsp\" method=\"post\">");
                  out.println("<input type=\"hidden\" name=\"cname\" value=\""+ cname +"\">");
                  out.println("<input type=\"hidden\" name=\"userid\" value=\""+ userid +"\">");
                  out.println("<input id=\"category_change\" type=\"submit\" value=\"変更\"></p>");
                  if(cnt>1){
                    out.println("<br><br><br>検索ワードを含むカテゴリ<br>");
                    for(i=0;cnt>=i&&categoryArray[i]!=null;i++){
                      if((cname.equals(categoryArray[i]))==false){
                      out.print("<a href=\"category.jsp?cname="+categoryArray[i]+"\">"+ categoryArray[i] +"</a><br>");
                      }
                    }
                  }
                } else {
                  out.println("<br>　現在設定中のカテゴリです。");
                }
              }else if(flag==-1){
                    out.println("無効な検索ワード");
                  }
              }
          %>
        </div>
        <!---->
    </div>



    <main>
    </main>

    <!--フッター-->
    <div id="footer_msk">

        <div id="footer-long">

          <a class="footer-dai" style="left: 70px;">Ikitter紹介</a>
          <a href="about.html" class="link" style="top: 45px; left: 70px;">・About</a>
          <a href="how.html" class="link" style="top: 85px; left: 70px;">・How</a>
          <a href="advertiser.html" class="link" style="top: 125px; left: 70px;">・Advertiser</a>

          <a class="footer-dai" style="left: 270px;">各種ページ</a>
          <a href="start.html" class="link" style="top: 45px; left: 270px;">・Start</a>
          <a href="home.jsp" class="link" style="top: 85px; left: 270px;">・Home</a>
          <a href="profile.jsp" class="link" style="top: 125px; left: 270px;">・Prifile</a>
          <a href="category.jsp" class="link" style="top: 165px; left: 270px;">・Category</a>

          <a class="footer-dai" style="left: 470px;">お知らせ</a>
          <a href="info.html" class="link" style="top: 45px; left: 470px;">・Info</a>
          <a href="#.html" class="link" style="top: 85px; left: 470px;">・開発Blog</a>

          <a class="footer-dai" style="left: 670px;">外部ツール</a>
          <a href="adutter.html" class="link" style="top: 45px; left: 670px;">・Adutter</a>
          <a href="akitter.html" class="link" style="top: 85px; left: 670px;">・Akitter</a>

          <a class="footer-dai" style="left: 870px;">各種リンク</a>
          <a href="https://twitter.com" class="link" style="top: 45px; left: 870px;">・Twitter</a>
          <a href="https://tweetdeck.twitter.com" class="link" style="top: 85px; left: 870px;">・TweetDeck</a>
          <a href="https://ja.wikipedia.org/wiki/Twitter" class="link" style="top: 125px; left: 870px;">・Twitterとは</a>
          <a class="footer-dai" style="left: 1070px;">お問い合わせ</a>
          <a href="https://twitter.com/akiirokoutya" class="link" style="top: 45px; left: 1070px;">・@秋色紅茶</a>
        </div>
        <div id="kotani-button">
            <!-- ぼくたかゆき！ -->
            <a href="https://twitter.com/share" class="twitter-share-button" data-size="large">例のTweet #たかゆき</a>
            <audio id="sound-file" preload="auto">
                <source src="sound/aki.wav" type="audio/wav">
            </audio>

            <script type="text/javascript">
                window.twttr = (function(d, s, id) {
                    var t, js, fjs = d.getElementsByTagName(s)[0];
                    if (d.getElementById(id)) return;
                    js = d.createElement(s);
                    js.id = id;
                    js.src = "https://platform.twitter.com/widgets.js";
                    fjs.parentNode.insertBefore(js, fjs);
                    return window.twttr || (t = {
                        _e: [],
                        ready: function(f) {
                            t._e.push(f)
                        }
                    });
                }(document, "script", "twitter-wjs"));

                twttr.ready(function(twttr) {
                    twttr.events.bind('tweet', function(event) {
                        console.log('ツイート完了');
                        document.getElementById('sound-file').play();
                    });
                });
            </script>
        </div>
        <div id="share-button">
            <a href="https://twitter.com/intent/tweet?button_hashtag=Ikitter&text=%E3%82%A4%E3%82%AD%E3%82%8A%E3%83%A9%E3%83%B3%E3%82%AD%E3%83%B3%E3%82%B0%E4%B8%8A%E4%BD%8D%E3%81%AB%E3%81%AA%E3%81%A3%E3%81%A6%E5%BA%83%E5%91%8A%E5%8F%8E%E5%85%A5%EF%BC%81%EF%BC%9F%E6%96%B0%E3%82%B5%E3%83%BC%E3%83%93%E3%82%B9Ikitter%EF%BC%81%E8%A9%B3%E3%81%97%E3%81%8F%E3%81%AF%E3%81%93%E3%81%A1%E3%82%89" class="twitter-hashtag-button" data-size="large" data-url="http://Ikitter.Gaiji4J">Tweet #Ikitter</a>
            <script>
                ! function(d, s, id) {
                    var js, fjs = d.getElementsByTagName(s)[0],
                        p = /^http:/.test(d.location) ? 'http' : 'https';
                    if (!d.getElementById(id)) {
                        js = d.createElement(s);
                        js.id = id;
                        js.src = p + '://platform.twitter.com/widgets.js';
                        fjs.parentNode.insertBefore(js, fjs);
                    }
                }(document, 'script', 'twitter-wjs');
            </script>
        </div>

    </div>
    <!--フッダー用スクリプト-->
    <script type="text/javascript">
        $("#footer_msk").hover(
            function() {
                $('.footer-dai').css({
                    'font-size': '28px'
                });
            },
            function() {
                $('.footer-dai').css({
                    'font-size': '18px'
                });
            }
        );
    </script>
    <!--フッダー用スクリプト-->

</body>

</html>
