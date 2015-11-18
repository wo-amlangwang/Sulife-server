var mongoose = require('mongoose');


var groupSchema = mongoose.Schema({
  name : String,
  founder : String
});

module.exports = mongoose.model('Group', groupSchema);
