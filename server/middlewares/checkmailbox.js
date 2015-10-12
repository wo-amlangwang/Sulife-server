var mail = require('../mongo_modules/mailbox.js');
module.exports = {
  checkmailbox : function(req,res,next) {
    mail.find({'taker' : req.userid }, function(err,mails) {
      if(err){
        res.status(500).send({'message'  : 'something wrong when get data from database',
                              'err' : err});
      }else{
        req.reJson = {'mails' : mails};
        return next();
      }
    });
  }
}
