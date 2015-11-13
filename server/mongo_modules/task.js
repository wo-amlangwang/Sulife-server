var mongoose = require('mongoose');

var taskSchema = mongoose.Schema({
  userid : String,
  title : String,
  detail : String,
  establishTime : { type : Date, default: Date.now },
  finished : Boolean,
});

module.exports = mongoose.model('Task', taskSchema);
