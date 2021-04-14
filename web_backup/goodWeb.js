var http = require("http");
var mysql=require('mysql');
var connection = mysql.createConnection({
   host:"140.116.82.135",
   user:"DEH1",
   password:"!abc12345",
   database:"db2021",
   port : 3306
   //useConnectionPooling: true
});

var bodyParser = require('body-parser');
var jsonParser = bodyParser.json()
var express = require("express"),
app = express();
app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json());

var fs = require('fs');
function render(filename, params) {
  var data = fs.readFileSync(filename, 'utf8');
  for (var key in params) {
    data = data.replace('{' + key + '}', params[key]);
  }
  return data;
}

var totalRes=[];
var choosed_pic=[];
var temp_result=[];
//autoring get
app.get("/authoring", function(req, res) {
    res.send(render('authoring.html', {
				title_1:'',
				title_2:'',
				title_3:'',
				title_4:'',
				title_5:'',
				
				pic_1 : choosed_pic.length>0 ? '"http://140.116.82.135:8000/photo_server/photo%20(' + choosed_pic[0] + ').jpg"' : '""',
				pic_2 : choosed_pic.length>1 ? '"http://140.116.82.135:8000/photo_server/photo%20(' + choosed_pic[1] + ').jpg"' : '""',
				pic_3 : choosed_pic.length>2 ? '"http://140.116.82.135:8000/photo_server/photo%20(' + choosed_pic[2] + ').jpg"' : '""',
				pic_4 : choosed_pic.length>3 ? '"http://140.116.82.135:8000/photo_server/photo%20(' + choosed_pic[3] + ').jpg"' : '""',
				pic_5 : choosed_pic.length>4 ? '"http://140.116.82.135:8000/photo_server/photo%20(' + choosed_pic[4] + ').jpg"' : '""',
				
				line_1:'',
				line_2:'',
				line_3:'',
				line_4:'',
				line_5:'',
				
		
    }));
});

//authoring post
app.post("/authoring", function(req, res) {
	var title = req.body.title;
	var description = req.body.description;
	var category = req.body.category;
	var contributor = req.body.contributor;
	
	var ll = choosed_pic.length;
	for(var i=0; i<=5-ll-1; ++i)
		choosed_pic.push(-1);
	
	connection.query('insert into poi(photo_id0,photo_id1,photo_id2,photo_id3,photo_id4,title,description,category,contributor) values('+ '"' + choosed_pic[0] + '"' + ',' + '"' + choosed_pic[1] + '"' + ','+'"' + choosed_pic[2] + '"' + ','+'"' + choosed_pic[3] + '"' + ','+'"' + choosed_pic[4] + '"' + ',' +'"' + title + '"' + ',' +'"' + description + '"' + ',' +'"' + category + '"' + ',' +'"' + contributor + '"' + ');', function (errorinsert, resinsert){
        if(errorinsert) console.log(errorinsert);
		console.log(resinsert);
        console.log("insert!!!!!");
		
		res.send(render('authoring.html', {
		pic_1 : choosed_pic.length>0 ? '"http://140.116.82.135:8000/photo_server/photo%20(' + choosed_pic[0] + ').jpg"' : '""',
		pic_2 : choosed_pic.length>1 ? '"http://140.116.82.135:8000/photo_server/photo%20(' + choosed_pic[1] + ').jpg"' : '""',
		pic_3 : choosed_pic.length>2 ? '"http://140.116.82.135:8000/photo_server/photo%20(' + choosed_pic[2] + ').jpg"' : '""',
		pic_4 : choosed_pic.length>3 ? '"http://140.116.82.135:8000/photo_server/photo%20(' + choosed_pic[3] + ').jpg"' : '""',
		pic_5 : choosed_pic.length>4 ? '"http://140.116.82.135:8000/photo_server/photo%20(' + choosed_pic[4] + ').jpg"' : '""',
		line_1: choosed_pic.length > 0 ? '-----------------------------------------------------': '',
		line_2: choosed_pic.length > 1 ? '-----------------------------------------------------': '',
		line_3: choosed_pic.length > 2 ? '-----------------------------------------------------': '',
		line_4: choosed_pic.length > 3 ? '-----------------------------------------------------': '',
		line_5: choosed_pic.length > 4 ? '-----------------------------------------------------': '',
		}));
	});
    
	choosed_pic=[];
	console.log(title);
	console.log(description);
	console.log(category);
	console.log(contributor);
});

