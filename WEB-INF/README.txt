+++++++++++++++++++++++++++++++++++++++++++++++++++++++
			READ ME				
+++++++++++++++++++++++++++++++++++++++++++++++++++++++
作　成　日：2017.09.08
更　新　日：2017.09.08
作　成　者：小谷　貴之
+++++++++++++++++++++++++++++++++++++++++++++++++++++++

Akitter＆Adutter配布サイト導入方法
1."teamb"のディレクトリを全てtomcatのwebappsに移動。
2.TomcatとMySQLを起動し、WEB-INF>myscript内のmysql_Ikitter.txtをコマンドで読み込み
　Ex) 	cd C:\apache-tomcat-8.0.33\webapps\Ikitter\WEB-INF\myscript
	 mysql -u root -p < mysql_Ikitter.txt

3.Tomcatを再起動（起動時にデータベースが無く、エラーが起こる為）
4.localhost:8080/Ikitterにアクセス