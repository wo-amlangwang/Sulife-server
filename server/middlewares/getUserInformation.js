var User = require('../mongo_modules/profile.js');
module.exports = {
  getUserInformation : function(req, res, next) {
    User.findOne({'userid' : req.params.userid}, function(err, thisevent) {
      if(err){
        req.reJson['message'] = 'something wrong when get data from database';
        req.reJson['err'] = err;
        res.status(500).send(req.reJson);
      }else{
          req.reJson['message'] = 'OK! Event followed';
          req.reJson['profile'] = thisevent;
          res.status(200).send(req.reJson);       
      }
    });
  }
}