app.get("/search", function(req, res) {
	console.log(req.headers['referer']);
	var head="http://140.116.82.135:8000/photo_server/photo%20(", rear=").jpg";
	if(req.headers['referer'] &&req.headers['referer'] != "http://140.116.82.135:1001/authoring")
		choosed_pic.push(totalRes[ req.headers['referer'][req.headers['referer'].length-1] - 1 ]);
	console.log(choosed_pic);
    res.send(render('search.html', {
				choosed_pic_1 : choosed_pic.length>0 ? '"http://140.116.82.135:8000/photo_server/photo%20(' + choosed_pic[0] + ').jpg"' : '""',
				choosed_pic_2 : choosed_pic.length>1 ? '"http://140.116.82.135:8000/photo_server/photo%20(' + choosed_pic[1] + ').jpg"' : '""',
				choosed_pic_3 : choosed_pic.length>2 ? '"http://140.116.82.135:8000/photo_server/photo%20(' + choosed_pic[2] + ').jpg"' : '""',
				choosed_pic_4 : choosed_pic.length>3 ? '"http://140.116.82.135:8000/photo_server/photo%20(' + choosed_pic[3] + ').jpg"' : '""',
				choosed_pic_5 : choosed_pic.length>4 ? '"http://140.116.82.135:8000/photo_server/photo%20(' + choosed_pic[4] + ').jpg"' : '""',
		
				del1 : choosed_pic.length>0 ? '<input type="submit" name="del" value="刪除"/>' : '',
				del2 : choosed_pic.length>1 ? '"刪除"' : '""',
				del3 : choosed_pic.length>2 ? '"刪除"' : '""',
				del4 : choosed_pic.length>3 ? '"刪除"' : '""',
				del5 : choosed_pic.length>4 ? '"刪除"' : '""',
		
				title_1: totalRes.length > 0 ? temp_result[totalRes[0]-1].title : '',
				title_2: totalRes.length > 1 ? temp_result[totalRes[1]-1].title : '',
				title_3: totalRes.length > 2 ? temp_result[totalRes[2]-1].title : '',
				title_4: totalRes.length > 3 ? temp_result[totalRes[3]-1].title : '',
				title_5: totalRes.length > 4 ? temp_result[totalRes[4]-1].title : '',
				title_6: totalRes.length > 5 ? temp_result[totalRes[5]-1].title : '',
				title_7: totalRes.length > 6 ? temp_result[totalRes[6]-1].title : '',
				title_8: totalRes.length > 7 ? temp_result[totalRes[7]-1].title : '',
				title_9: totalRes.length > 8 ? temp_result[totalRes[8]-1].title : '',
				title_10: totalRes.length > 9 ? temp_result[totalRes[9]-1].title : '',
				title_11: totalRes.length > 10 ? temp_result[totalRes[10]-1].title : '',
				title_12: totalRes.length > 11 ? temp_result[totalRes[11]-1].title : '',
				title_13: totalRes.length > 12 ? temp_result[totalRes[12]-1].title : '',
				title_14: totalRes.length > 13 ? temp_result[totalRes[13]-1].title : '',
				title_15: totalRes.length > 14 ? temp_result[totalRes[14]-1].title : '',
				title_16: totalRes.length > 15 ? temp_result[totalRes[15]-1].title : '',
				title_17: totalRes.length > 16 ? temp_result[totalRes[16]-1].title : '',
				title_18: totalRes.length > 17 ? temp_result[totalRes[17]-1].title : '',
				title_19: totalRes.length > 18 ? temp_result[totalRes[18]-1].title : '',
				title_20: totalRes.length > 19 ? temp_result[totalRes[19]-1].title : '',
				
				pic_1: totalRes.length > 0 ? head + totalRes[0].toString() +rear : '""',
				pic_2: totalRes.length > 1 ? head + totalRes[1].toString() +rear : '""',
				pic_3: totalRes.length > 2 ? head + totalRes[2].toString() +rear : '""',
				pic_4: totalRes.length > 3 ? head + totalRes[3].toString() +rear : '""',
				pic_5: totalRes.length > 4 ? head + totalRes[4].toString() +rear : '""',
				pic_6: totalRes.length > 5 ? head + totalRes[5].toString() +rear : '""',
				pic_7: totalRes.length > 6 ? head + totalRes[6].toString() +rear : '""',
				pic_8: totalRes.length > 7 ? head + totalRes[7].toString() +rear : '""',
				pic_9: totalRes.length > 8 ? head + totalRes[8].toString() +rear : '""',
				pic_10: totalRes.length > 9 ? head + totalRes[9].toString() +rear : '""',
				pic_11: totalRes.length > 10 ? head + totalRes[10].toString() +rear : '""',
				pic_12: totalRes.length > 11 ? head + totalRes[11].toString() +rear : '""',
				pic_13: totalRes.length > 12 ? head + totalRes[12].toString() +rear : '""',
				pic_14: totalRes.length > 13 ? head + totalRes[13].toString() +rear : '""',
				pic_15: totalRes.length > 14 ? head + totalRes[14].toString() +rear : '""',
				pic_16: totalRes.length > 15 ? head + totalRes[15].toString() +rear : '""',
				pic_17: totalRes.length > 16 ? head + totalRes[16].toString() +rear : '""',
				pic_18: totalRes.length > 17 ? head + totalRes[17].toString() +rear : '""',
				pic_19: totalRes.length > 18 ? head + totalRes[18].toString() +rear : '""',
				pic_20: totalRes.length > 19 ? head + totalRes[19].toString() +rear : '""',
				
				line_1: totalRes.length > 0 ? '-----------------------------------------------------': '',
				line_2: totalRes.length > 1 ? '-----------------------------------------------------': '',
				line_3: totalRes.length > 2 ? '-----------------------------------------------------': '',
				line_4: totalRes.length > 3 ? '-----------------------------------------------------': '',
				line_5: totalRes.length > 4 ? '-----------------------------------------------------': '',
				line_6: totalRes.length > 5 ? '-----------------------------------------------------': '',
				line_7: totalRes.length > 6 ? '-----------------------------------------------------': '',
				line_8: totalRes.length > 7 ? '-----------------------------------------------------': '',
				line_9: totalRes.length > 8 ? '-----------------------------------------------------': '',
				line_10: totalRes.length > 9 ? '-----------------------------------------------------': '',
				line_11: totalRes.length > 10 ? '-----------------------------------------------------': '',
				line_12: totalRes.length > 11 ? '-----------------------------------------------------': '',
				line_13: totalRes.length > 12 ? '-----------------------------------------------------': '',
				line_14: totalRes.length > 13 ? '-----------------------------------------------------': '',
				line_15: totalRes.length > 14 ? '-----------------------------------------------------': '',
				line_16: totalRes.length > 15 ? '-----------------------------------------------------': '',
				line_17: totalRes.length > 16 ? '-----------------------------------------------------': '',
				line_18: totalRes.length > 17 ? '-----------------------------------------------------': '',
				line_19: totalRes.length > 18 ? '-----------------------------------------------------': '',
				line_20: totalRes.length > 19 ? '-----------------------------------------------------': '""'
				
		
    }));
});
app.post("/search", function(req, res) {
	if(req.body.pic)
		choosed_pic.splice(req.body.pic-1, 1);
	console.log(choosed_pic);
	
	totalRes=[];
	//res.sendfile(__dirname + '/search.html', function(err) {
        //if (err) res.send(404);
		var Search = req.body.Search;
		var listCheck = ['title','date','keyword','description','reference','contributor'];
		var titleCheck = req.body.title, dateCheck=req.body.date, keywordCheck=req.body.keyword, descriptionCheck=req.body.description, referenceCheck = req.body.reference, contributorCheck =req.body.contributor, categoryCheck=req.body.category ,priorityCheck = req.body.priority;
		var list = [];
		list.push(titleCheck);
		list.push(dateCheck);
		list.push(keywordCheck);
		list.push(descriptionCheck);
		list.push(referenceCheck);
		list.push(contributorCheck);
		var labelCheck = req.body.label, landmarkCheck = req.body.landmark;
		var labellist = ['label0', 'label1', 'label2', 'label3', 'label4', 'label5', 'label6', 'label7', 'label8', 'label9', 'label10', 'label11', 'label12', 'label13', 'label14', 'label15', 'label16', 'label17', 'label18', 'label19', 'label20', 'label21', 'label22', 'label23', 'label24', 'label25', 'label26', 'label27', 'label28', 'label29', 'label30'];
		var landmarklist = ['landmark0','landmark1','landmark2','landmark3','landmark4','landmark5'];
		var categoryRes=[], priorityRes=[], labelRes=[], landmarkRes=[], tempRes=[];
		var labelbool=false, landmarkbool=false, categorybool=false, prioritybool=false;
		var head="http://140.116.82.135:8000/photo_server/photo%20(", rear=").jpg";
		var labelSplit= [];
		var searchSplit =[];
		console.log(req.body.Search);
		if(labelCheck!=null)
			labelSplit = labelCheck.split(' ');
		if(Search!=null)
			searchSplit = Search.split(' ');
		console.log(labelSplit);
		console.log(searchSplit);
		
		
		//搜尋勾選項目
		for(var l=0 ; l<6 ;l++)
		{
			if(list[l] == listCheck[l])
			{
			connection.query("SELECT id FROM photo_tags WHERE " + listCheck[l] + " = "+ "'" +Search+ "'", function (err, result, fields) {
				if (err) throw err;
				for(var i=0; i < result.length ;i++)
				{
					if(totalRes.indexOf(result[i].id) == -1)
						totalRes.push(result[i].id);
				}
			});
			}
		}
		
		//搜尋label
		if(labelCheck == "")
		{
			labelRes.push(-69);
		}
		else
		{
			for(var l=0 ; l<31 ;l++)
			{
				connection.query("SELECT id FROM vision_api WHERE " + labellist[l] + " = "+ "'" +labelCheck+ "'", function (err, result, fields) {
					if (err) throw err;
					for(var i=0; i < result.length ;i++)
					{
						if(labelRes.indexOf(result[i].id) == -1)
							labelRes.push(result[i].id);
					}
				});
			}
		}
		
		//搜尋landmark
		if(landmarkCheck == "")
		{
			landmarkRes.push(-69);
		}
		else
		{
			for(var l=0 ; l<6 ;l++)
			{
				connection.query("SELECT id FROM vision_api WHERE " + landmarklist[l] + " = "+ "'" +landmarkCheck+ "'", function (err, result, fields) {
					if (err) throw err;
					for(var i=0; i < result.length ;i++)
					{
						if(landmarkRes.indexOf(result[i].id) == -1)
							landmarkRes.push(result[i].id);
					}
				});
			}
		}
		
		//搜尋category
		if(categoryCheck=="All")
		{
			categoryRes.push(-69);
		}
		else
		{
			connection.query("SELECT id FROM photo_tags WHERE category = "+ "'" +categoryCheck+ "'", function (err, result, fields) {
					if (err) throw err;
					for(var i=0; i < result.length ;i++)
					{
						if(categoryRes.indexOf(result[i].id) == -1)
							categoryRes.push(result[i].id);
					}
			});
		}
		
		//搜尋priority
		if(priorityCheck == 0)
		{
			priorityRes.push(-69);
		}
		else
		{
			connection.query("SELECT id FROM photo_tags WHERE priority = "+ "'" +priorityCheck+ "'", function (err, result, fields) {
					if (err) throw err;
					for(var i=0; i < result.length ;i++)
					{
						if(priorityRes.indexOf(result[i].id) == -1)
							priorityRes.push(result[i].id);
					}
			});
		}
		
		//取and 跟 show出來
		connection.query("SELECT id FROM vision_api WHERE landmark0 = "+ "'" +landmarkCheck+ "'", function (err, result, fields) {
			for(var i in totalRes)
			{
				if(labelRes[0]==-69)
					labelbool = true;
				else
					labelbool = labelRes.indexOf(totalRes[i]) != -1;
				
				if(landmarkRes[0]==-69)
					landmarkbool = true;
				else
					landmarkbool = landmarkRes.indexOf(totalRes[i]) != -1;
					
				if(categoryRes[0]==-69)
					categorybool = true;
				else
					categorybool = categoryRes.indexOf(totalRes[i]) != -1;
					
				if(priorityRes[0]==-69)
					prioritybool = true;
				else
					prioritybool = priorityRes.indexOf(totalRes[i]) != -1;
					
				if(labelbool && landmarkbool && categorybool && prioritybool)
					tempRes.push(totalRes[i]);
			}
			if (err) throw err;
			console.log("totalRes為:");
			console.log(totalRes);
			console.log("categoryRes為:");
			console.log(categoryRes);
			console.log("priorityRes為:");
			console.log(priorityRes);
			console.log("labelRes為:");
			console.log(labelRes);
			console.log("landmarkRes為:");
			console.log(landmarkRes);
			console.log("tempRes為:");
			console.log(tempRes);
			totalRes = tempRes;
			
		});
		
		//設定pic line url
		connection.query("SELECT title FROM photo_tags WHERE id < " + "'" + 10000 + "'", function (err, result, fields) {
			temp_result = result;
			if (err) throw err;
			res.send(render('search.html', {
				choosed_pic_1 : choosed_pic.length>0 ? '"http://140.116.82.135:8000/photo_server/photo%20(' + choosed_pic[0] + ').jpg"' : '""',
				choosed_pic_2 : choosed_pic.length>1 ? '"http://140.116.82.135:8000/photo_server/photo%20(' + choosed_pic[1] + ').jpg"' : '""',
				choosed_pic_3 : choosed_pic.length>2 ? '"http://140.116.82.135:8000/photo_server/photo%20(' + choosed_pic[2] + ').jpg"' : '""',
				choosed_pic_4 : choosed_pic.length>3 ? '"http://140.116.82.135:8000/photo_server/photo%20(' + choosed_pic[3] + ').jpg"' : '""',
				choosed_pic_5 : choosed_pic.length>4 ? '"http://140.116.82.135:8000/photo_server/photo%20(' + choosed_pic[4] + ').jpg"' : '""',
				
				del1 : choosed_pic.length>0 ? '<input type="submit" name="del" value="刪除"/>' : '',
				del2 : choosed_pic.length>1 ? '"刪除"' : '""',
				del3 : choosed_pic.length>2 ? '"刪除"' : '""',
				del4 : choosed_pic.length>3 ? '"刪除"' : '""',
				del5 : choosed_pic.length>4 ? '"刪除"' : '""',
				
				title_1: totalRes.length > 0 ? result[totalRes[0]-1].title : '',
				title_2: totalRes.length > 1 ? result[totalRes[1]-1].title : '',
				title_3: totalRes.length > 2 ? result[totalRes[2]-1].title : '',
				title_4: totalRes.length > 3 ? result[totalRes[3]-1].title : '',
				title_5: totalRes.length > 4 ? result[totalRes[4]-1].title : '',
				title_6: totalRes.length > 5 ? result[totalRes[5]-1].title : '',
				title_7: totalRes.length > 6 ? result[totalRes[6]-1].title : '',
				title_8: totalRes.length > 7 ? result[totalRes[7]-1].title : '',
				title_9: totalRes.length > 8 ? result[totalRes[8]-1].title : '',
				title_10: totalRes.length > 9 ? result[totalRes[9]-1].title : '',
				title_11: totalRes.length > 10 ? result[totalRes[10]-1].title : '',
				title_12: totalRes.length > 11 ? result[totalRes[11]-1].title : '',
				title_13: totalRes.length > 12 ? result[totalRes[12]-1].title : '',
				title_14: totalRes.length > 13 ? result[totalRes[13]-1].title : '',
				title_15: totalRes.length > 14 ? result[totalRes[14]-1].title : '',
				title_16: totalRes.length > 15 ? result[totalRes[15]-1].title : '',
				title_17: totalRes.length > 16 ? result[totalRes[16]-1].title : '',
				title_18: totalRes.length > 17 ? result[totalRes[17]-1].title : '',
				title_19: totalRes.length > 18 ? result[totalRes[18]-1].title : '',
				title_20: totalRes.length > 19 ? result[totalRes[19]-1].title : '',
				
				pic_1: totalRes.length > 0 ? head + totalRes[0].toString() +rear : '""',
				pic_2: totalRes.length > 1 ? head + totalRes[1].toString() +rear : '""',
				pic_3: totalRes.length > 2 ? head + totalRes[2].toString() +rear : '""',
				pic_4: totalRes.length > 3 ? head + totalRes[3].toString() +rear : '""',
				pic_5: totalRes.length > 4 ? head + totalRes[4].toString() +rear : '""',
				pic_6: totalRes.length > 5 ? head + totalRes[5].toString() +rear : '""',
				pic_7: totalRes.length > 6 ? head + totalRes[6].toString() +rear : '""',
				pic_8: totalRes.length > 7 ? head + totalRes[7].toString() +rear : '""',
				pic_9: totalRes.length > 8 ? head + totalRes[8].toString() +rear : '""',
				pic_10: totalRes.length > 9 ? head + totalRes[9].toString() +rear : '""',
				pic_11: totalRes.length > 10 ? head + totalRes[10].toString() +rear : '""',
				pic_12: totalRes.length > 11 ? head + totalRes[11].toString() +rear : '""',
				pic_13: totalRes.length > 12 ? head + totalRes[12].toString() +rear : '""',
				pic_14: totalRes.length > 13 ? head + totalRes[13].toString() +rear : '""',
				pic_15: totalRes.length > 14 ? head + totalRes[14].toString() +rear : '""',
				pic_16: totalRes.length > 15 ? head + totalRes[15].toString() +rear : '""',
				pic_17: totalRes.length > 16 ? head + totalRes[16].toString() +rear : '""',
				pic_18: totalRes.length > 17 ? head + totalRes[17].toString() +rear : '""',
				pic_19: totalRes.length > 18 ? head + totalRes[18].toString() +rear : '""',
				pic_20: totalRes.length > 19 ? head + totalRes[19].toString() +rear : '""',
				
				line_1: totalRes.length > 0 ? '-----------------------------------------------------': '',
				line_2: totalRes.length > 1 ? '-----------------------------------------------------': '',
				line_3: totalRes.length > 2 ? '-----------------------------------------------------': '',
				line_4: totalRes.length > 3 ? '-----------------------------------------------------': '',
				line_5: totalRes.length > 4 ? '-----------------------------------------------------': '',
				line_6: totalRes.length > 5 ? '-----------------------------------------------------': '',
				line_7: totalRes.length > 6 ? '-----------------------------------------------------': '',
				line_8: totalRes.length > 7 ? '-----------------------------------------------------': '',
				line_9: totalRes.length > 8 ? '-----------------------------------------------------': '',
				line_10: totalRes.length > 9 ? '-----------------------------------------------------': '',
				line_11: totalRes.length > 10 ? '-----------------------------------------------------': '',
				line_12: totalRes.length > 11 ? '-----------------------------------------------------': '',
				line_13: totalRes.length > 12 ? '-----------------------------------------------------': '',
				line_14: totalRes.length > 13 ? '-----------------------------------------------------': '',
				line_15: totalRes.length > 14 ? '-----------------------------------------------------': '',
				line_16: totalRes.length > 15 ? '-----------------------------------------------------': '',
				line_17: totalRes.length > 16 ? '-----------------------------------------------------': '',
				line_18: totalRes.length > 17 ? '-----------------------------------------------------': '',
				line_19: totalRes.length > 18 ? '-----------------------------------------------------': '',
				line_20: totalRes.length > 19 ? '-----------------------------------------------------': '""'
				
				
				
			}));
			console.log(result);
			
		});
	//});
});

