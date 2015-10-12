var Event = require('../mongo_modules/event.js');
module.exports = {
  deleteEvent : function(req,res,next) {
<<<<<<< HEAD
    Event.findOne({'id' : req.params.eventid},function(err,thisevent) {
      if(req.userid === thisevent.userid){
        thisevent.remove();
        res.status(200).send({'message' : 'OK!'});
      }else{
        res.status(403).send({'message' : 'You have no right to do this'});
=======
    Event.findOne({'_id' : req.params.eventid},function(err,thisevent) {
      if(thisevent){
        if(req.userid === thisevent.userid){
          thisevent.remove();
          req.reJson['message'] = 'OK!';
          res.status(200).send(req.reJson);
        }else{
          req.reJson['message'] = 'You have no right to do this';
          res.status(403).send(req.reJson);
        }
      }else {
        req.reJson['message'] = 'No such event';
        res.status(403).send(req.reJson);
>>>>>>> wo-amlangwang/master
      }
    });
  }
}
