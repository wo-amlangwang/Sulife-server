var Location = require('../mongo_modules/location.js');

module.exports = {
  postLocation : function(req,res,next) {
    var lng = req.body.lng;
    var lat = req.body.lat;
    var eventOrTaskid = req.body.eventOrTaskid;

    Location.findOne({'EventOrTaskid' : req.body.eventOrTaskid},function(err, location) {
      if(err){
        req.reJson['message'] = 'something wrong when get data from database';
        req.reJson['err'] = err;
        res.status(500).send(req.reJson);
      }else {
        if(location){
          location.location.coordinates.pop();
          location.location.coordinates.pop();
          location.location.coordinates.push(req.body.lng);
          location.location.coordinates.push(req.body.lat);
          location.locationName = req.body.locationName;
          location.save(function (err) {
            if(err){

            }else {
              req.reJson['message'] = 'OK!';
              res.status(200).send(req.reJson);
            }
          });
        }else {
          var newlocation = new Location();
          newlocation.userid = req.userid;
          newlocation.EventOrTaskid = req.body.eventOrTaskid;
          newlocation.location.coordinates.push(req.body.lng);
          newlocation.location.coordinates.push(req.body.lat);
          newlocation.locationName = req.body.locationName;
          newlocation.save(function(err) {
            if(err){

            }else {
              req.reJson['message'] = 'OK!';
              res.status(200).send(req.reJson);
            }
          });
        }
      }
    });
  }
}
