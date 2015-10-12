var Event = require('../mongo_modules/event.js');
module.exports = {
  getEvent : function(request, result, next) {
    Event.findOne({'id' : request.params.eventid}, function(err, thisevent) {
      if(req.userid === thisevent.userid){
        res.send(thisevent);
        res.status(200).send({'message' : 'OK!'});
      } else {
        res.status(403).send({'message' : 'You have no right to do this'});
      }
    });
  }
}
