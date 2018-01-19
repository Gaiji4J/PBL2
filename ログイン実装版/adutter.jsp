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
<div>
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
    <img id="start_image" src="image/DSC_00042.jpg"/>
    <!--画像-->
</div>
<div id="akiadu_header">
    <h id="akiadu_top" style="top: 4px; left: 230px;">スマホで快適なTwitterライフ(Adutter)</h>
</div>
<div id="akiadu_back"></div>
<div id="akiadu_contents">
    <h2 id="akiadu_title" style=" top: 130px; left: 260px;">概要 </h2>
    <p id="akiadu_content" style="top: 185px; left: 260px;">わからない哲也(画像略）</p>
    <h2 id="akiadu_title" style=" top: 300px; left: 260px;">利用規約</h2>
    <p id="akiadu_content" style="top: 355px; left: 260px;">
        ・改変/二次配布禁止<br>
        ・利用により貴方に不利益が生じた場合、当方は一切責任持ちません。<br>
        ・強い依存性があります。ご利用は計画的に。</p>
    <h2 id="akiadu_title" style=" top: 470px; left: 260px;">ダウンロード </h2>
    <p id="akiadu_content" style="top: 525px; left: 260px;"><a
            href="https://play.google.com/store/apps/details?id=jp.haijin.aduzeus9yo.ranko&hl=ja">こちら</a>&nbsp;&nbsp;(GooglePlayストアに接続します。iPhone用はありませーん(tng)。)<br>動作環境：Android6.0以上
    </p>

</div>
</body>
</html>