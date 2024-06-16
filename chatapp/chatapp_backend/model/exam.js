const mongoose = require('mongoose')



const examSchema=mongoose.Schema({
    file:{
        type:String
    }
})





let exam=mongoose.model('exam',examSchema)
module.exports=exam