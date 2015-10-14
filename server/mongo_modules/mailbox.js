var mongoose = require('mongoose');


var mailboxSchema = mongoose.Schema({
  sender : String,
  taker : String,
  issuenumber : Number,
  issuedetail : String,
  send : Boolean
});

module.exports = mongoose.model('Mailbox', mailboxSchema);

/*
100 : Friend request
200 : Accept freind request
300 : Reject friend request
400 : Join group reminder
500 : Removed from group reminder
*/
