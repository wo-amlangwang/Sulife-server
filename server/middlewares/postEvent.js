var Event = require('../mongo_modules/event.js');
module.exports = {
  postEvent : function(req,res,next) {
    var newEvent = new Event();
    newEvent.userid = req.userid;
    newEvent.title = req.body.title;
    newEvent.detail = req.body.detail;
    newEvent.starttime = req.body.starttime;
    newEvent.endtime = req.body.endtime;
    newEvent.share = req.body.share;
    newEvent.save(function(err) {
      if(err){
        req.reJson['message'] = 'something wrong when put into database';
        req.reJson['err'] = err;
        res.status(500).send(req.reJson);
      }else {
        req.reJson['message'] = 'OK!';
        res.status(200).send(req.reJson);
      }
    });

  }
}
