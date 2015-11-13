var Friendlist = require('../mongo_modules/friendlist.js');
module.exports = {
  getFriends : function(req,res,next) {
    Friendlist.find({'userid1' : req.userid},function(err,relationships) {
      if(err){
        req.reJson['message'] = 'something wrong when get data from database';
        req.reJson['err'] = err;
        res.status(500).send(req.reJson);
      }else {
        req.reJson['message'] = 'OK! relationships followed';
        req.reJson['relationships'][0] = relationships;
        Friendlist.find({'userid2' : req.userid},function(err,relationships) {
          if(err){
            req.reJson['message'] = 'something wrong when get data from database';
            req.reJson['err'] = err;
            res.status(500).send(req.reJson);
          }else {
            req.reJson['message'] = 'OK! relationships followed';
            req.reJson['relationships'][1] = relationships;
            res.status(200).send(req.reJson);
          }
        });
        //res.status(200).send(req.reJson);
      }
    });
  }
}
