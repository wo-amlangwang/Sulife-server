var Task = require('../mongo_modules/task.js');

module.exports = {
  editTask : function(req,res,next) {
    Task.findOne({'_id' : req.params.taskid}, function(err, thistask) {
      if(thistask){
        if(req.userid === thistask.userid){
          if(req.body.title != undefined){
            thistask.title = req.body.title;
          }
          if(req.body.detail != undefined){
            thistask.detail = req.body.detail;
          }
          thistask.save(function(err) {
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
        req.reJson['message'] = 'No such Task';
        res.status(404).send(req.reJson);
      }
    });
  }
}
