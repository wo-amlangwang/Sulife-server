var express = require('express');
var app = express();
var mongoose = require('mongoose');
var flash = require('connect-flash');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var session = require('express-session');
var passport = require('passport');


var port = process.env.PORT || 4000;
app.listen(port,function(err) {
  if(err) {
    console.log(err);
    process.exit();
  } else {
    console.log('Server is listening on ' + port);
  }
});
