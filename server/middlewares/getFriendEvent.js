var Event = require('../mongo_modules/event.js');
module.exports = {
  getFriendEvent : function(req,res,next) {
    Event.find({'userid' : req.body.userid,
                'share' : true }).sort({'starttime' : -1})
    .exec(function(err, events) {
      if(err){
        req.reJson['message'] = 'something wrong when get data from database';
        req.reJson['err'] = err;
        res.status(500).send(req.reJson);
      }else {
        req.reJson['message'] = 'OK! Events list followed';
        req.reJson['Events'] = events;
        res.status(200).send(req.reJson);
      }
    });
  }
}
