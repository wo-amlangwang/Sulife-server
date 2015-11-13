var Task = require('../mongo_modules/task.js');

module.exports = {
  deleteTask : function(req,res,next){
    Task.findOne({'_id' : req.params.taskid},function(err,thistask) {
      if(thistask){
        if(req.userid === thistask.userid){
          thistask.remove();
          req.reJson['message'] = 'OK!';
          res.status(200).send(req.reJson);
        }else{
          req.reJson['message'] = 'You have no right to do this';
          res.status(403).send(req.reJson);
        }
      }else {
        req.reJson['message'] = 'No such task';
        res.status(404).send(req.reJson);
      }
    });
  }
}
