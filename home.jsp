<html lang="ja">

<head>
    <meta charset="utf-8">
    <link href="css/ikitter.css" rel="stylesheet">
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
    <title>Ikitter</title>
</head>

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
        <div id="login_font">Ikitterを始めよう！</div>
        <input type="text" id="id_input" required="required" placeholder="Twitter ID" />
        <input type="password" id="pass_input" required="required" placeholder="Twitter PASS" />
        <input type="submit" id="login_Button" value="LOGIN" />
        <p><a href="https://twitter.com/account/begin_password_reset" id="forgot_font">Forgot Twitter Account</a></p>
    </div>

    <!--プロフィール枠******************************************************************-->
    <!--ピックアップ******************************************************************-->
    <div id="pickup_top">PICK UP</div>
    <dvi>
        <dvi id="pickup_menu_space">
            <dvi id="pickup_menu_space_mask">
                <dvi id="pickup_menu">
                    <ul class="list_ui">
                        <li class="Category_list">Gaiji4J</li>
                        <li class="Category_list">アニメ</li>
                        <li class="Category_list">ゲーム</li>
                        <li class="Category_list">ツイ廃</li>
                        <li class="Category_list">可愛い</li>
                        <li class="Category_list">グルメ</li>
                        <li class="Category_list">野球</li>
                        <li class="Category_list">動物</li>
                        <li class="Category_list">おしゃれ</li>
                        <li class="Category_list">YouTuber</li>
                        <li class="Category_list">イラスト</li>
                        <li class="Category_list">キチガイ</li>
                        <li class="Category_list">フレンズ</li>
                        <li class="Category_list">アライさん</li>
                    </ul>
                </dvi>
            </dvi>
        </dvi>

        <p id="jtest">クリックしたアイテムのインデックス番号：<strong id="res"></strong></p>
        <ul id="jtest2">
            <li>インデックス０</li>
            <li>インデックス１</li>
        </ul>
    </dvi>


    <!--ピックアップ1位～6位とかのやーつ-->
    <script>
        aki = 0;
        var size = $('.Category_list').length;
        for (d = 0; d <= size; d++) {
            document.write('<div id="pickup' + d + '" class="pickup" style="position: absolute;top: 67px;left: 341px;width: 950px;height: 460px; z-index: ' + (1 - d) + '; background-color: #373737;> ');
            basstop = 40; //top基本
            c = 1; //img
            for (i = 1; i <= 3; i++) {
                bassleft = 0; //left基本
                for (j = 1; j <= 2; j++) {
                    aki++;
                    if (c == 1) {
                        document.write('<img class="pick_img" src="image/aki' + c + '.jpg" style="position: absolute; left:' + bassleft + 'px; top:' + basstop + 'px">');
                    }
                    document.write('<img class="pick_img" src="image/aki' + c + '.jpg" style="position: absolute; left:' + bassleft + 'px; top:' + basstop + 'px">');
                    document.write('<img class="pick_icon" src="image/ico.jpg" style="position: absolute; left:' + (bassleft + 10 - (-2 * j)) + 'px; top:' + (basstop + 54) + 'px" />');
                    document.write('<img class="pick_rank" src="image/' + c + '.png" style="position: absolute; left:' + (bassleft + 12 - (-1 * j)) + 'px; top:' + (basstop - 4) + 'px" />');
                    document.write(' <div class="pick_bassfont" style="position: absolute; left:' + (bassleft + 79 - (-1 * j)) + 'px; top:' + (basstop + 3) + 'px">カテゴリ：</div>');
                    document.write('<div class="pick_Category" style="position: absolute; left:' + (bassleft + 179 - (-1 * j)) + 'px; top:' + (basstop + 3) + 'px" >Gaiji4J</div>');
                    document.write('<div class="rank_id" style="position: absolute; left:' + (bassleft + 79 - (-1 * j)) + 'px; top:' + (basstop + 53) + 'px">@akiirokoutya</div>');
                    document.write(' <div class="rank_name" style="position: absolute; left:' + (bassleft + 79 - (-1 * j)) + 'px; top:' + (basstop + 28) + 'px">秋色紅茶' + aki + '</div>');
                    document.write('<div class="rank_score" style="position: absolute; left:' + (bassleft + 84 - (-6 * j)) + 'px; top:' + (basstop + 73) + 'px">50000点</div>');
                    document.write('<div class="rank_mask" style="position: absolute; left:' + (bassleft + 75 - (-1 * j)) + 'px; top:' + (basstop + 7) + 'px"></div>');
                    document.write(' <div class="rank_linkmask"  style="position: absolute; left:' + bassleft + 'px; top:' + (basstop) + 'px"><a href="https://twitter.com/akiirokoutya" class="a_link"></a></div>');
                    bassleft += 376;
                    c++;
                    document.write('</img>');
                }
                basstop += 120;
            }
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
                alert(size);
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
    <div id="start_footer2">&nbsp;</div>
    <a href="home.html" id="top_link">Home</a>
    <a href="profile.html" id="profile_link">Profile</a>
    <a href="category.html" id="category_link">Category</a>




</body>

</html>
