var Task = require('../mongo_modules/task.js');

module.exports = {
  getAllTask : function(req,res,next) {
    Task.find({'userid' : req.userid}).sort({'establishTime' : -1})
    .exec(function(err, tasks) {
      if(err){
        req.reJson['message'] = 'something wrong when get data from database';
        req.reJson['err'] = err;
        res.status(500).send(req.reJson);
      }else {
        req.reJson['message'] = 'OK! Tasks list followed';
        req.reJson['tasks'] = tasks;
        res.status(200).send(req.reJson);
      }
    });
  },
  getTaskByDate : function(req,res,next) {
    var day = new Date(req.body.establishTime)
    var today = day.setHours(0)
    var tomorrow = day.setHours(24)
    Task.find({'userid' : req.userid ,
                  'establishTime' : {
                    $gte: today,
                    $lt: tomorrow}})
      .sort({'establishTime' : -1})
      .exec(function(err,tasks) {
        if(err){
          req.reJson['message'] = 'something wrong when get data from database';
          req.reJson['err'] = err;
          res.status(500).send(req.reJson);
        }else {
          req.reJson['message'] = 'OK! Task list followed';
          req.reJson['Tasks'] = tasks;
          res.status(200).send(req.reJson);
        }
    });
  }
}
