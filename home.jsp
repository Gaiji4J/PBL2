<%@ page import="java.net.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="java.util.*" %>
<html lang="ja">
<head>
    <meta charset="utf-8">
    <link href="css/aki.css" rel="stylesheet">
    <link href="css/fab.css" rel="stylesheet">
    <link href="css/tk.css" rel="stylesheet">
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
    <title>Ikitter</title>
</head>

<%
out.println("<script type=\"text/javascript\">");
out.println("var rank = [ ];");
out.println("var category = [ ];");
out.println("var Participation = []");
out.println("var username = [ ];");
out.println("var userid = [ ];");
out.println("var score = [ ];");
out.println("var Categorylist = [];");
out.println("var Category2 = [];");


Context ctx = null;
DataSource ds = null;
Connection con = null;
String strSql = null;
PreparedStatement ps = null;
ResultSet rs = null;
PreparedStatement ps2 = null;
ResultSet rs2 = null;
PreparedStatement ps3 = null;
ResultSet rs3 = null;


int count=1;
int i=0;
int j=0;
try {
  ctx = new InitialContext( );
  ds = (DataSource)ctx.lookup("java:comp/env/jdbc/Ikitter");
  con = ds.getConnection();
  strSql = "select * from picranking";
  ps = con.prepareStatement(strSql);
  rs = ps.executeQuery( );
  while(rs.next( )){
    out.println("rank[" + i + "] = \'" + rs.getInt("rank") + "\';");
    out.println("category[" + i + "] = \'" + rs.getString("category") + "\';");
    out.println("username[" + i + "] = \'" + rs.getString("name") + "\';");
    out.println("userid[" + i + "] = \'" + rs.getString("userid") + "\';");
    out.println("score[" + i + "] = \'" + rs.getInt("score") + "\';");
    if((count % 6)==0){
      out.println("<!--カテゴリ挿入-->");
      out.println("Categorylist[" + j + "] = \'" + rs.getString("category") + "\';");
      j++;
    }
    count++;
    i++;
  }
  i=0;
  strSql="select * from piccategory";
  ps2 = con.prepareStatement(strSql);
  rs2 = ps2.executeQuery( );
    while(rs2.next()){
      out.println("Participation[" + i + "] = \'" + rs2.getInt("num") + "\';");
      i++;
    }
    i=0;
    strSql="select * from category";
    ps3 = con.prepareStatement(strSql);
    rs3 = ps3.executeQuery( );
    while(rs3.next()){
      out.println("Category2[" + i + "] = \'" + rs3.getString("name") + "\';");
      System.out.println("Category2[" + i + "] = \'" + rs3.getString("name") + "\';");
      i++;
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

  out.println("</script>");
%>

<!--ガイジコード書いてすいません。-->

<body>
    <dvi>
        <div id="test"></div>
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
    </dvi>
    <!--プロフィール枠**************************************u****************************-->
    <div id="profile_space">
        <div id="profile_backcolor"></div>
        <div id="login_font">ログインはこちら</div>
        <!--
        <input type="text" id="id_input" required="required" placeholder="Twitter ID" />
        <input type="password" id="pass_input" required="required" placeholder="Twitter PASS" />
        -->
        <input type="submit" id="login_Button" value="LOGIN" />
        <p><a href="https://twitter.com/account/begin_password_reset" id="forgot_font">Forgot Twitter Account</a></p>
        <p><a id="forgot_font2">Ikitterを始めよう。</a></p>

    </div>

    <!--プロフィール枠******************************************************************-->
    <!--ピックアップ******************************************************************-->
    <div id="pickup_top">PICK UP</div>

    <script>
        document.write('<dvi>');
        document.write('<dvi id="pickup_menu_space">');
        document.write('<dvi id="pickup_up">');
        document.write('<img class="yaimg" src="image/ya.jpg" style="top:3px;left:73px;" />');
        document.write('<img class="yaimg1" src="image/ya1.jpg" style="top:431px;left:73px;" />');
        document.write('<dvi class="menu_up"></dvi>');
        document.write('<dvi class="menu_up_msk"></dvi>');
        document.write('<dvi class="menu_down"></dvi>');
        document.write('<dvi class="menu_down_msk"></dvi>');
        document.write('</dvi>');
        document.write('<dvi id="pickup_menu_space_mask">');
        document.write('<dvi id="pickup_menu">');
        document.write('<ul class="list_ui">');
      </script>
<!--
    <script>
        Categorylist.push("Gaiji4J");
        Categorylist.push("アニメ");
        Categorylist.push("ゲーム");
        Categorylist.push("ツイ廃");
        Categorylist.push("可愛い");
        Categorylist.push("グルメ");
        Categorylist.push("野球");
        Categorylist.push("動物");
        Categorylist.push("おしゃれ");
        Categorylist.push("YouTuber");
        Categorylist.push("イラスト");
        Categorylist.push("フレンズ");
        Categorylist.push("Gaiji4J");
        Categorylist.push("アニメ");
        Categorylist.push("ゲーム");
        Categorylist.push("ツイ廃");
        Categorylist.push("可愛い");
        Categorylist.push("グルメ");
        Categorylist.push("野球");
        Categorylist.push("動物");
        Categorylist.push("おしゃれ");
        Categorylist.push("YouTuber");
        Categorylist.push("イラスト");
        Categorylist.push("フレンズ");
        </script>
-->
        <script>
        for (listcount = 0; listcount <= Categorylist.length; listcount++) {
            document.write(' <li class="Category_list">' + Categorylist[listcount] + '</li>');
        }
        document.write('</ul>');
        document.write('</dvi>');
        document.write('</dvi>');
        document.write('</dvi>');
        document.write('</dvi>');

    </script>
    <!--menu:hover------------------------>
    <script type="text/javascript">
        $(".menu_up_msk").hover(
            function() {
                $('.menu_up').css({
                    'background-color': 'rgba(0, 0, 0, 0.3)'
                });
            },
            function() {
                $('.menu_up').css({
                    'background-color': 'rgba(250, 250, 250, 0)'
                });
            }
        );

        $(".menu_down_msk").hover(
            function() {
                $('.menu_down').css({
                    'background-color': 'rgba(0, 0, 0, 0.3)'
                });
            },
            function() {
                $('.menu_down').css({
                    'background-color': 'rgba(250, 250, 250, 0)'
                });
            }
        );

    </script>
    <!--menu:hover------------------------>
    <!--カテゴリメニュー　UP・DOWN------------------------>
    <script type="text/javascript">
        var udcount = 0;
        var size = $('.Category_list').length;
        $(function() {
            $(".menu_up_msk").click(function() {
                var offu = $('#pickup_menu').offset();
                if (udcount != 0) {
                    $('#pickup_menu').offset({
                        top: offu.top + 44.5,
                    });
                    udcount -= 1;
                }
            });
        });

        $(function() {
            $(".menu_down_msk").click(function() {
                var offd = $('#pickup_menu').offset();
                if (udcount != (size - 10)) {
                    $('#pickup_menu').offset({
                        top: offd.top - 44.5,
                    });
                    udcount += 1;
                }
            });
        });

    </script>
    <!--カテゴリメニュー　UP・DOWN------------------------>


    <!--
    <p id="jtest">クリックしたアイテムのインデックス番号：<strong id="res"></strong></p>
    <ul id="jtest2">
        <li>インデックス０</li>
        <li>インデックス１</li>
    </ul>
-->
    <!--ピックアップ1位～6位とかのやーつ-->


    <script>
        aki = -1;
        var size = $('.Category_list').length;
        for (d = 0; d <= size; d++) {
            document.write('<div id="pickup' + d + '" class="pickup" style="position: absolute;top: 67px;left: 341px;width: 950px;height: 460px; z-index: ' + (1 - d) + '; background-color: #3BA2C2;>');

            basstop = 40; //top基本
            c = 1; //img
            for (i = 1; i <= 3; i++) {
                bassleft = 0; //left基本
                for (j = 1; j <= 2; j++) {
                    aki++;
                    if (c == 1) {
                        document.write('<img class="pick_img" src="image/aki' + c + '.jpg" style="position: absolute; left:' + bassleft + 'px; top:' + basstop + 'px">');
                    }
                    document.write('<img class="pick_img" src="image/tes' + c + '.jpg" style="position: absolute; left:' + bassleft + 'px; top:' + basstop + 'px">');
                    document.write('<img class="pick_icon" src="image/pp' + c + '.jpg" style="position: absolute; left:' + (bassleft + 10 - (-2 * j)) + 'px; top:' + (basstop + 54) + 'px" />');
                    document.write('<img class="pick_rank" src="image/' + c + '.png" style="position: absolute; left:' + (bassleft + 12 - (-1 * j)) + 'px; top:' + (basstop - 4) + 'px" />');
                    document.write(' <div class="pick_bassfont" style="position: absolute; left:' + (bassleft + 79 - (-1 * j)) + 'px; top:' + (basstop + 3) + 'px">カテゴリ：</div>');
                    document.write('<div class="pick_Category" style="position: absolute; left:' + (bassleft + 179 - (-1 * j)) + 'px; top:' + (basstop + 3) + 'px" >'+category[aki]+'</div>');
                    document.write('<div class="rank_id" style="position: absolute; left:' + (bassleft + 79 - (-1 * j)) + 'px; top:' + (basstop + 53) + 'px">'+ userid[aki] +'</div>');
                    document.write(' <div class="rank_name" style="position: absolute; left:' + (bassleft + 79 - (-1 * j)) + 'px; top:' + (basstop + 28) + 'px">'+ username[aki] +'</div>');
                    document.write('<div class="rank_score" style="position: absolute; left:' + (bassleft + 84 - (-6 * j)) + 'px; top:' + (basstop + 73) + 'px">'+ score[aki] +'</div>');
                    document.write('<div class="rank_mask" style="position: absolute; left:' + (bassleft + 75 - (-1 * j)) + 'px; top:' + (basstop + 7) + 'px"></div>');
                    document.write(' <div class="rank_linkmask"  style="position: absolute; left:' + bassleft + 'px; top:' + (basstop) + 'px"><a href="https://twitter.com/'+ userid[aki] +'" class="a_link"></a></div>');
                    bassleft += 376;
                    c++;

                    document.write('</img>');
                }
                basstop += 120;

            }
            document.write('<div class="participant">参加人数：' + Participation[d] + '</div>');
            document.write('<div class="participant2">盛り上がり度：' + (d+1) + '</div>');
            document.write('</div>');

        }

    </script>
    <!--ピックアップ******************************************************************-->

    <!-- テストCODE -->

    <script type="text/javascript">
        isc = 0;
        $(function() {
            $("li").click(function() {
                var size = $('.Category_list').length;
                isc++;
                var index = $("li").index(this);
                $("#res").text("" + index + isc + "").css("color", "red");
                for (e = 0; e <= size; e++) {
                    $('#pickup' + e).css('z-index', -2);
                }
                $('#pickup' + index).css('z-index', 2);

            });
        });

    </script>




    <!--フッター-->
    <div id="footer_msk">

        <div id="footer-long">

            <a class="footer-dai" style="left: 70px;">Ikitter紹介</a>
            <a href="about.html" class="link" style="top: 45px; left: 70px;">・About</a>
            <a href="how.html" class="link" style="top: 85px; left: 70px;">・How</a>
            <a href="advertiser.html" class="link" style="top: 125px; left: 70px;">・Advertiser</a>

            <a class="footer-dai" style="left: 270px;">各種ページ</a>
            <a href="start.html" class="link" style="top: 45px; left: 270px;">・Start</a>
            <a href="home.html" class="link" style="top: 85px; left: 270px;">・Home</a>
            <a href="profile.html" class="link" style="top: 125px; left: 270px;">・Prifile</a>
            <a href="category.jsp" class="link" style="top: 165px; left: 270px;">・Category</a>

            <a class="footer-dai" style="left: 470px;">お知らせ</a>
            <a href="#.html" class="link" style="top: 45px; left: 470px;">・Info</a>
            <a href="#.html" class="link" style="top: 85px; left: 470px;">・開発Blog</a>

            <a class="footer-dai" style="left: 670px;">外部ツール</a>
            <a href="#.html" class="link" style="top: 45px; left: 670px;">・Adutter</a>
            <a href="#.html" class="link" style="top: 85px; left: 670px;">・Akitter</a>

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
                window.twttr = (function(d, s, id) {
                    var t, js, fjs = d.getElementsByTagName(s)[0];
                    if (d.getElementById(id)) return;
                    js = d.createElement(s);
                    js.id = id;
                    js.src = "https://platform.twitter.com/widgets.js";
                    fjs.parentNode.insertBefore(js, fjs);
                    return window.twttr || (t = {
                        _e: [],
                        ready: function(f) {
                            t._e.push(f)
                        }
                    });
                }(document, "script", "twitter-wjs"));

                twttr.ready(function(twttr) {
                    twttr.events.bind('tweet', function(event) {
                        console.log('ツイート完了');
                        document.getElementById('sound-file').play();
                    });
                });

            </script>
        </div>
        <div id="share-button">
            <a href="https://twitter.com/intent/tweet?button_hashtag=Ikitter&text=%E3%82%A4%E3%82%AD%E3%82%8A%E3%83%A9%E3%83%B3%E3%82%AD%E3%83%B3%E3%82%B0%E4%B8%8A%E4%BD%8D%E3%81%AB%E3%81%AA%E3%81%A3%E3%81%A6%E5%BA%83%E5%91%8A%E5%8F%8E%E5%85%A5%EF%BC%81%EF%BC%9F%E6%96%B0%E3%82%B5%E3%83%BC%E3%83%93%E3%82%B9Ikitter%EF%BC%81%E8%A9%B3%E3%81%97%E3%81%8F%E3%81%AF%E3%81%93%E3%81%A1%E3%82%89" class="twitter-hashtag-button" data-size="large" data-url="http://Ikitter.Gaiji4J">Tweet #Ikitter</a>
            <script>
                ! function(d, s, id) {
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
            function() {
                $('.footer-dai').css({
                    'font-size': '28px'
                });
            },
            function() {
                $('.footer-dai').css({
                    'font-size': '18px'
                });
            }
        );

    </script>
    <!--フッダー用スクリプト-->

    <!--下のランダム検索お気に入りスペース-->
    <div class="free_title">カテゴリ一覧：検索</div>
    <div class="view_back"></div>
    <div id="underspace0" class="us">
        <p class="category_p2">検索したいカテゴリーを入力してください。</p>
        <form action="#" method="post">
            <input class="category_s2" type="search" name="search" placeholder="カテゴリを入力">
            <input class="category_s_button2" type="submit" name="submit" value="検索">
        </form>
        <div class="content">
        </div>
    </div>
    <ul id="nav">
        <li id="search_ward"><a>並び替え</a>
            <ul>
                <li class="li_ward"><a class="li0">検索</a></li>
                <li class="li_ward"><a class="li1">新着</a></li>
                <li class="li_ward"><a class="li2">古参</a></li>
                <li class="li_ward"><a class="li3">ランダム</a></li>
                <li class="li_ward"><a class="li4">人数</a></li>
            </ul>
        </li>
    </ul>
    <!--スクリプト ページ表示-->
    <script type="text/javascript">
        $(function() {
            $('.li_ward').click(function() {
                var index = $(this).index();
                var ui_ward = $('ul#nav').find('.li' + index).text();
                alert('要素:' + index + '番目' + ui_ward + 'ワード' + Text);
                var title_switch = $(".free_title").text();
                $('.us').css('height', 200 + 'px');
                /*↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓新着処理↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓*/
                if (ui_ward == '新着') {
                    alert('新着順で表示しろ');
                    $('body').append('<div id="underspace1" class="us"></div>');
                    var search_list = new Array();
                    /* 小谷くんが追加したときにこの間のコードはコメント化して
                    var baseStr = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
                    var result = "";
                    for (ssi = 0; ssi < 100; ssi++) {
                        for (var si = 0; si < 20; si++) {
                            result += baseStr.charAt(Math.floor(Math.random() * 62));
                        }
                        search_list.push(result);
                        result = "";
                    }
                    search_list.push('てすと１');
                    search_list.push('てすと２');
                    alert('xxxxxxxxxxxxxxxxxxxxxxxxxxxx');
                    /* 小谷くんが追加したときにこの間のコードはコメント化して */
                    alert(Category2.length);
                    var end = Category2.length;
                    var sc = 0;
                    var ssc = 0;
                    $('.search_font').remove();
                    while (sc != end) {
                        if ((sc % 2) == 0) {
                            $('#underspace1').append('<div class="search_font" style="top:' + (10 + ((sc - ssc) * 35)) + 'px;">' + Category2[sc] + '</div>');
                            sc++;
                        } else {
                            $('#underspace1').append('<div class="search_font" style="top:' + (10 + (ssc * 35)) + 'px;left:400px;">' + Category2[sc] + '</div>');
                            ssc++;
                            sc++;
                        }
                    }
                    $('.us').css('height', 30 + ((sc - ssc) * 35) + 'px');
                    alert(Math.floor(end / 2));
                } else if (ui_ward == '古参') {
                    alert('古参順で表示しろ');
                    $('body').append('<div id="underspace2" class="us"></div>');

                    /*↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓古参処理↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓*/
                    var search_list = new Array();
                    /* 小谷くんが追加したときにこの間のコードはコメント化して
                    var baseStr = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
                    var result = "";
                    for (ssi = 0; ssi < 100; ssi++) {
                        for (var si = 0; si < 20; si++) {
                            result += baseStr.charAt(Math.floor(Math.random() * 62));
                        }
                        search_list.push(result);
                        result = "";
                    }
                    search_list.push('てすと１');
                    search_list.push('てすと２');
                    alert('xxxxxxxxxxxxxxxxxxxxxxxxxxxx');
                    /* 小谷くんが追加したときにこの間のコードはコメント化して */
                    alert(Category2.length);
                    var end = Category2.length;
                    var sc = 0;
                    var ssc = 0;
                    $('.search_font').remove();
                    while (sc != end) {
                        if ((sc % 2) == 0) {
                            $('#underspace2').append('<div class="search_font" style="top:' + (10 + ((sc - ssc) * 35)) + 'px;">' + Category2[end - sc - 1] + '</div>');
                            sc++;
                        } else {
                            $('#underspace2').append('<div class="search_font" style="top:' + (10 + (ssc * 35)) + 'px;left:400px;">' + Category2[end - sc - 1] + '</div>');
                            ssc++;
                            sc++;
                        }
                    }
                    $('.us').css('height', 30 + ((sc - ssc) * 35) + 'px');
                    alert(Math.floor(end / 2));

                    /*↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ランダム処理↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓*/
                } else if (ui_ward == 'ランダム') {
                    alert('ランダムで表示しろ');
                    $('body').append('<div id="underspace3" class="us"></div>');
                    var search_list = new Array();
                    /* 小谷くんが追加したときにこの間のコードはコメント化して
                    var baseStr = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
                    var result = "";
                    for (ssi = 0; ssi < 100; ssi++) {
                        for (var si = 0; si < 20; si++) {
                            result += baseStr.charAt(Math.floor(Math.random() * 62));
                        }
                        search_list.push(result);
                        result = "";
                    }
                    search_list.push('てすと１');
                    search_list.push('てすと２');
                    alert('xxxxxxxxxxxxxxxxxxxxxxxxxxxx');
                    for (var i = search_list.length - 1; i > 0; i--) {
                        var r = Math.floor(Math.random() * (i + 1));
                        var tmp = search_list[i];
                        search_list[i] = search_list[r];
                        search_list[r] = tmp;
                    }
                    /* 小谷くんが追加したときにこの間のコードはコメント化して */
                    alert(Category2.length);
                    var end = Category2.length;
                    var sc = 0;
                    var ssc = 0;
                    $('.search_font').remove();
                    while (sc != end) {
                        if ((sc % 2) == 0) {
                            $('#underspace3').append('<div class="search_font" style="top:' + (10 + ((sc - ssc) * 35)) + 'px;">' + Category2[sc] + '</div>');
                            sc++;
                        } else {
                            $('#underspace3').append('<div class="search_font" style="top:' + (10 + (ssc * 35)) + 'px;left:400px;">' + Category2[sc] + '</div>');
                            ssc++;
                            sc++;
                        }
                    }
                    $('.us').css('height', 30 + ((sc - ssc) * 35) + 'px');
                    alert(Math.floor(end / 2));　　
                    /*-----------------------------------------------------------------------------------------------------------------*/
                } else if (ui_ward == '人数') {
                    alert('人数で表示しろks');
                    $('body').append('<div id="underspace4" class="us"></div>');
                    /*↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓人数処理↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓*/
                    var search_list = new Array();
                    /* 小谷くんが追加したときにこの間のコードはコメント化して
                    var baseStr = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
                    var result = "";
                    for (ssi = 0; ssi < 100; ssi++) {
                        for (var si = 0; si < 20; si++) {
                            result += baseStr.charAt(Math.floor(Math.random() * 62));
                        }
                        search_list.push(result + ':' + (end - ssi) + '人');
                        result = "";
                    }
                    search_list.push('てすと１');
                    search_list.push('てすと２');
                    alert('xxxxxxxxxxxxxxxxxxxxxxxxxxxx');
                    /* 小谷くんが追加したときにこの間のコードはコメント化して */
                    alert(Category2.length);
                    var end = Category2.length;
                    var sc = 0;
                    var ssc = 0;
                    $('.search_font').remove();
                    while (sc != end) {
                        if ((sc % 2) == 0) {
                            $('#underspace4').append('<div class="search_font" style="top:' + (10 + ((sc - ssc) * 35)) + 'px;">' + Category2[sc] + '</div>');
                            sc++;
                        } else {
                            $('#underspace4').append('<div class="search_font" style="top:' + (10 + (ssc * 35)) + 'px;left:400px;">' + Category2[sc] + '</div>');
                            ssc++;
                            sc++;
                        }
                    }
                    $('.us').css('height', 30 + ((sc - ssc) * 35) + 'px');
                    alert(Math.floor(end / 2));
                    /*--------------------------------------------------------------------------------------------------------------------*/
                }
                $(".free_title").html('カテゴリ一覧：' + ui_ward);
                $('.us').css('z-index', -2);
                $('#underspace' + index).css('z-index', 5);

            });
        });
    </script>
    <!--下のランダム検索お気に入りスペース-->



</body>

</html>
