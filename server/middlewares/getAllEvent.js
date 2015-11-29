var Event = require('../mongo_modules/event.js');
module.exports = {
  getAllEvent : function(req,res,next) {
    Event.find({'userid' : req.userid}).sort({'starttime' : -1})
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
  },
  getEventByDate : function(req,res,next) {
    if(req.body.endtime  < req.body.starttime){
      req.reJson['message'] = 'starttime greater than endtime';
      res.status(400).send(req.reJson);
    }else {
      Event.find({'userid' : req.userid ,
                  'starttime' : {'$lt' : req.body.endtime} ,
                  'endtime' : {'$gte' : req.body.starttime}})
      .sort({'starttime' : -1})
      .exec(function(err,events) {
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
}
