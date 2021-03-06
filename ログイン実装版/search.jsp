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
%>


<%
    request.setCharacterEncoding("UTF-8");
    String cname = request.getParameter("cname");
    String categoryArray[] = new String[5];
    int flag = 0;
    int i = 0;
    int cnt = 0;

    if (cname == "" || cname == null || cname.length() =
    >
    20
    )
    {
    flag
    =
    -
    1
    ;
    }

    Context
    ctx
    =
    null
    ;
    DataSource
    ds
    =
    null
    ;
    Connection
    con
    =
    null
    ;
    String
    strSql
    =
    null
    ;
    PreparedStatement
    ps
    =
    null
    ;
    PreparedStatement
    ps3
    =
    null
    ;
    ResultSet
    rs
    =
    null
    ;
    ResultSet
    rs3
    =
    null
    ;

    try
    {
    ctx
    =
    new
    InitialContext
    (
    )
    ;
    ds
    =
    (
    DataSource
    )
    ctx
    .
    lookup
    (
    "java:comp/env/jdbc/Ikitter"
    )
    ;
    con
    =
    ds
    .
    getConnection
    (
    )
    ;

    strSql
    =
    "select * from category where name= ?"
    ;
    ps
    =
    con
    .
    prepareStatement
    (
    strSql
    )
    ;
    ps
    .
    setString
    (
    1
    ,
    cname
    )
    ;
    rs
    =
    ps
    .
    executeQuery
    (
    )
    ;

    while
    (
    rs
    .
    next
    (
    )
    )
    {
    flag
    =
    1
    ;
    }

    strSql
    =
    "select * from category where name LIKE ?"
    ;
    ps3
    =
    con
    .
    prepareStatement
    (
    strSql
    )
    ;
    ps3
    .
    setString
    (
    1
    ,
    "%"
    +
    cname
    +
    "%"
    )
    ;
    rs3
    =
    ps3
    .
    executeQuery
    (
    )
    ;
    while
    (
    rs3
    .
    next
    (
    )
    &&
    cnt
    <=
    4
    )
    {
    categoryArray
    [
    cnt
    ]
    =
    rs3
    .
    getString
    (
    "name"
    )
    ;
    cnt
    ++
    ;
        /*メモ
        strSql="select * from category where name LIKE %?%;
        ps3.setString(1,cname);
        この書き方だとエラーが起きる*/
    }
    }
    catch
    (
    Exception
    e
    )
    {
    out
    .
    println
    (
    "try block : "
    +
    e
    .
    getMessage
    (
    )
    )
    ;
    e
    .
    printStackTrace
    (
    )
    ;
    }
    finally
    {
    try
    {
    if
    (
    rs
    !=
    null
    )
    rs
    .
    close
    (
    )
    ;
    if
    (
    rs3
    !=
    null
    )
    rs3
    .
    close
    (
    )
    ;
    if
    (
    con
    !=
    null
    )
    con
    .
    close
    (
    )
    ;
    if
    (
    ps
    !=
    null
    )
    ps
    .
    close
    (
    )
    ;
    if
    (
    ps3
    !=
    null
    )
    ps3
    .
    close
    (
    )
    ;
    }
    catch
    (
    Exception
    e
    )
    {
    System
    .
    out
    .
    println
    (
    "finally block : "
    +
    e
    .
    getMessage
    (
    )
    )
    ;
    e
    .
    printStackTrace
    (
    )
    ;
    }
    }

%>
