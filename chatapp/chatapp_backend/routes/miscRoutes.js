const express=require('express')
const User=require('../model/User')
const Chat=require('../model/Chat')
const exam=require('../model/exam')


const router=express.Router()


router.post('/save',async (req,res)=>{
    let {username,dname,dp}=req.body
    console.log(dname)
    // let n=await exam.findOne({});
    // console.log(file)
    // let n=new exam({file})
    // await n.save()
    // res.send(n);
    let user=await User.findOne({'username':username})
    user.dname=dname;
    user.dp=dp;
    user.save()
    res.send("Done")
})

// router.get('/save',async (req,res)=>{

// })


router.get('/dp',async (req,res)=>{
    let {username}=req.query
    let user=await User.findOne({'username':username})
    let dp=user?.dp
    res.send(dp)
})
router.get('/dname',async (req,res)=>{
    let {username}=req.query
    let user=await User.findOne({'username':username})
    let dname=user.dname
    res.send(dname)
})

router.get('/phonenumber',async (req,res)=>{
    let {username}=req.query
    let user=await User.findOne({'username':username})
    let phonenumber=user.phonenumber
//    console.log(username)
//    console.log(phonenumber)
    res.send(phonenumber)
})

router.get('/phone',async (req,res)=>{
    let {username}=req.query
    let user=await User.findOne({'username':username})
    let phonenumber=user.phonenumber
//    console.log(username)
//    console.log(phonenumber)
    res.send(phonenumber)
})

router.get('/getAllUser',async (req,res)=>{
    ret=[]
    // ret.append
    allUsers=await User.find();
    for(user of allUsers){
        ret.push([user['username'],user['dname'],user['dp'],user['phonenumber']])
    }
//    console.log(user['pho'])
    res.json(ret)
})

router.get('/new',async (req,res)=>{
    let {sender,receiver}=req.query;
    let user=await User.findOne({'username':receiver}).populate('chats')
    user.chats.forEach(async (chat)=>{
        if(chat['username']==sender){
            chat['isSeen']=false
            await chat.save()
            res.send("success")
        }
    })
})

router.get('/seen',async (req,res)=>{
    let {sender,receiver}=req.query;
    let user=await User.findOne({'username':sender}).populate('chats')
    user.chats.forEach(async (chat)=>{
        if(chat['username']==receiver){
            chat['isSeen']=true
            await chat.save()
            res.send("success")
        }
    })

})





module.exports=router