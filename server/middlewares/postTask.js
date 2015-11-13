var Task = require('../mongo_modules/task.js');

module.exports = {
  postTask : function(req,res,next) {
    var newTask = new Task();
    newTask.userid = req.userid;
    newTask.title = req.body.title;
    newTask.detail = req.body.detail;
    newTask.finished = false;
    newTask.save(function(err) {
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
