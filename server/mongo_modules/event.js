var mongoose = require('mongoose');

var eventSchema = mongoose.Schema({
  userid : String,
  title : String,
  detail : String,
  starttime : { type : Date, default: Date.now },
  endtime : { type : Date, default: Date.now },
  share : Boolean
});

module.exports = mongoose.model('Event', eventSchema);
