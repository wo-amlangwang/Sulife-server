var mongoose = require('mongoose');


var groupSchema = mongoose.Schema({
  userid : [String]
});

module.exports = mongoose.model('Friendlist', friendlistSchema);
