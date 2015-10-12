var Event = require('../mongo_modules/event.js');
module.exports = {
  getAllEvent : function(req,res,next) {
    Event.find({'userid' : req.userid}).sort({'starttime' : -1})
    .exec(function(err, events) {
      if(err){
        res.status(500).send({'message' : 'something wrong when get data from database',
                              'err' : err});
      }else {
        res.status(200),send({'message' : 'OK! Events list followed',
                              'Events' : events});
      }
    });
  }
}
