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


app.get("/search", function(req, res) {
    res.sendfile(__dirname + '/search.html', function(err) {
        if (err) res.send(404);
    });
});

app.post("/search", function(req, res) {
	//console.log(req.body);
	res.sendfile(__dirname + '/search.html', function(err) {
        if (err) res.send(404);
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
		var totalRes=[],categoryRes=[], priorityRes=[], labelRes=[], landmarkRes=[], tempRes=[];
		var labelbool=false, landmarkbool=false, categorybool=false, prioritybool=false;
		console.log(req.body.Search);
		
		
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
	});
});

app.get("/search/:pick", function(req, res) {
    res.send(render('pic_info.html', {
		pic : '"http://140.116.82.135:8000/photo_server/photo%20(' + req.params.pick + ').jpg"',
		title: 'yo'
	}));
});

port = process.env.PORT || 1001;
app.listen(port, function() {
    console.log("Listening on " + port);
});