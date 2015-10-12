var makeToken = require('./middlewares/makeToken.js');
var middlewares = require('./middlewares/middlewares.js');
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
          makeToken.makeToken({'id' : user.id}).then(function(token) {
            res.status(200).send({'message' : 'OK',
                                  'Access_Token' : token});
          }).catch(function(err) {
            console.log(err);
            res.status(500).send({'message' : 'Server err',
                                  'err' : err});
          });
        }else {
          res.status(401).send(info);
        }
      }
    })(req,res,next);
  });
  app.post('/event',middlewares.verifyToken,middlewares.postEvent);
  app.delete('/event/:eventid',middlewares.verifyToken,middlewares.deleteEvent);
  app.get('/event/:eventid', middlewares.verifyToken, middlewares.getEvent);
  app.post('/event/:eventid', middlewares.verifyToken, middlewares.editEvent);
}
