var Event = require('../mongo_modules/event.js');
module.exports = {
  editEvent : function(req, res, next) {
  Event.findOne({'_id' : req.params.eventid}, function(err, thisevent) {
    if(req.userid === thisevent.userid){
      if(!req.body.title === undefined){
        thisevent.title = req.body.title;
      }
      if(!req.body.detail === undefined){
        thisevent.detail = req.body.detail;
      }
      if(!req.body.starttime === undefined){
        thisevent.starttime = req.body.starttime;
      }
      if(!req.body.endtime === undefined){
        thisevent.endtime = req.body.endtime;
      }
      if(!req.body.share === undefined){
        thisevent.share = req.body.share;
      }
      thisevent.save(function(err) {
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
