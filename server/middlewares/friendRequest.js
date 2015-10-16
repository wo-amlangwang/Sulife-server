var Mailbox = require('../mongo_modules/mailbox.js');
module.exports = {
  friendRequest : function(req,res,next) {
    if (req.body.taker === undefined) {
      req.reJson['message'] = 'need taker\'s userid';
      res.status(404).send(req.reJson);
    } else {
      var newMailbox = new Mailbox();
      newMailbox.sender = req.userid;
      newMailbox.taker = req.body.taker;
      newMailbox.issuenumber = 100;
      newMailbox.issuedetail = 'friend request';
      newMailbox.solved = false;
      newMailbox.save(function(err){
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
