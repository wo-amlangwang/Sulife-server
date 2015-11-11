var Profile = require('../mongo_modules/profile.js');
module.exports = {
  editProfile : function(req,res,next) {
    Profile.findOne({'userid' : req.userid},function(err, profile) {
      if(err){
        req.reJson['message'] = 'something wrong when get data from database';
        req.reJson['err'] = err;
        res.status(500).send(req.reJson);
      }else {
        if(!profile){
          var newProfile = new Profile();
          newProfile.userid = req.userid;
          newProfile.firstname = req.body.firstname;
          newProfile.lastname = req.body.lastname;
          newProfile.email = req.body.email;
          newProfile.save(function(err,thisprofile) {
            req.reJson['message'] = 'OK!';
            res.status(200).send(req.reJson);
          });
        }else {
          if(req.body.firstname != undefined){
            profile.firstname = req.body.firstname;
          }
          if(req.body.lastname != undefined){
            profile.lastname = req.body.lastname;
          }
          if(req.body.email != undefined){
            profile.email = req.body.email;
          }
          profile.save(function(err) {
            req.reJson['message'] = 'OK!';
            res.status(200).send(req.reJson);
          });
        }
      }
    });
  }
}
