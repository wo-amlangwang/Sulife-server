var mongoose = require('mongoose');

var eventSchema = mongoose.Schema({
  userid : Number,
  title : String,
  detail : String,
  starttime : Date,
  endtime : Date,
  share : Boolean
});

module.exports = mongoose.model('Event', eventSchema);
