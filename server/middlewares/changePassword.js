var User = require('../mongo_modules/user.js');

module.exports = {
  changePassword : function(req,res,next) {
    var userid = req.userid;
    User.findOne({'_id' : userid},function(err,thisuser) {
      if(err){
        req.reJson['message'] = 'something wrong when get from the database';
        req.reJson['err'] = err;
        res.status(500).send(req.reJson);
      }else {
        if(thisuser){
          if(!thisuser.validPassword(req.body.oldpassword)){
            req.reJson = {'message' : 'wrong old password'};
            res.status(503).send(req.reJson);
          }else {
            thisuser.local.password = thisuser.generateHash(req.body.newpassword);
            thisuser.save(function(err) {
              if(err){
                req.reJson['message'] = 'something wrong when put into database';
                req.reJson['err'] = err;
                res.status(500).send(req.reJson);
              }else {
                req.reJson['message'] = 'OK!';
                res.status(200).send(req.reJson);
              }
            });
          }
        }
      }

    });
  }
}
