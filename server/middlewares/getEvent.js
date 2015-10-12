var Event = require('../mongo_modules/event.js');
module.exports = {
  getEvent : function(req, res, next) {
    Event.findOne({'id' : req.params.eventid}, function(err, thisevent) {
      if(err){
        res.status(500).send({'message'  : 'something wrong when get data from database',
                              'err' : err});
      }else{
        if(req.userid === thisevent.userid){
          res.status(200).send({'message' : 'OK! Event followed',
                                'event' : thisevent});
        } else {
          res.status(403).send({'message' : 'You have no right to do this'});
        }
      }
    });
  }
}
