<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

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
    int tf=0;
    String ca="";
    Context ctx = null;
    DataSource ds = null;
    Connection con = null;
    String strSql = null;
    PreparedStatement ps = null;
    ResultSet tu = null;

    try {

        ctx = new InitialContext();
        ds = (DataSource) ctx.lookup("java:comp/env/jdbc/Ikitter");
        con = ds.getConnection();

        /*ユーザー登録ｩｩｩｩｩ　後で改善します…*/
        if (session.getAttribute("twitter") != null) {
        strSql = "select * from user where userid = ?";
        ps = con.prepareStatement(strSql);
        ps.setString(1, user != null ? user.getScreenName() : null);
        tu = ps.executeQuery();
        while (tu.next()) {
            ca = tu.getString("category");
            tf = 1;
        }

        if(tf==0){
          strSql = "insert into user(name, userid,category,score) values(?,?,'','0')";
          ps = con.prepareStatement(strSql);
          ps.setString(1, user != null ? user.getName() : null);
          ps.setString(2, user != null ? user.getScreenName() : null);
          ps.executeUpdate();

          strSql = "insert into score(name,id,score,fabo,RT,RP,other) values(?,?,'0','0','0','0','0')";
          ps = con.prepareStatement(strSql);
          ps.setString(1, user != null ? user.getName() : null);
          ps.setString(2, user != null ? user.getScreenName() : null);
          ps.executeUpdate();
        }
      }
         /*ここまで　*/

       } catch (Exception e) {
           out.println("try block : " + e.getMessage());
           e.printStackTrace();
       } finally {
           try {
               if (tu != null) tu.close();
               if (con != null) con.close();
               if (ps != null) ps.close();
           } catch (Exception e) {
               System.out.println("finally block : " + e.getMessage());
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
<main>
    <header id="start_header">&nbsp;</header>
    <div id="start_header2">&nbsp;</div>
    <a href="home.jsp" id="ikitter_log">Ikitter</a>
    <img id="start_image" src="image/DSC_00042.jpg"/>
    <h2 id="start_position">集えイキリオタク達よ…</h2>
    <h2 id="start2_position">君の凄さを示せ！</h2>
    <a href="home.jsp" id="start_botan">始める！</a>
    <% //twitterオブジェクトが存在する場合(ログイン済みの場合)
        if (session.getAttribute("twitter") != null) { %>

    <a href="logout.jsp" id="login_botan">Logout</a>

    <% //そうでない場合
    } else { %>

    <a href="<%=authUrl%>" id="login_botan">Login</a>

    <% } %>
    <div id="footer_msk">

        <div id="footer-long">

            <a class="footer-dai" style="left: 70px;">Ikitter紹介</a>
            <a href="about.jsp" class="link" style="top: 45px; left: 70px;">・About</a>
            <a href="how.jsp" class="link" style="top: 85px; left: 70px;">・How</a>
            <a href="advertiser.jsp" class="link" style="top: 125px; left: 70px;">・Advertiser</a>

            <a class="footer-dai" style="left: 270px;">各種ページ</a>
            <a href="start.jsp" class="link" style="top: 45px; left: 270px;">・Start</a>
            <a href="home.jsp" class="link" style="top: 85px; left: 270px;">・Home</a>
            <a href="profile.jsp" class="link" style="top: 125px; left: 270px;">・Prifole</a>
            <a href="category.jsp" class="link" style="top: 165px; left: 270px;">・Category</a>

            <a class="footer-dai" style="left: 470px;">お知らせ</a>
            <a href="info.jsp" class="link" style="top: 45px; left: 470px;">・Info</a>
            <a href="http://gaiji4j.azurewebsites.net/" class="link" style="top: 85px; left: 470px;">・開発Blog</a>

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
            <a href="https://twitter.com/intent/tweet?text=%E3%81%BC%E3%81%8F%E3%81%9F%E3%81%8B%E3%82%86%E3%81%8D&url=http://example.jp/&hashtags=,Ikitter"
               onClick="window.open(encodeURI(decodeURI(this.href)), 'tweetwindow', 'width=650, height=470, personalbar=0, toolbar=0, scrollbars=1, sizable=1'); return false;"
               rel="nofollow" class="twitter-link"><img src="image/takayuki.png" alt="ツイート" width="96" height="30"/></a>
            <audio id="sound-file" preload="auto">
                <source src="sound/takayuki.wav" type="audio/wav">
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
            <a href="https://twitter.com/share?text=Ikitter%e3%82%92%e5%a7%8b%e3%82%81%e3%82%88%e3%81%86%ef%bc%81%0a&url=http://example.jp/&hashtags=,Ikitter,"
               onclick="
    window.open('https://twitter.com/share?text=Ikitter%e3%82%92%e5%a7%8b%e3%82%81%e3%82%88%e3%81%86%ef%bc%81%0a&url=http://example.jp/&hashtags=,Ikitter','subwin','width=650,height=470');
    return false;
 "><img src="image/shere.png" alt="ツイート" width="93" height="27"/></a>
        </div>

    </div>


</main>
</body>

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


</html>
