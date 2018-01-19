/*
 * mysql1.js
 * Copyright (C) 2014 kaoru <kaoru@bsd>
 */
var db_host = '127.0.0.1';
var db_user = 'root';
var db_pw = 'celica';
var db_name = 'test';

var mysql = require('mysql');
var mysql_options = {
        host: db_host,
        user: db_user,
        password: db_pw,
        database: db_name
};
var my_client = mysql.createConnection(mysql_options);
my_client.connect();

var sql = 'select * from user';

var db_host = '127.0.0.1';
var db_user = 'root';
var db_pw = '';
var db_name = 'test';

var mysql = require('mysql');
var mysql_options = {
        host: db_host,
        user: db_user,
        password: db_pw,
        database: db_name
};
var my_client = mysql.createConnection(mysql_options);
my_client.connect();

var sql = 'select * from user';

my_client.query(sql, function (err, rows, fields) {
        if (err) {
                console.log('can not connect');
                console.log(err);
                return;
        }

        for (var i in rows) {
                console.log(rows[i]);
        }
});
my_client.end();
