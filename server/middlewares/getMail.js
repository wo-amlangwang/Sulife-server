var Mailbox = require('../mongo_modules/mailbox.js');
module.exports = {
  getMail : function(req,res,next){
    Mailbox.find({'taker' : req.userid}, function(err,mails) {
      if(err){
        req.reJson['message'] = 'something wrong when get data from database';
        req.reJson['err'] = err;
        res.status(500).send(req.reJson);
      }else {
        req.reJson['message'] = 'OK! mail list followed';
        req.reJson['Mails'] = mails;
        res.status(200).send(req.reJson);
      }
    });
  }
}
