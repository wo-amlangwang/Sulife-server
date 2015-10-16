var Mailbox = require('../mongo_modules/mailbox.js');
module.exports = {
  friendRequest : function(req,res,next) {
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
