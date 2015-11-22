var mongoose = require('mongoose');

var LocationSchema = mongoose.Schema({
  userid : String,
  EventOrTaskid : String,
  locationName : String,
  location : {
    type: {
      type: String,
      default: 'Point'
    },
    coordinates: [Number]
  }
});

LocationSchema.index({ location : '2dsphere' });

module.exports = mongoose.model('Location', LocationSchema);
