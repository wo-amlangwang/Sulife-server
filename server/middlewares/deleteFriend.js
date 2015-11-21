var friendlist = require('../mongo_modules/friendlist.js');

module.exports = {
  deleteFriend : function(req,res,next){
    var myUserid = req.userid;
    var friendUserid = req.params.targetid;
    friendlist.findOne({'userid1' : myUserid,
                        'userid2' : friendUserid})
    .exec(function(err, relationship){
      if(err){
        req.reJson['message'] = 'something wrong when get data from database';
        req.reJson['err'] = err;
        res.status(500).send(req.reJson);
      }else {
        relationship.remove();
        friendlist.findOne({'userid1' : friendUserid,
                            'userid2' : myUserid})
        .exec(function(err,relationship) {
          if(err){
            req.reJson['message'] = 'something wrong when get data from database';
            req.reJson['err'] = err;
            res.status(500).send(req.reJson);
          }else {
            relationship.remove();
            req.reJson['message'] = 'OK!';
            res.status(200).send(req.reJson);
          }
        });
      }
    });
  }
}
