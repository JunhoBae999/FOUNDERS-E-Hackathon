const authRoutes = require("./auth"); // 위에서 작성한 /routes/auth.js 모듈을 임포트 한다. 즉, router 를 임포트 하는 것
var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

const router = (app) => { // express app 을 받아 인자로 받는다.
  app.use("/auth", authRoutes);  // 인증/인가와 관련된 미들웨어로 연결시키기 위해 홈페이지주소/auth/ 의 길로 안내하는 코드.
};

module.exports = router;


