module.exports = function(app,passport){
  app.post('/register',function(req,res,next) {
    passport.authenticate('local-signup',function(err,user,info) {
      if(err){
        res.status(503).send(err);
      }else {
        if(user){
          res.status(200).send({'message' : 'OK'});
        }else {
          res.status(409).send(info);
        }
      }
    })(req,res,next);
  });
  app.post('/local/login',function(req,res,next){
    passport.authenticate('local-login',function(err,user,info) {
      if(err){
        res.status(503).send(err);
      }else {
        if(user){
          res.status(200).send({'message' : 'OK'});
        }else {
          res.status(401).send(info);
        }
      }
    })(req,res,next);
  });
}
