var Location = require('../mongo_modules/location.js');

module.exports = {
  getLocation : function(req,res,next) {
    Location.findOne({'EventOrTaskid' : req.params.EventOrTaskid},function(err,thislocation) {
      if(thislocation){
        req.reJson['message'] = 'OK! Location followed';
        req.reJson['Location'] = thislocation;
        res.status(200).send(req.reJson);
      }else {
        req.reJson['message'] = 'Location not found';
        res.status(404).send(req.reJson);
      }
    });
  }
}
