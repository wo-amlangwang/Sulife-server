var Group = require('../mongo_modules/group.js');
var Grouplist = require('../mongo_modules/grouplist.js');

module.exports = {
  joinGroup : function(req,res,next){
    Group.findOne({'_id' : req.body.groupid},function(err,thisgroup) {
      if(err){

      }else {
        if(thisgroup){
          if(thisgroup.founder != req.userid){
            req.reJson['message'] = 'You have no right to do this';
            res.status(403).send(req.reJson);
          }else {
            var newgrouplist = new Grouplist();
            newgrouplist.groupid = thisgroup._id;
            newgrouplist.userid = req.body.userid;
            newgrouplist.save(function(err) {
              if(err){

              }else {
                req.reJson['message'] = 'OK!';
                res.status(200).send(req.reJson);
              }
            });
          }
        }else {
          req.reJson['message'] = 'no such group';
          res.status(404).send(req.reJson);
        }
      }
    });
  }
}
