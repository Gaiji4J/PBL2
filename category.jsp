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
    <a href="home.html" id="ikitter_log">Ikitter</a>
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
</body>

</html>
