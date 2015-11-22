var makeToken = require('./maketoken.js');
var thisPostEvent = require('./postEvent.js').postEvent;
var thisdeleteEvent = require('./deleteEvent.js').deleteEvent;
var thisgetEvent = require('./getEvent.js').getEvent;
var thiseditEvent = require('./editEvent.js').editEvent;
var thisgetAllEvent = require('./getAllEvent.js').getAllEvent;
var thisgetFriendEvent = require('./getFriendEvent.js').getFriendEvent;
var thischeckmailbox = require('./checkmailbox.js').checkmailbox;
var thisgetProfile = require('./getProfile.js').getProfile;
var thiseditProfile = require('./editProfile.js').editProfile;
var thischeckEventid = require('./checkEventid.js').checkEventid;
var thisfriendRequest = require('./friendRequest.js').friendRequest;
var thisgetMail = require('./getMail.js').getMail;
var thisacceptFriendRequest = require('./acceptFriendRequest.js').acceptFriendRequest;
var thisrejectFriendRequest = require('./rejectFriendRequest.js').rejectFriendRequest;
var thisbuildFriendRelationship = require('./buildFriendRelationship.js').buildFriendRelationship;
var thisgetFriends = require('./getFriends.js').getFriends;
var thisfindUser = require('./findUser.js').findUser;
var getEventByDate = require('./getAllEvent.js').getEventByDate;
var getUserInformation = require('./getUserInformation.js').getUserInformation;

var deleteTask = require('./deleteTask.js').deleteTask;
var editTask = require('./editTask.js').editTask;
var getAllTask = require('./getAllTask.js').getAllTask;
var getTask = require('./getTask.js').getTask;
var postTask = require('./postTask.js').postTask;
var finishTask = require('./finishTask.js').finishTask;
var getTaskByDate = require('./getAllTask.js').getTaskByDate;
var deleteFriend = require('./deleteFriend.js').deleteFriend;

var resetPassword = require('./resetPassword.js').resetPassword;
var changePassword = require('./changePassword.js').changePassword;

var postLocation = require('./postLocation.js').postLocation;

var createGroup = require('./createGroup.js').createGroup;
var joinGroup = require('./joinGroup.js').joinGroup;

module.exports = {
  verifyToken : function(req,res,next) {
    if(req.headers['x-access-token'] === undefined){
      res.status(401).send({"message" : "need Token"});
    }else {
      makeToken.checkToken(req.headers['x-access-token']).then(function(result) {
        req.userid = result.id;
        req.reJson = {};
        return next();
      }).catch(function(err) {
        console.log(err);
        res.status(401).send({"message" : "bad token"});
      });
    }
  },
  postEvent : thisPostEvent,
  deleteEvent : thisdeleteEvent,
  getEvent : thisgetEvent,
  editEvent : thiseditEvent,
  getAllEvent : thisgetAllEvent,
  getFriendEvent : thisgetFriendEvent,
  checkmailbox : thischeckmailbox,
  getProfile : thisgetProfile,
  editProfile : thiseditProfile,
  checkEventid : thischeckEventid,
  friendRequest : thisfriendRequest,
  getMail : thisgetMail,
  acceptFriendRequest : thisacceptFriendRequest,
  rejectFriendRequest : thisrejectFriendRequest,
  buildFriendRelationship : thisbuildFriendRelationship,
  getFriends : thisgetFriends,
  findUser : thisfindUser,
  getEventByDate : getEventByDate,
  getUserInformation : getUserInformation,
  deleteTask : deleteTask,
  editTask : editTask,
  finishTask : finishTask,
  getAllTask : getAllTask,
  getTask : getTask,
  postTask : postTask,
  getTaskByDate : getTaskByDate,
  deleteFriend : deleteFriend,
  resetPassword : resetPassword,
  changePassword : changePassword,
  postLocation : postLocation,
  createGroup : createGroup,
  joinGroup : joinGroup
}
