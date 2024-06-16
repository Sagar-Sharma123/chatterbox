const express=require('express');
const User=require('../model/User')
const Chat=require('../model/Chat')


const router=express.Router();







router.get('/getAllChats',async (req,res)=>{
    let {username}=req.query;
    ret=[]
    user=await User.findOne({'username':username}).populate('chats');

    for(chat of user.chats){
        // console.log(Object.hasOwn(currUsers,chat['username']))
        // console.log(currUsers[chat['username']]==undefined);
        user2=await User.findOne({'username':chat['username']})
        ret.push([chat['username'],chat['messages'][chat['messages'].length-1],chat['isSeen'],user2['dname'],user2['dp']])
    }
    res.json(ret)
})



router.get('/chat',async (req,res)=>{
    let {sender,receiver}=req.query;
    let sendUser=await User.findOne({'username':sender}).populate('chats')
    let chatList
    sendUser.chats.forEach((ele)=>{
        if(ele['username']==receiver){
            chatList=ele['messages']
        }
    })
    if(chatList==undefined){
        res.send({})
    }
    else{
        res.json(chatList)
    }




})



router.post('/chat',async (req,res)=>{


    async function addChat(adder,msg){
        adder['messages'].push(msg)
        await adder.save()
    }
    
    
    async function addNewChat (adder,msg,receiver,isSeen) {
        let msglist=[]
        msglist.push(msg);
        let chat=new Chat({username:receiver,isSeen:isSeen,messages:msglist})
        adder.chats.push(chat)
        await adder.save();
        await chat.save();
        
    }



    let {sender,receiver,msg}=req.body;
    let sendUser=await User.findOne({'username':sender}).populate('chats')
    let recUser=await User.findOne({'username':receiver}).populate('chats')
    
    let sendChatList
    sendUser.chats.forEach(element => {
        if(element['username']==receiver)
        sendChatList=element
});
    let recChatList
    recUser.chats.forEach(element => {
        if(element['username']==sender)
        recChatList=element
});



if(sendChatList==undefined && recChatList==undefined){
    addNewChat(sendUser,"0"+msg,receiver,true)
    addNewChat(recUser,"1"+msg,sender,false)
    
}
else{
    addChat(sendChatList,'0'+msg)
    addChat(recChatList,'1'+msg)
}    
    



res.json({'send':true})


})


















module.exports=router