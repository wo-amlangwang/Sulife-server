var Friendlist = require('../mongo_modules/friendlist.js');
module.exports = {
  buildFriendRelationship : function(req,res,next) {
    var userid1 = req.mail.sender;
    var userid2 = req.mail.taker;
    var friendlist1 = new friendlist();
    friendlist1.userid1 = userid1;
    friendlist1.userid2 = userid2;
    friendlist1.save(function(err) {
      if(err){
        req.reJson['message'] = 'something wrong when put into database';
        req.reJson['err'] = err;
        res.status(500).send(req.reJson);
      }else {
        var friendlist2 = new friendlist();
        friendlist2.userid2 = userid1;
        friendlist2.userid1 = userid2;
        friendlist2.save(function(err) {
          if (err) {
            req.reJson['message'] = 'something wrong when put into database';
            req.reJson['err'] = err;
            res.status(500).send(req.reJson);
          }else {
            req.reJson['message'] = 'OK!';
            res.status(200).send(req.reJson);
          }
        });
      }
    })
  }
}
