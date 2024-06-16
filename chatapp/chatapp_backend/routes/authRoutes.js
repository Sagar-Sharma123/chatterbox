const express=require('express')
const User=require('../model/User')
const passport = require('passport')


const router=express.Router()



router.get('/authFail',(req,res)=>{
    console.log('hwlo')
    res.json({connection:false})
})

router.post('/register',async (req,res)=>{
    // console.log(req.body)
    let {phonenumber, username, password}=req.body
    let user=new User({username,phonenumber,'dname':username,'dp':"default"})
    created_user=await User.register(user,password)
    console.log(created_user)
    res.json({connection:true})
})


// router.post('/signin',
// passport.authenticate('local',
// {
//     failureRedirect:'/authFail'
    

// }),
// function(req,res){
//     console.log(req.user) 
//     res.json({connection:true})
//     }
// )


router.post("/signin", function (req, res) {
    passport.authenticate('local', function (err, user)  {
      if (!user) {
        return res.json({connection:false})
      }
      else{
        console.log('new user connected')
        return res.json({connection:true})

      }
    }) (req, res)
  })



module.exports=router