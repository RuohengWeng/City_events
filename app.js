//jshint esversion:6
//load required packages
const express = require("express");
const bodyParser = require("body-parser");
const ejs = require("ejs");
const https = require("https");
const session = require("express-session");
const mysql = require("mysql");

const app = express();
app.set("view engine", "ejs");

//let Express know we'll be using some of its packages
app.use(express.static("public"));
app.use(session({
	secret: 'secret',
	resave: true,
	saveUninitialized: true,
	rolling: true, // <-- Set `rolling` to `true`
 	cookie: {
	 httpOnly: true,
	 maxAge: 1*60*60*1000
 }
}));

app.use(bodyParser.urlencoded({extended: true}));
app.use(bodyParser.json());

//connect to city_events database using root user, password is null.
var connection = mysql.createConnection({
	host     : 'database-2.cpeikqvkgdx2.us-east-2.rds.amazonaws.com',
	port 		 : '3306',
	user     : 'Ruoheng',
	password : '05071997',
	database : 'City_events'
});

connection.connect(function(err) {
	// in case of error
	if (err) throw err;
  console.log("successfully connected to database!")
});

// execute sql queries to check if the city exist in the database, insert the city name if not exist.
function newCity(cityName) {
		var sqlQuery1 = 'SELECT * FROM cities WHERE city = ?'
		connection.query(sqlQuery1, cityName, function(err, results, fields) {
			if (err) throw err;
			if (results.length === 0) {
					var sqlQuery2 = 'INSERT INTO cities (city) VALUES (?)'
					connection.query(sqlQuery2, cityName, function(err, result){
						if (err) throw err;
						console.log("1 city record inserted");
					})
				}
		});
 }

// define a function to retrieve the events and weather data of the city searched by the user
function getCityData(cityName, res){
	var eventsData = []
	var sqlQuery = 'SELECT * FROM events WHERE city = ?'
	connection.query(sqlQuery, cityName, function(err, results, fields) {
		if (err) throw err;
		eventsData = results
	});

	const apiKeys = "&units=metric&appid=19b0467b41c9d3a4e2bd8d02947f96b7"
  const url = "https://api.openweathermap.org/data/2.5/weather?q=" + cityName +  apiKeys
  https.get(url, function(response){
    if (response.statusCode === 200) {
			response.on("data", function(data){
				newCity(cityName);
				const weatherData = JSON.parse(data);
				const temperature = weatherData.main.temp;
				const description = weatherData.weather[0].description;
				const icon = weatherData.weather[0].icon;
				const img = "https://openweathermap.org/img/wn/" + icon + "@2x.png";
				res.render("results", { weather: {city: cityName, temp: temperature, des: description, imgURL: img, events: eventsData} });
			});
		} else {
				res.render("events", {searchStatus: false});
		}
  });
}

//define url
app.get("/", function(req, res){
  res.render("home");
});

app.get("/login", function(req, res){
  res.render("login", {loginStatus: true});
});

app.get("/signup", function(req, res){
  res.render("signup", {signupStatus: true});
});

app.get("/events", function(req, res){
  res.render("events", {searchStatus: true});
});

app.get("/submit", function(req, res){
    if (req.session.loggedin){
      res.render("submit");
    } else{
      res.redirect("/login");
    }
});

// process post request from signup page, check if the user is pre registered
app.post("/signup", function(req, res){
	const email = req.body.email;
	const password = req.body.password;
	var sqlQuery1 = 'SELECT * FROM users WHERE email = ?'
	var sqlQuery2 = 'INSERT INTO users (email, password) VALUES (?, ?)'
	connection.query(sqlQuery1, email, function(err, results, fields) {
		if (err) throw err;
		if (results.length > 0) {
			res.render("signup", {signupStatus: false});
		} else {
			connection.query(sqlQuery2, [email, password], function(err, result) {
				if (err) throw err;
				console.log("1 user record inserted");
		    res.render("login", {loginStatus: true});
			});
		}
	});
});

// process post request from login page, check if the user give correct email and password
app.post("/login", function(req, res){
  var email = req.body.email;
	var password = req.body.password;
	var sqlQuery = 'SELECT * FROM users WHERE email = ? AND password = ?'
	connection.query(sqlQuery, [email, password], function(err, result, fields) {
		if (err) throw err;
		if (result.length === 1) {
			req.session.loggedin = true;
			req.session.email = email;
			req.session.username = result[0].username;
			res.redirect("/events");
		} else {
      res.render("login", {loginStatus: false});
		}
	});
});

// process post request from submit page, insert events submitted by users into events table
app.post("/submit", function(req, res){
	const cityName = req.body.cityName;
	const eventName = req.body.eventName;
	const eventTime = req.body.eventTime;
	const eventPlace = req.body.eventPlace;
	const creator = req.session.email;
	const eventInfo = req.body.eventInfo;
	const url = "https://api.openweathermap.org/data/2.5/weather?q=" + cityName +  "&units=metric&appid=19b0467b41c9d3a4e2bd8d02947f96b7"
	https.get(url, function(response){
    if (response.statusCode === 200) {
			var sqlQuery1 = 'INSERT INTO events (event, event_time, event_place, creator, city, event_info) VALUES (?, ?, ?, ?, ?, ?)'
			connection.query(sqlQuery1, [eventName, eventTime, eventPlace, creator, cityName, eventInfo], function(err, results, fields) {
				if (err) throw err;
				getCityData(cityName, res);
				console.log("1 event record inserted");
			});
		} else{
			res.render("events", {searchStatus: false});
		}
	});
});

// process post request from events page, get city data from users' search queries
app.post("/events", function(req, res){
	const cityName = req.body.cityName;
	getCityData(cityName, res);
});

app.listen(process.env.PORT || 3000, function(){
  console.log("server is running!");
})
