<%--
＼＼ ／:::::::::::::::::::::::::::::::::::く
　　r'::::::::::::::::::::;;:;;:;;:ｯ､:::::::::::）
＼ レ''''jrTf"　　　　lﾐ::::::::く　Gaiji以外は
　　 |　　　　　　　　〈ﾐ:::::::::ﾉ
＼　|､_　ｬー‐__二ゞ ヾ::∠
｀`　ゞ:}　 ￣'互.ヾ　　}:j んＬ　見ないでくれないか！
　　　l/　　 """"´｀　 　 )ﾉ∧
=-- /　　 　 　 　 　 l　 (ノ　|
=＝ `弋"__,....._ 　 　 !　 ! 　 Y⌒Y⌒Y⌒
　　　　 ﾞ､`ー‐'　　　　 ,'　　　　　　　＼
''"´　　　 ﾞ､￣　 　 ／ ,'　　　　　　　　 ＼
／　　　　 ヽ＿_／::;' ,'　ノ　　　　　　　｀ヽ
　 ／／　　　　　 ヾ_,'∠..,,__
／／　//　　　／´
--%>
<%@ page contentType="text/html" pageEncoding="UTF-8" import="oauth.signpost.*,twitter4j.*"%>
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

<html>

<%  //twitterオブジェクトが存在する場合(ログイン済みの場合)
    if (session.getAttribute("twitter") != null) { %>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Twitter OAuth認証完了</title>
</head>
<body>
    <p>Twitter OAuth認証完了</p>
    <dl>
        <dt>user_id</dt><dd><%=user != null ? user.getScreenName() : null%></dd>
    </dl>
    <input type="button" value="Logout" onclick="location.href='logout.jsp'"/>
</body>

<%  //そうでない場合
    } else { %>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Twitter OAuth認証開始</title>
</head>
<body>
    <p><a href="<%=authUrl%>">Twitter OAuth認証開始</a></p>
</body>

<% } %>

</html>