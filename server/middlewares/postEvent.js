var Event = require('../mongo_modules/event.js');
module.exports = {
  postEvent : function(req,res,next) {
    var newEvent = new Event();
    newEvent.userid = req.userid;
    newEvent.title = req.body.title;
    newEvent.detail = req.body.detail;
    newEvent.starttime = req.body.starttime;
    newEvent.endtime = req.body.endtime;
    newEvent.share = false; //TODO will implement more detail later.
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
