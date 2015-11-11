var mongoose = require('mongoose');

var taskSchema = mongoose.Schema({
  userid : String,
  title : String,
  detail : String,
  establishTime : { type : Date, default: Date.now },
});

module.exports = mongoose.model('Task', taskSchema);
