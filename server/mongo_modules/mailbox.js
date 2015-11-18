var mongoose = require('mongoose');


var mailboxSchema = mongoose.Schema({
  sender : String,
  taker : String,
  time : { type : Date, default: Date.now },
  issuenumber : Number,
  issuedetail : String,
  solved : Boolean,
});

module.exports = mongoose.model('Mailbox', mailboxSchema);

/*
100 : Friend request
400 : New group event
*/
