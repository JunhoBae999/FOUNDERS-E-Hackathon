const app = require("./app"); // 위에서 작성한 express app 을 불러온다.
const http = require("http"); // http 내장 모듈
const server = http.createServer(app); // http 모듈의 createServer 함수를 통해서 express app을 사용한 서버를 만든다.
const mongoose = require("mongoose"); // mongoose 모듈을 불러온다.

(async function () {
  try {
    // db connection
    await mongoose.connect(MONGO_URL, {  // MONGO_URL 엔 각자 자신의 mongdoDB 를 연결하는 주소를 적으면 된다.
      useNewUrlParser: true,
      useUnifiedTopology: true,
      useFindAndModify: false,
      useCreateIndex: true,
    });

    console.log("DB CONNECTED");
    server.listen(8000, () => // 서버 실행
      console.log("Server is listening to port: ", 8000)
    );
  } catch (err) {
    console.log("DB CONNECTION ERROR");
    console.log(err);
  }
})(); // 서버를 실행시키는 익명함수를 생성하자마자 실행시킨다.