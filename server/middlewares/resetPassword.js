var User = require('../mongo_modules/user.js');
var Profile = require('../mongo_modules/profile.js');
var randomstring = require("randomstring");
var sendEmail = require('./support/emailSystem/sendEmail.js').sendEmail;

module.exports = {
  resetPassword : function(req,res,next) {
    req.reJson = {};
    var username = req.body.username;
    User.findOne({'local.email' : username},function(err,thisuser) {
      if(thisuser){
        Profile.findOne({'userid' : thisuser.id} , function(err, thisprofile) {
          if(thisprofile.email == undefined || thisprofile.email == null){
            req.reJson = {'message' : 'no email for this user'};
            res.status(503).send(req.reJson);
          }else {
            var newpassword = randomstring.generate(6);
            thisuser.local.password = thisuser.generateHash(newpassword);
            thisuser.save(function(err) {
              if(err){
                req.reJson['message'] = 'something wrong when put into database';
                req.reJson['err'] = err;
                res.status(500).send(req.reJson);
              }else {
                sendEmail({'subject' : 'Password Reset',
                           'text' : 'Hi,\n  Thank you for using Sulife! your new password is ' + newpassword}, thisprofile.email);
                req.reJson['message'] = 'OK!';
                res.status(200).send(req.reJson);
              }
            });
          }
        })
      }else {
        req.reJson = {'message' : 'no such user'};
        res.status(503).send(req.reJson);
      }
    });
  }
}
