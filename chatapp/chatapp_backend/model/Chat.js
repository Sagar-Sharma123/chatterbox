const mongoose = require('mongoose')



const chatSchema=mongoose.Schema({
    username:{
        type:String,
        trim:true
    },
    isSeen:{
        type:Boolean,
    },
    messages:[
        {
            type:String,
            trim:true
        }
    ]
})





let Chat=mongoose.model('Chat',chatSchema)
module.exports=Chat