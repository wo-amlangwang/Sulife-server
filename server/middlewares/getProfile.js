var Profile = require('../mongo_modules/profile.js');
module.exports = {
  getProfile : function(req,res,next) {
    Profile.findOne({'userid' : req.userid},function(err,profile) {
      if(!profile){
        var newProfile = new Profile();
        newProfile.userid = req.userid;
        newProfile.firstname = null;
        newProfile.lastname = null;
        newProfile.save(function(err,thisprofile) {
          req.reJson['message'] = 'OK! Profile followed';
          req.reJson['profile'] = thisprofile;
          res.status(200).send(req.reJson);
        });
      }else {
        req.reJson['message'] = 'OK! Profile followed';
        req.reJson['profile'] = profile;
        res.status(200).send(req.reJson);
      }
    });
  }
}
