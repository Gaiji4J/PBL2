<%@ page contentType="text/html" pageEncoding="UTF-8" import="oauth.signpost.*,twitter4j.*" %>
<%@ page import="twitter4j.auth.AccessToken" %>
<%@ page import="oauth.signpost.exception.OAuthMessageSignerException" %>
<%@ page import="oauth.signpost.exception.OAuthNotAuthorizedException" %>
<%@ page import="oauth.signpost.exception.OAuthExpectationFailedException" %>
<%@ page import="oauth.signpost.exception.OAuthCommunicationException" %>
<%@ page import="oauth.signpost.basic.DefaultOAuthProvider" %>
<%@ page import="oauth.signpost.basic.DefaultOAuthConsumer" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
    User user = null;
    Twitter twitter = null;
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
            twitter = new TwitterFactory().getInstance();
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
        twitter = (Twitter) session.getAttribute("twitter");
        try {
            user = twitter.verifyCredentials();
        } catch (TwitterException e) {
            e.printStackTrace();
        }
    }
%>

<%

    int fav = 0;
    int ret = 0;
    int word = 0;

    double score = 0;


    ResponseList<Status> tl = null;
    assert twitter != null;
    try {
        tl = twitter.getUserTimeline(new Paging(1,100));
    } catch (TwitterException e) {
        e.printStackTrace();
    }

    assert tl != null;
    for(Status status : tl)
    {
        fav += status.getFavoriteCount();
        ret += status.getRetweetCount();
        if (status.getText().matches(".*" + "カテゴリ単語" + ".*")) word++;
    }

    assert user != null;
    score = (fav * 1.2) + (ret * 1.5) + (word * 2) + (user.getFollowersCount() * 0.2);

    System.out.print(score);

    int flag = 0;
    Context ctx = null;
    DataSource ds = null;
    Connection con = null;
    String strSql = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
      ctx = new InitialContext( );
      ds = (DataSource)ctx.lookup("java:comp/env/jdbc/Ikitter");
      con = ds.getConnection();
      strSql = "select * from score where id = ? ";
      ps = con.prepareStatement(strSql);
      ps.setString(1,user != null ? user.getScreenName() : null);
      rs = ps.executeQuery( );
      while(rs.next( )){
        strSql = "UPDATE score SET score = ? , fabo= ? , RT = ? where id=?";
        ps = con.prepareStatement(strSql);
        ps.setDouble(1,score);
        ps.setInt(2, fav);
        ps.setInt(3, ret);
        ps.setString(4, user != null ? user.getScreenName() : null);
        ps.executeUpdate( );

        flag = 1;
      }

      if(flag==0){
        strSql = "insert into score(name,id,score,fabo,RT) values(?,?,?,?,?)";
        ps = con.prepareStatement(strSql);
        ps.setString(1, user != null ? user.getName() : null);
        ps.setString(2, user != null ? user.getScreenName() : null);
        ps.setDouble(3, score);
        ps.setInt(4, fav);
        ps.setInt(5, ret);
        ps.executeUpdate();
      }

    }catch(Exception e) {
        out.println("try block : " + e.getMessage( ));
        e.printStackTrace( );
        } finally {
          try {
            if (rs != null) rs.close( );
            if (con != null) con.close( );
            if (ps != null) ps.close( );
          } catch(Exception e) {
            System.out.println("finally block : " + e.getMessage( ));
            e.printStackTrace( );
            }
        }
%>
