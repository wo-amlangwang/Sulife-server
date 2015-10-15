module.exports = {
  checkEventid : function(req,res,next) {
    if(req.params.eventid === null){
      req.reJson['message']='need eventid';
      res.status(404).send(req.reJson);
    }else {
      return next();
    }
  }
}
