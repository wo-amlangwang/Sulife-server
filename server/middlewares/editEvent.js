var Event = require('../mongo_modules/event.js');
module.exports = {
  editEvent : function(req, res, next) {
    Event.findOne({'_id' : req.params.eventid}, function(err, thisevent) {
      if(thisevent){
        if(req.userid === thisevent.userid){
          if(req.body.title != undefined){
            thisevent.title = req.body.title;
          }
          if(req.body.detail != undefined){
            thisevent.detail = req.body.detail;
          }
          if(req.body.starttime != undefined){
            thisevent.starttime = req.body.starttime;
          }
          if(req.body.endtime != undefined){
            thisevent.endtime = req.body.endtime;
          }
          if(req.body.share != undefined){
            thisevent.share = req.body.share;
          }
          thisevent.save(function(err) {
            if(err){
              req.reJson['message'] = 'something wrong when put into database';
              req.reJson['err'] = err;
              res.status(500).send(req.reJson);
            }else {
              req.reJson['message'] = 'OK!';
              res.status(200).send(req.reJson);
            }
          });
        }else{
          req.reJson['message'] = 'You have no right to do this';
          res.status(403).send(req.reJson);
        }
      }else {
        req.reJson['message'] = 'No such Event';
        res.status(404).send(req.reJson);
      }
    });
  }
}
