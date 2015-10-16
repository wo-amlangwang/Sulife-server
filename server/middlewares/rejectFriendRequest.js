var Mailbox = require('../mongo_modules/mailbox.js');
module.exports = {
  rejectFriendRequest : function(req,res,next){
    if(req.body.mailid === undefined){
      req.reJson['message'] = 'need mailid';
      res.status(404).send(req.reJson);
    }else {
      Mailbox.findOne({'_id' : req.body.mailid},function(err, mail) {
        if(err){
          req.reJson['message'] = 'something wrong when get data from database';
          req.reJson['err'] = err;
          res.status(500).send(req.reJson);
        }else {
          if(mail.taker != req.userid){
            req.reJson['message'] = 'You have no right to do this';
            res.status(403).send(req.reJson);
          }else {
            mail.solved = true;
            mail.save(function(err) {
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
      });
    }
  }
}
