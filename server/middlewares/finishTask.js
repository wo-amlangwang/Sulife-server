var Task = require('../mongo_modules/task.js');

module.exports = {
  finishTask : function(req,res,next) {
    Task.findOne({'_id' : req.params.taskid,'userid' : req.userid},function(err,task) {
      if(task){
        task.finished = true;
        task.sava(function(err) {
          if(err){

          }else {
            req.reJson['message'] = 'OK!';
            res.status(200).send(req.reJson);
          }
        });
      }else {
        req.reJson['message'] = 'No such Task';
        res.status(404).send(req.reJson);
      }
    });
  }
}
