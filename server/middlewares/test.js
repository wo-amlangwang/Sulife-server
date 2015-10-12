var make = require('./maketoken.js');
var middlewares = require('./middlewares.js');
//console.log(make.makeToken);
make.checkToken('eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6IjU2MWIxOGMzZmU1Mjg0NzNhZWY2YWI4NyIsImlhdCI6MTQ0NDY4OTU5NiwiZXhwIjoxNDQ0Nzc1OTk2fQ.aT9ZMHLmTx2lirKLjyThpP_8ihqkRDEDbum1Fa9JadM').then(function(decoded) {
  console.log(decoded);
}).catch(function(err){
  console.log(err);
});
