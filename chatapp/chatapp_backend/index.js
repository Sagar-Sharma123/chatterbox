//express
const express = require('express');
const app = express();
const cors = require('cors');
const bodyParser = require('body-parser');
app.use(express.json({extended:true}))

// authentication
const session=require('express-session')
const passport=require('passport')  
const localStrategy=require('passport-local')
const User=require('./model/User.js')

// let configSession = {
//     secret: 'keyboard cat',
//     resave: false,
//     saveUninitialized: true
// }
// app.use(session(configSession));

// app.use(passport.initialize())
// app.use(passport.session())

// passport.serializeUser(User.serializeUser())
// passport.deserializeUser(User.deserializeUser())

passport.use(new localStrategy(User.authenticate()));

//app.use(bodyParser.json({ limit: '50mb' }));
//app.use(bodyParser.urlencoded({ limit: '50mb', extended: true }));

//Database connection
const mongoose=require('mongoose')
mongoose.set('strictQuery' , true);
mongoose.connect('mongodb://127.0.0.1:27017/chatapp')
.then(()=>{console.log("DB CONNECTED")})
.catch((err)=>{console.log("error in DB" , err)})



//Using routes
const authRoutes=require('./routes/authRoutes')
const miscRoutes=require('./routes/miscRoutes.js')
const chatRoutes=require('./routes/chatRoutes.js')
app.use(authRoutes)
app.use(miscRoutes)
app.use(chatRoutes)



const PORT = 8080;
const server=app.listen(PORT ,()=>{
    console.log(`server connected at port: ${PORT}`);
})

const socketIO=require('socket.io')


const io=socketIO(server)

let currUsers={}

io.on('connection',(socket)=>{
    socket.on('send',(id)=>{
        if(currUsers[id]){
            currUsers[id].emit('receive',Object.keys(currUsers).find(key => currUsers[key] === socket))
        }
    })
    socket.on('signin',(id)=>{
        currUsers[id]=socket
        // socket.emit('status','change')
        // currUsers.forEach(element => {
        //     if(currUsers[element]!=socket)
        //         // currUsers[element].emit('status','change')
        //         console.log(element)
        // });
        for(let key in currUsers){
                if(currUsers[key]!=socket)
                    currUsers[key].emit('status','change')
        console.log('resumed')
        }
        // socket.emit('status','online')
    })
    socket.on('dis',(id)=>{
        delete currUsers[id]
        socket.disconnect()
        // socket.emit('status','offline')
        for(let key in currUsers){
            if(currUsers[key]!=socket)
                currUsers[key].emit('status','change')
    }
        console.log('disconnected')
    })
    socket.on('pause',(id)=>{
        delete currUsers[id];
        // socket.emit('status','offline')
        // socket.emit('status','change')
        for(let key in currUsers){
            if(currUsers[key]!=socket)
                currUsers[key].emit('status','change')
    }
        console.log('paused')
    })
    // app.get('/status',(req,res)=>{
    //     console.log(currUsers)
    // })
    // socket.on('statusCheck',(id)=>{
    //     console.log('hello')
    //     if(currUsers[id])
    //         socket.emit('statusSend','true')
    // })
    app.get('/checkStatus',(req,res)=>{
        // console.log(currUsers)
        let {user}=req.query
        if(currUsers[user])
            res.send(true)
        else
            res.send(false)
    })
    
})








