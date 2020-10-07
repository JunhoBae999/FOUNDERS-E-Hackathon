const mongoose = require("mongoose");
const Schema = mongoose.Schema; 

const userSchema = new Schema({ // 1.
  email: {
    type: String,
    required: true,
  },
  password: {
    type: String, // 2.
    required: true,
  },
  name: {
    type: String,
    required: true,
  },
  phone: {
    type: String,
    default: 0, // 3.
  },
  private:{
      type:Boolean,
      required: true,
  },
  institution : {
      type:Boolean,
      required:true,
  },
  address : {
      type:String,
      required:true,  
  }

});

module.exports = mongoose.model("User", userSchema); // 4