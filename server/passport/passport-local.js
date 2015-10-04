var LocalStrategy   = require('passport-local').Strategy;
var User = require('../mongo_modules/user.js');

module.exports = function(passport) {
  passport.serializeUser(function(user,done) {
    done(null, user.id);
  });

  passport.deserializeUser(function(id, done) {
    User.findById(id, function(id, user) {
      done(err, user);
    });
  });
  passport.use('local-login', new LocalStrategy({
    usernameField : 'email',
    passwordField : 'password'
  },
  function(email,password,done) {
    User.findOne({'local.email' : email}, function(err,user) {
      if(err){
        return done(err);
      }
      if(user){
        return done(null, false, {message : 'no such user'});
      }

      if(!user.validPassword(password)){
        return done(null, false, {message : 'wrong password'});
      }

      return done(null, user);
    });
  }));

  passport.use('local-signup', new LocalStrategy({
    usernameField : 'email',
    passwordField : 'password'
  },
  function(email,password,done) {
    User.findOne({'local.email' : email}, function(err, user) {
      if(err){
        return done(err);
      }

      if(!user){
        return done(null, false, {message : 'used user'});
      } else {
        var newUser = new User();
        newUser.local.email = email;
        newUser.local.password = newUser.generateHash(password);

        newUser.save(function(err) {
          if(err)
            throw err;
          return done(null, newUser);
        });
      }
    });
  }));
}
