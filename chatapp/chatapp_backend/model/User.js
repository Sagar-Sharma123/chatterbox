const mongoose = require('mongoose')
const passportLocalMongoose = require('passport-local-mongoose');

const userSchema=new mongoose.Schema({
    phonenumber:{
        required:true,
        type:String,
    },
    dname:{
        type:String,
        trim:true
    },
    dp:{
        type:String,
    },
    chats:[
        {
            type:mongoose.Schema.Types.ObjectId,
            ref:'Chat'
        }
    ]


})

userSchema.plugin(passportLocalMongoose);



let User=mongoose.model('User',userSchema)
module.exports=User