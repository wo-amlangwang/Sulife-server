var Event = require('../mongo_modules/event.js');
module.exports = {
  editEvent : function(req, res, next) {
    if(req.eventJson === undefined){
      res.status(400).send({'message' : 'need detail of the event'});
    } else {
      Event.findOne({'id' : req.params.eventid}, function(err, thisevent) {
        if(req.userid === thisevent.userid){
          // TO DO: Check update API
          thisevent.update(req.userid, req.eventJson, function(err) {
            if(err){
              res.status(500).send({'message'  : 'something wrong when put into database',
                                 'err' : err});
            }else {
              res.status(200).send({'message' : 'OK!'});
            }
          });
        } else {
          res.status(403).send({'message' : 'You have no right to do this'});
        }
      });
    }
  }
}
