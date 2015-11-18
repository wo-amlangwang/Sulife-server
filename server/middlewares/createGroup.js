var Group = require('../mongo_modules/group.js');
var Grouplist = require('../mongo_modules/grouplist.js');

module.exports = {
  createGroup : function(req,res,next) {
    var newgroup = new Group();
    var newgrouplist = new Grouplist();
    newgroup.name = req.body.name;
    newgroup.founder = req.userid;
    newgroup.save(function(err,thisgroup) {
      if(err){

      }else {
        newgrouplist.groupid = thisgroup._id;
        newgrouplist.userid = req.userid;
        newgrouplist.save(function(err) {
          if(err){

          }else {
            req.reJson['message'] = 'OK!';
            res.status(200).send(req.reJson);
          }
        });
      }
    });
  }
}
