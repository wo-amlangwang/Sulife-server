var jwt = require('jsonwebtoken');
var key = require('./config').mykey;
module.exports={
  makeToken : function(userid) {
    var ps = new Promise(function(fullfill,reject){
      var token = jwt.sign(userid,key,{expiresInMinutes : 1440},{ algorithm: 'RS256'});
      fullfill(token);
    });
    return ps;
  },
  checkToken : function(token) {
    var ps = new Promise(function(fullfill,reject){
      var decoded = jwt.verify(token, key, function(err,decoded) {
        if(err)
          reject(err);
        else {
          fullfill(decoded);
        }
      });
    });
    return ps;
  }
}
