var mongoose = require('mongoose');


var friendlistSchema = mongoose.Schema({
  userid1 : String,
  userid2 : String
});

module.exports = mongoose.model('Friendlist', friendlistSchema);
