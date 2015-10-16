var User = require('../mongo_modules/user.js');
module.exports = {
  findUser : function(req,res,next){
    User.findOne({'local.email' : req.body.email},function(err,user) {
      if(err){
        req.reJson['message'] = 'something wrong when get data from database';
        req.reJson['err'] = err;
        res.status(500).send(req.reJson);
      }else {
        req.reJson['message'] = 'OK! User followed';
        req.reJson['user'] = user;
        res.status(200).send(req.reJson);
      }
    });
  }
}
