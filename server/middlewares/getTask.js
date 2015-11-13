var Task = require('../mongo_modules/task.js');

module.exports = {
  getTask : function(req,res,next) {
    Task.findOne({'_id' : req.params.taskid},function(err,thistask) {
      if(err){
        req.reJson['message'] = 'something wrong when get data from database';
        req.reJson['err'] = err;
        res.status(500).send(req.reJson);
      }else{
        if(thistask){
          if(req.userid === thistask.userid){
            req.reJson['message'] = 'OK! Event followed';
            req.reJson['task'] = thistask;
            res.status(200).send(req.reJson);
          } else {
            req.reJson['message'] = 'You have no right to do this';
            res.status(403).send(req.reJson);
          }
        }else {
          req.reJson['message'] = 'OK! Event followed';
          req.reJson['task'] = thistask;
          res.status(200).send(req.reJson);
        }
      }
    });
  }
}
