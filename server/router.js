module.exports = function(app,passport){
  app.post('/register',function(req,res,next) {
    passport.authenticate('local-signup',function(err,user,info) {
      //console.log(err);
      //console.log(user);
      //console.log(info);
    })(req,res,next);
  });
}
