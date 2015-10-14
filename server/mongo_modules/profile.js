var mongoose = require('mongoose');

var profileSchema = mongoose.Schema({
  userid : String,
  firstname : String,
  lastname : String,
});

module.exports = mongoose.model('Profile', profileSchema);
