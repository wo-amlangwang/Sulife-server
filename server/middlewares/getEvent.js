var Event = require('../mongo_modules/event.js');
module.exports = {
  getEvent : function(req, res, next) {
    Event.findOne({'id' : req.params.eventid}, function(err, thisevent) {
      if(err){
        req.reJson['message'] = 'something wrong when get data from database';
        req.reJson['err'] = err;
        res.status(500).send(req.reJson);
      }else{
        if(thisevent){
          if(req.userid === thisevent.userid){
            req.reJson['message'] = 'OK! Event followed';
            req.reJson['event'] = thisevent;
            res.status(200).send(req.reJson);
          } else {
            req.reJson['message'] = 'You have no right to do this';
            res.status(403).send(req.reJson);
          }
        }else {
          req.reJson['message'] = 'OK! Event followed';
          req.reJson['event'] = thisevent;
          res.status(200).send(req.reJson);
        }
      }
    });
  }
}
