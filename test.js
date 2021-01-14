var http = require("http");
var mysql=require('mysql');
var connection = mysql.createConnection({
   host:"140.116.82.135",   //這邊要注意一下!!
   user:"DEH",
   password:"123456",
   database:"db2021",
   port : 3306
});
/*http.createServer(function (req, res) {
  res.writeHead(200, {"Connect-Type" : "text/html;charset=utf8"});
  res.write("<h3>ttt</h3><br/>");
  connection.connect(function(err) {
    if(err) {
      res.end('<p>Error</p>');
      console.log("aaa");
      return;
    } else {
      res.end('<p>Connect</p>');
      console.log("bbb");
    }
  });
}).listen(6868);*/

http.createServer(function (req, res) {
  //console.log(req);
  if(req.method == 'POST') {
    let body = '';
    req.on('data', chunk => {
      body += chunk.toString();
    });
    req.on('end', () => {
      console.log(typeof body);
      body = JSON.parse(body);
      connection.query('insert into photo_tags(title,  latitude, longitude, altitude, orientation, azimuth, weather, speed, address, era, category, keyword, description, reference, reason, companion, priority, contributor, url) values(' + '"' + body.title + '"' + ',' + body.latitude + ',' + body.longitude + ',' + body.altitude + ',' + '"' + body.orientation + '"' + ',' + body.azimuth + ','  + '"' + body.weather + '"' + ',' + body.speed + ',' + body.address + ',' + body.era + ',' + body.category + ',' + body.keyword + ',' + body.description + ',' + body.reference + ',' + body.reason + ',' + body.companion + ',' + body.priority + ',' + body.contributor + ',' + body.url + ');', function (errorinsert, resinsert){
        if(errorinsert) console.log(errorinsert);
        console.log(resinsert);
        console.log("insert!!!!!");
      });
      res.end('ok');
    });
  }
  /*
  res.writeHead(200, {"Content-Type" : "text/html;charset=utf8"});
  connection.query('insert into photo_tags(title) values("孔廟");', function (errorinsert, resinsert){
    if(errorinsert) console.log(errorinsert);
    console.log(resinsert);
    console.log("insert!!!!!");
  });
  */
}).listen(6868);
/*
var express=require('express');
var app=express();
app.get('/',function(req,res){
var sql=require('mssql');

//config for your database
 var config={
    user:'DEH',
    password:'aaa123456',
    server:'140.116.82.135\\SQLEXPRESS',   //這邊要注意一下!!
    database:'DB2020'
 };

//connect to your database
 sql.connect(config,function (err) {
   if(err) console.log(err);

//create Request object
   var request=new sql.Request();
request.query('select * from sysdiagrams',function(err,recordset){
   console.log(recordset[0].column1);
   if(err) console.log(err);

//send records as a response
   res.send(recordset);
   });
 });

});

var server=app.listen(5050,function(){
 console.log('Server is running!');
});*/
