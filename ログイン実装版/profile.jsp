<%@ page import="java.net.*" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="java.util.*" %>

<%@ page contentType="text/html" pageEncoding="UTF-8" import="oauth.signpost.*,twitter4j.*" %>
<%@ page import="twitter4j.auth.AccessToken" %>
<%@ page import="oauth.signpost.exception.OAuthMessageSignerException" %>
<%@ page import="oauth.signpost.exception.OAuthNotAuthorizedException" %>
<%@ page import="oauth.signpost.exception.OAuthExpectationFailedException" %>
<%@ page import="oauth.signpost.exception.OAuthCommunicationException" %>
<%@ page import="oauth.signpost.basic.DefaultOAuthProvider" %>
<%@ page import="oauth.signpost.basic.DefaultOAuthConsumer" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
    User user = null;
    String authUrl = null;

    if (session.getAttribute("twitter") == null) {

        //ログイン直後の処理
        if (request.getParameter("oauth_verifier") != null) {

            //セッション情報の取り出し
            OAuthConsumer consumer = (OAuthConsumer) session.getAttribute("consumer");
            OAuthProvider provider = (OAuthProvider) session.getAttribute("provider");

            //consumerの復号
            try {
                provider.retrieveAccessToken(consumer, request.getParameter("oauth_verifier"));
            } catch (OAuthMessageSignerException | OAuthNotAuthorizedException | OAuthCommunicationException | OAuthExpectationFailedException e) {
                e.printStackTrace();
            }

            //Twitterインスタンスの取得
            Twitter twitter = new TwitterFactory().getInstance();
            twitter.setOAuthConsumer(consumer.getConsumerKey(), consumer.getConsumerSecret());
            twitter.setOAuthAccessToken(new AccessToken(consumer.getToken(), consumer.getTokenSecret()));

            //ユーザー情報取り出し
//            User user = null;
            try {
                user = twitter.verifyCredentials();
            } catch (TwitterException e) {
                e.printStackTrace();
            }

            //セッションにtwitterオブジェクトを保存
            session.setAttribute("twitter", twitter);

            //ログイン前の処理
        } else {

            //いろいろ定義
            OAuthConsumer consumer = new DefaultOAuthConsumer(
                    "7iIxJb8EdJSNepd53TXmZZFRS",
                    "JrmpJXd65kqjKCWMC6ut3ibaY6jSKwkqywSSCDNVEK9DUmAQ6C");

            OAuthProvider provider = new DefaultOAuthProvider(
                    "https://api.twitter.com/oauth/request_token",
                    "https://api.twitter.com/oauth/access_token",
                    "https://api.twitter.com/oauth/authorize");

            //セッションに保存
            session.setAttribute("consumer", consumer);
            session.setAttribute("provider", provider);

            //ログインURL生成
            String callbackUri = request.getRequestURL().toString();
//            String authUrl = null;
            try {
                authUrl = provider.retrieveRequestToken(consumer, callbackUri);
            } catch (OAuthMessageSignerException | OAuthNotAuthorizedException | OAuthExpectationFailedException | OAuthCommunicationException e) {
                e.printStackTrace();
            }
        }
    } else {
        Twitter twitter = (Twitter) session.getAttribute("twitter");
        try {
            user = twitter.verifyCredentials();
        } catch (TwitterException e) {
            e.printStackTrace();
        }
    }
%>


<html lang="ja">
<head>
    <meta charset="utf-8">
    <link href="css/aki.css" rel="stylesheet">
    <link href="css/fab.css" rel="stylesheet">
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
<% //twitterオブジェクトが存在する場合(ログイン済みの場合)
    if (session.getAttribute("twitter") != null) { %>

<a href="logout.jsp" id="login_botan">Logout</a>

<% //そうでない場合
} else { %>

<a href="<%=authUrl%>" id="login_botan">Login</a>

<% } %>
<!--右上のログインボタン-->
<img id="start_image" src="image\DSC_00042.jpg"/>
<!--画像-->

<!--------------個人プロフィール枠------------>
<% //twitterオブジェクトが存在する場合(ログイン済みの場合)
    if (session.getAttribute("twitter") != null) { %>

<div id="people_space"></div>
<img class="people_backcolor" src="<%=user != null ? user.getProfileBannerURL() : null%>"/>
<img class="people_icon" src="<%=user != null ? user.getProfileImageURL() : null%>"/>
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
        ctx = new InitialContext();
        ds = (DataSource) ctx.lookup("java:comp/env/jdbc/Ikitter");
        con = ds.getConnection();

        strSql = "select * from score where id='ABC'";
        ps = con.prepareStatement(strSql);
        rs = ps.executeQuery();

        strSql = "select * from user where userid='ABC'";
        ps2 = con.prepareStatement(strSql);
        rs2 = ps2.executeQuery();


            /*1:ゆーざ１、
            akiirokoutya
            114514点*/
        rs.next();
        rs2.next();
        out.println("<p id=\"people_name\">" + rs.getString("name") +
                "</p><p id=\"people_id\">" + rs.getString("id") + "</p>" +
                "<hr id=\"people_hr\">" +
                "<p id=\"people_category\">選択中のカテゴリ：" + rs2.getString("category") + "</p>");

        /*カテゴリ選択画面*/

        out.println("<div id=\"profile_up_top\">プロフィール更新</div>");
        out.println("<div id=\"profile_up_back\"></div>");
        out.println("<img class=\"profile_up_icon\" src=\"image/ico.jpg\" />");
        out.println("<p id=\"profile_up_name\">" + rs.getString("name") + "</p>");
        out.println("<p id=\"profile_up_id\">" + rs.getString("name") + "</p>");
        out.println("<hr id=\"profile_up_hr\">");
        out.println("<p id=\"profile_up_category\">カテゴリ「" + rs2.getString("category") + "」</p>");
        out.println("<p id=\"profile_up_score\">スコア:" + "10000000" + "点</p>");
        out.println("<hr id=\"profile_up_hr2\">");
        out.println("<p id=\"profile_up_fav\">  ファボ　：" + rs.getInt("fabo") + "点</p>");
        out.println("<p id=\"profile_up_rt\">   RT　　：" + rs.getInt("RT") + "点</p>");
        out.println("<p id=\"profile_up_rp\">   リプライ：" + rs.getInt("RP") + "点</p>");
        out.println("<p id=\"profile_up_other\">その他　：" + rs.getInt("other") + "点</p>");


    } catch (Exception e) {
        out.println("try block : " + e.getMessage());
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (rs2 != null) rs2.close();
            if (con != null) con.close();
            if (ps != null) ps.close();
            if (ps2 != null) ps2.close();
        } catch (Exception e) {
            System.out.println("finally block : " + e.getMessage());
            e.printStackTrace();
        }
    }

