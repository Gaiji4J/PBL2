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
    <div id="footer-long">

        <a id="footer-dai" class="dai-1" style="left: 20px;">Ikitter紹介</a>
        <a href="about.jsp" id="link" class="aboutlink" style="top: 50px; left: 20px;">About</a>
        <a href="how.jsp" id="link" class="howlink" style="top: 100px; left: 20px;">How</a>
        <a href="advertiser.jsp" id="link" class="advertiserlink" style="top: 150px; left: 20px;">Advertiser</a>

        <a id="footer-dai" class="dai-2" style="left: 190px;">各種ページ</a>
        <a href="start.jsp" id="link" class="startlink" style="top: 50px; left: 195px;">Start</a>
        <a href="home.jsp" id="link" class="homelink" style="top: 100px; left: 195px;">Home</a>
        <a href="profile.jsp" id="link" class="profilelink" style="top: 150px; left: 195px;">Profile</a>
        <a href="category.jsp" id="link" class="categorylink" style="top: 200px; left: 195px;">Category</a>

        <a id="footer-dai" class="dai-3" style="left: 360px;">お知らせ</a>
        <a href="#.html" id="link" class="infolink" style="top: 50px; left: 365px;">Info</a>
        <a href="#.html" id="link" class="bloglink" style="top: 100px; left: 365px;">開発Blog</a>

        <a id="footer-dai" class="dai-1" style="left: 500px;">外部ツール</a>
        <a href="#.html" id="link" class="adutterlink" style="top: 50px; left: 505px;">Adutter</a>
        <a href="#.html" id="link" class="akitterlink" style="top: 100px; left: 505px;">Akitter</a>

        <a id="footer-dai" class="dai-1" style="left: 670px;">各種リンク</a>
        <a href="https://twitter.com" id="link" class="twitterlink" style="top: 50px; left: 673px;">Twitter</a>
        <a href="https://tweetdeck.twitter.com" id="link" class="decklink"
           style="top: 100px; left: 673px;">TweetDeck</a>
        <a href="https://ja.wikipedia.org/wiki/Twitter" id="link" class="wikilink" style="top: 150px; left: 673px;">Twitterとは</a>

        <a id="footer-dai" class="dai-1" style="left: 830px;">お問い合わせ</a>
        <a href="https://twitter.com/akiirokoutya" id="link" class="wikilink" style="top: 50px; left: 835px;">@秋色紅茶</a>

    </div>
    <div id="share-button">
        <a href="https://twitter.com/intent/tweet?button_hashtag=Ikitter&text=%E3%82%A4%E3%82%AD%E3%82%8A%E3%83%A9%E3%83%B3%E3%82%AD%E3%83%B3%E3%82%B0%E4%B8%8A%E4%BD%8D%E3%81%AB%E3%81%AA%E3%81%A3%E3%81%A6%E5%BA%83%E5%91%8A%E5%8F%8E%E5%85%A5%EF%BC%81%EF%BC%9F%E6%96%B0%E3%82%B5%E3%83%BC%E3%83%93%E3%82%B9Ikitter%EF%BC%81%E8%A9%B3%E3%81%97%E3%81%8F%E3%81%AF%E3%81%93%E3%81%A1%E3%82%89"
           class="twitter-hashtag-button" data-size="large" data-url="http://Ikitter.Gaiji4J">Tweet #Ikitter</a>
        <script>!function (d, s, id) {
            var js, fjs = d.getElementsByTagName(s)[0], p = /^http:/.test(d.location) ? 'http' : 'https';
            if (!d.getElementById(id)) {
                js = d.createElement(s);
                js.id = id;
                js.src = p + '://platform.twitter.com/widgets.js';
                fjs.parentNode.insertBefore(js, fjs);
            }
        }(document, 'script', 'twitter-wjs');</script>
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
                    _e: [], ready: function (f) {
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
</main>
</body>
</html>
