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
    <h2 id="topdai">Ikitterについて</h2></div>
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
<h2 id="dai" class="ab1" style=" top: 120px; left: 185px;">概要</h2>
<p id="naka" class="ab1-1" style="top: 185px; left: 185px;">Twitterを愛し続けこれまでAkitter,Adutterなど過激なクライアントを提供してきたGaiji4J。
    <br>そんな彼らがついにイキリオタクが思う存分イキれる場所を提供する。それがIkitter。</p>
<h2 id="dai" class="ab2" style=" top: 260px; left: 185px;">カテゴリでランキング上位を目指せ</h2>
<p id="naka" class="ab2-1" style="top: 325px; left: 185px;">上位になれば自分の凄さが証明される。イキれる。さらに広告収入を得れる可能性も。使い方は<a
        href="how.jsp">こちら</a></p>
<h2 id="dai" class="ab3" style=" top: 380px; left: 185px;">広告主の方へ</h2>
<p id="naka" class="ab3-1" style="top: 450px; left: 185px;">世界中の人が利用しているTwitter。
    <br>その中でもかなりの拡散性を持つIkitterランキングの上位陣に広告を依頼してみませんか。詳しくは<a href="advertiser.jsp">こちら</a>
</p>
<footer id="start_footer">&nbsp;</footer>
<!--フッターらしい-->
<div id="start_footer2">&nbsp;</div>
<!--ヘッダー緑枠-->
<main>
</main>
</body>
</html>
