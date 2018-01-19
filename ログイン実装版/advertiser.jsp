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


<header id="about_header">
</header>
<!--ヘッダーらしい-->
<div id="start_header2">
    <h2 id="topdai">広告主の方へ</h2></div>
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
<img id="start_image" src="image/DSC_00042.jpg"/>
<!--画像-->

<!-------------about------------------>
<div id="ab_back"></div>
<h2 id="dai" class="ad1" style=" top: 120px; left: 185px;">概要 </h2>
<p id="naka" class="ad_-1" style="top: 185px; left: 185px;">Ikitterのランキング上位者は強い拡散性を持っています。沢山のユーザにツイートを見られる機会が多いからです。<br>我々はこの拡散性を利用し広告に活用する事ができる場を提供したいと考えました。
</p>
<h2 id="dai" class="ad2" style=" top: 260px; left: 185px;">こんな方におすすめ</h2>
<p id="naka" class="ad2-1" style="top: 325px; left: 185px;">広告費の少ない企業や個人で制作活動をしてる方。レスポンスがある層へ広告の範囲を絞る事で費用対効果を高めたい方。
    <br>例：アニメ上位の人に対して、漫画家/同人作家/イラストレーター。
    <br>例：自撮り女子の上位の人に対して、化粧品/アプリ/カフェ。</p>
<h2 id="dai" class="ad3" style=" top: 430px; left: 185px;">広告の依頼方法</h2>
<p id="naka" class="ad3-1" style="top: 495px; left: 185px;">こちらが依頼に関与することはありません。<br>Twitterのダイレクトメッセージ機能を通じ連絡を取っていただき、
    契約内容などを話し合っていただきます。</p>
<footer id="start_footer">&nbsp;</footer>
<!--フッターらしい-->
<div id="start_footer2">&nbsp;</div>
<!--ヘッダー緑枠-->
<main>
</main>
</body>
</html>