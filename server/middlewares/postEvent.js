var Event = require('../mongo_modules/event.js');
module.exports = {
  postEvent : function(req,res,next) {
    var newEvent = new Event();
    newEvent.userid = req.userid;
    if(req.eventJson === undefined){
      res.status(400).send({'message' : 'need detail of the event'});
    }else {
      newEvent.title = req.eventJson.title;
      newEvent.detail = req.eventJson.detail;
      newEvent.starttime = req.eventJson.starttime;
      newEvent.endtime = req.eventJson.endtime;
      newEvent.share = false //TODO will implement more detail later.
      newEvent.save(function(err) {
        if(err){
          res.status(500).send({'message'  : 'something wrong when put into database',
                             'err' : err});
        }else {
          res.status(200).send({'message' : 'OK!'});
        }
      });
    }

  }
}
