var mongoose = require('mongoose');

var eventSchema = mongoose.Schema({
  userid : String,
  title : String,
  detail : String,
  starttime : { type : Date, default: Date.now },
  endtime : { type : Date, default: Date.now },
  share : Boolean,
  locationName : String,
  location : {
    type: {
      type: String,
      default: 'Point'
    },
    coordinates: [Number]
  }
});

module.exports = mongoose.model('Event', eventSchema);