%>

<% //そうでない場合
} else { %>

<div id="profile_space">
    <div id="profile_backcolor"></div>
    <div id="login_font">ログインはこちら</div>
    <!--
    <input type="text" id="id_input" required="required" placeholder="Twitter ID" />
    <input type="password" id="pass_input" required="required" placeholder="Twitter PASS" />
    -->

    <input type="button" id="login_Button" value="LOGIN" onClick="location.href='<%=authUrl%>'">
    <p><a href="https://twitter.com/account/begin_password_reset" id="forgot_font">Forgot Twitter Account</a></p>
    <p><a id="forgot_font2">Ikitterを始めよう。</a></p>

</div>

<% } %>
<!--プロフィール枠******************************************************************-->

<!-------------カテゴリ選択画面------------------>


<input id="profile_up_button" type="button" value="更新" onclick="#">
</form>
<main>
</main>

<!--フッター-->
<div id="footer_msk">

    <div id="footer-long">

        <a class="footer-dai" style="left: 70px;">Ikitter紹介</a>
        <a href="about.jsp" class="link" style="top: 45px; left: 70px;">・About</a>
        <a href="how.jsp" class="link" style="top: 85px; left: 70px;">・How</a>
        <a href="advertiser.jsp" class="link" style="top: 125px; left: 70px;">・Advertiser</a>

        <a class="footer-dai" style="left: 270px;">各種ページ</a>
        <a href="start.jsp" class="link" style="top: 45px; left: 270px;">・Start</a>
        <a href="home.jsp" class="link" style="top: 85px; left: 270px;">・Home</a>
        <a href="profile.jsp" class="link" style="top: 125px; left: 270px;">・Profile</a>
        <a href="category.jsp" class="link" style="top: 165px; left: 270px;">・Category</a>

        <a class="footer-dai" style="left: 470px;">お知らせ</a>
        <a href="info.jsp" class="link" style="top: 45px; left: 470px;">・Info</a>
        <a href="#.jsp" class="link" style="top: 85px; left: 470px;">・開発Blog</a>

        <a class="footer-dai" style="left: 670px;">外部ツール</a>
        <a href="adutter.jsp" class="link" style="top: 45px; left: 670px;">・Adutter</a>
        <a href="akitter.jsp" class="link" style="top: 85px; left: 670px;">・Akitter</a>

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
            window.twttr = (function (d, s, id) {
                var t, js, fjs = d.getElementsByTagName(s)[0];
                if (d.getElementById(id)) return;
                js = d.createElement(s);
                js.id = id;
                js.src = "https://platform.twitter.com/widgets.js";
                fjs.parentNode.insertBefore(js, fjs);
                return window.twttr || (t = {
                    _e: [],
                    ready: function (f) {
                        t._e.push(f)
                    }
                });
            }(document, "script", "twitter-wjs"));

            twttr.ready(function (twttr) {
                twttr.events.bind('tweet', function (event) {
                    console.log('ツイート完了');
                    document.getElementById('sound-file').play();
                });
            });
        </script>
    </div>
    <div id="share-button">
        <a href="https://twitter.com/intent/tweet?button_hashtag=Ikitter&text=%E3%82%A4%E3%82%AD%E3%82%8A%E3%83%A9%E3%83%B3%E3%82%AD%E3%83%B3%E3%82%B0%E4%B8%8A%E4%BD%8D%E3%81%AB%E3%81%AA%E3%81%A3%E3%81%A6%E5%BA%83%E5%91%8A%E5%8F%8E%E5%85%A5%EF%BC%81%EF%BC%9F%E6%96%B0%E3%82%B5%E3%83%BC%E3%83%93%E3%82%B9Ikitter%EF%BC%81%E8%A9%B3%E3%81%97%E3%81%8F%E3%81%AF%E3%81%93%E3%81%A1%E3%82%89"
           class="twitter-hashtag-button" data-size="large" data-url="http://Ikitter.Gaiji4J">Tweet #Ikitter</a>
        <script>
            !function (d, s, id) {
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
        function () {
            $('.footer-dai').css({
                'font-size': '28px'
            });
        },
        function () {
            $('.footer-dai').css({
                'font-size': '18px'
            });
        }
    );
</script>
<!--フッダー用スクリプト-->


</body>
</html>
