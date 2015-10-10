var make = require('./maketoken.js');

//console.log(make.makeToken);
var ps = make.makeToken({'id' : '35'});
ps.then(function(argument) {
  console.log(argument);
  make.checkToken(argument+'s').then(function(message){
    console.log(message);
  }).catch(function(err) {
    console.log(err);
  });

}).catch(function(err) {
  if(err){
    console.log(err);
  }
});
