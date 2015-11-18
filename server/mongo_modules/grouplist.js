var mongoose = require('mongoose');


var grouplistSchema = mongoose.Schema({
  groupid : String,
  userid  : String
});

module.exports = mongoose.model('Grouplist', grouplistSchema);