app.get("/search/:pick", function(req, res) {
	connection.query("SELECT * FROM photo_tags AS a INNER JOIN vision_api AS b ON a.id=b.id WHERE a.id=" + "'" + totalRes[req.params.pick-1] + "'", function (err, result, fields) {
		var label = [], landmark = []
		var k=0;
		for(var i=0; i<31; ++i) {
			label.push("NULL");
			if(result[0]["label"+i.toString()]!="NULL")
				label[k++]=(result[0]["label"+i.toString()]);
		}
		k=0;
		for(var i=0; i<6; ++i) {
			landmark.push("NULL");
			if(result[0]["landmark"+i.toString()]!="NULL")
				landmark[k++]=(result[0]["landmark"+i.toString()]);
		}
		res.send(render('pic_info.html', {
			pic : '"http://140.116.82.135:8000/photo_server/photo%20(' + totalRes[req.params.pick-1] + ').jpg"',
			title: result[0].title=='NULL' ? '' : result[0].title,
			date: result[0].date=='NULL' ? '' : result[0].date,
			latitude: result[0].latitude=='NULL' ? '' : result[0].latitude,
			altitude: result[0].altitude=='NULL' ? '' : result[0].altitude,
			longitude: result[0].longitude=='NULL' ? '' : result[0].longitude,
			orientation: result[0].orientation=='NULL' ? '' : result[0].orientation,
			azimuth: result[0].azimuth=='NULL' ? '' : result[0].azimuth,
			weather: result[0].weather=='NULL' ? '' : result[0].weather,
			address: result[0].address=='NULL' ? '' : result[0].address,
			era: result[0].era=='NULL' ? '' : result[0].era,
			category: result[0].category=='NULL' ? '' : result[0].category,
			keyword: result[0].keyword=='NULL' ? '' : result[0].keyword,
			description: result[0].description=='NULL' ? '' : result[0].description,
			reference: result[0].reference=='NULL' ? '' : result[0].reference,
			companion: result[0].companion=='NULL' ? '' : result[0].companion,
			priority: result[0].priority=='NULL' ? '' : result[0].priority,
			contributor: result[0].contributor=='NULL' ? '' : result[0].contributor,
			label0: label[0]=='NULL' ? '' : label[0],
			label1: label[1]=='NULL' ? '' : label[1],
			label2: label[2]=='NULL' ? '' : label[2],
			label3: label[3]=='NULL' ? '' : label[3],
			label4: label[4]=='NULL' ? '' : label[4],
			label5: label[5]=='NULL' ? '' : label[5],
			label6: label[6]=='NULL' ? '' : label[6],
			label7: label[7]=='NULL' ? '' : label[7],
			label8: label[8]=='NULL' ? '' : label[8],
			label9: label[9]=='NULL' ? '' : label[9],
			label10: label[10]=='NULL' ? '' : label[10],
			label11: label[11]=='NULL' ? '' : label[11],
			label12: label[12]=='NULL' ? '' : label[12],
			label13: label[13]=='NULL' ? '' : label[13],
			label14: label[14]=='NULL' ? '' : label[14],
			label15: label[15]=='NULL' ? '' : label[15],
			label16: label[16]=='NULL' ? '' : label[16],
			label17: label[17]=='NULL' ? '' : label[17],
			label18: label[18]=='NULL' ? '' : label[18],
			label19: label[19]=='NULL' ? '' : label[19],
			label20: label[20]=='NULL' ? '' : label[20],
			label21: label[21]=='NULL' ? '' : label[21],
			label22: label[22]=='NULL' ? '' : label[22],
			label23: label[23]=='NULL' ? '' : label[23],
			label24: label[24]=='NULL' ? '' : label[24],
			label25: label[25]=='NULL' ? '' : label[25],
			label26: label[26]=='NULL' ? '' : label[26],
			label27: label[27]=='NULL' ? '' : label[27],
			label28: label[28]=='NULL' ? '' : label[28],
			label29: label[29]=='NULL' ? '' : label[29],
			label30: label[30]=='NULL' ? '' : label[30],
			landmark0: landmark[0]=='NULL' ? '' : landmark[0],
			landmark1: landmark[1]=='NULL' ? '' : landmark[1],
			landmark2: landmark[2]=='NULL' ? '' : landmark[2],
			landmark3: landmark[3]=='NULL' ? '' : landmark[3],
			landmark4: landmark[4]=='NULL' ? '' : landmark[4],
			landmark5: landmark[5]=='NULL' ? '' : landmark[5]
		}));
	});	
});

port = process.env.PORT || 1001;
app.listen(port, function() {
    console.log("Listening on " + port);
});