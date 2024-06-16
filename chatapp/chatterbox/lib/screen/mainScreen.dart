// ignore: file_names

import 'dart:convert';

import 'package:chatterbox/screen/addScreen.dart';
import 'package:chatterbox/screen/chatScreen.dart';
import 'package:chatterbox/screen/signScreen.dart';
import 'package:chatterbox/screen/userInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../widgets/chatWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:chatterbox/config.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  const MainScreen(this.username, {super.key});

  final String username;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  IO.Socket? socket;
  String dp = "default";
  String dname = "";
  String phonenumber = "";
  var list;
  var allChats = [];
  var filteredChats = [];
  var decodedImage;
  TextEditingController? searchController = TextEditingController();
  // var a;
  // checkStatus(String user) {

  // }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (AppLifecycleState.paused == state) {
      socket?.emit('pause', widget.username);
    }
    if (AppLifecycleState.resumed == state) {
      // connect();
      socket?.emit('signin', widget.username);
    }
    if (AppLifecycleState.detached == state) {
      onClosing();
    }
    // if (AppLifecycleState.inactive == state) {
    //   onClosing();
    // }
  }

  @override
  void dispose() {
    onClosing();
    super.dispose();
  }

  onClosing() {
    socket?.emit('dis', widget.username);
    WidgetsBinding.instance.removeObserver(this);
  }

  connect() {
    socket = IO.io(server, <String, dynamic>{
      "transports": ['websocket'],
    });
    socket?.connect();
    socket?.emit('signin', widget.username);
    socket?.on('status', (value) {
      setState(() {
        getAllUser();
      });
    });
    socket?.on('receive', (data) {
      setState(() {
        getAllUser();
      });
    });
  }

  getAllUser() async {
    loadingDialog();

    var reqBody = {
      'username': widget.username,
    };
    var res = await http.get(
        Uri.parse('${server}getAllChats').replace(queryParameters: reqBody));
    allChats = jsonDecode(res.body);
    filteredChats = List.from(allChats);
    if (context.mounted) {
      Navigator.of(context).pop();
    }
    setState(() {});
  }

  seenMsg(String sender, String receiver) async {
    var reqBody = {
      'sender': sender,
      'receiver': receiver,
    };
    await http
        .get(Uri.parse(server + 'seen').replace(queryParameters: reqBody));
    // if (context.mounted) {
    // }
    // Navigator.of(context).pop();
  }

  openChat(String sender, String receiver, String dname, String dp,String phonenumber) {
    // print(sender);
    Route route = MaterialPageRoute(
        builder: (context) => ChatScreen(sender, receiver, socket, dname, dp,phonenumber));
    Navigator.of(context).push(route).then((value) async {
      await seenMsg(sender, receiver);
      setState(() {
        // getAllUser();
        connect();
        getAllUser();
      });
    });
  }

  openNew() {
    // list.cancel();
    socket!.off('receive');
    List<String> currUsers = [];
    currUsers.add(widget.username);
    for (List val in allChats) {
      currUsers.add(val[0]);
    }
    // print(allUsers);
    Route route = MaterialPageRoute(
        builder: (context) =>
            AddUserScreen(currUsers, widget.username, socket,phonenumber));
    Navigator.of(context).push(route).then((value) async {
      setState(() {
        // getAllUser();
        connect();
        getAllUser();
      });
    });
  }

  openEdit(String dname, String dp) {
    Route route = MaterialPageRoute(
      builder: (context) {
        return GetUserScreen(widget.username, dname, dp, "Back");
      },
    );
    Navigator.of(context).push(route);
  }

  // getFirstChat(String receiver) async {
  //   var reqBody = {
  //     'username': widget.username,
  //     'receiver': receiver,
  //   };
  //   var response = await http.get(
  //       Uri.parse(server + 'getFirstChat').replace(queryParameters: reqBody));
  //   return response.body;
  // }

  getUserInfo() async {
    // return base64Decode(widget.dp);
    var reqBody = {
      'username': widget.username,
    };
    var resdp = await http
        .get(Uri.parse(server + 'dp').replace(queryParameters: reqBody));
    var resdname = await http
        .get(Uri.parse(server + 'dname').replace(queryParameters: reqBody));
    setState(() {
      dp = resdp.body;
      dname = resdname.body;
      Uint8List decodedImage = base64Decode(dp);
    });
  }
  getno(String username) async {
    var reqBody = {
      'username': username,
    };
    var resphone = await http
        .get(Uri.parse(server + 'phonenumber').replace(queryParameters: reqBody));
    setState(() {
      phonenumber = resphone.body;
    });
  }
  getphone(String username) async{
    var reqBody = {
      'username': username,
    };
    var resno = await http.get(Uri.parse(server + 'phone').replace(queryParameters: reqBody));
    setState(() {
      phonenumber = resno.body;
    });
  }

  @override
  void initState() {
    connect();
    getUserInfo();
    WidgetsBinding.instance.addPostFrameCallback((_) => getAllUser());
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }
  void searchChats(String query) {
    if (query.isEmpty) {
      // If search query is empty, restore the original allChats list
      setState(() {
        allChats = filteredChats.isNotEmpty ? filteredChats : allChats;
      });
    } else {
      // If search query is not empty, filter the allChats list based on the query
      final suggest = filteredChats.where((element) => element[3].contains(query)).toList();
      setState(() {
        allChats = suggest;
      });
    }
  }

  loadingDialog() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return const Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  Text('Loading...')
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      // backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        // backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        // backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Text(
          'My Messages',
          style: FlutterFlowTheme.of(context).headlineLarge,
          // style: TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0,0,8,8),
            child: GestureDetector(
              onTapDown: (detail) {
                showMenu<int>(
                  shape: Border.all(color: Colors.white, width: 1),
                  context: context,
                  position: RelativeRect.fromLTRB(
                      detail.globalPosition.dx, detail.globalPosition.dy+30, 0, 0),
                  items: [
                    PopupMenuItem(
                      onTap: () {
                        openEdit(dname, dp);
                      },
                      child: const Center(
                        child: Text(
                          'Edit Profile',
                        ),
                      ),
                    ),
                    const PopupMenuItem(
                      padding: EdgeInsets.all(0),
                      height: 2,
                      child: Divider(
                        height: 2,
                        color: Colors.black,
                        // color: Colors.white,
                      ),
                    ),
                    PopupMenuItem(
                onTap: ()async {
                await showDialog(
                context: context,
                builder: (_) => Dialog(
                child: Container(
                width: MediaQuery.of(context).size.width / 2.5,
                height: MediaQuery.of(context).size.height / 2.5,
                decoration: BoxDecoration(
                border: Border.all(width: 1,color: Colors.white),
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                // borderRadius: BorderRadius.circular(8),
                boxShadow: [
                BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 1, // blur radius
                offset: Offset(4, 2),
                )
                ],
                image: DecorationImage(image: dp == 'default'?AssetImage('images/OIP.jpeg') as ImageProvider:MemoryImage(base64Decode(dp)), fit: BoxFit.cover)),
                ),
                ),
                );},
                      child: const Center(
                        child: Text(
                          'View DP',
                        ),
                      ),
                    ),
                    const PopupMenuItem(
                      padding: EdgeInsets.all(0),
                      height: 2,
                      child: Divider(
                        height: 2,
                        color: Colors.black,
                        // color: Colors.white,
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () async {
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        pref.remove('username');
                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return SignPage();
                              },
                            ),
                            (route) => false,
                          );
                        }
                      },
                      padding: EdgeInsets.all(0),
                      child: Center(
                        child: Text('Log Out'),
                      ),
                    ),
                  ],
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: dp == "default"
                    ? Image.asset(
                        'images/OIP.jpeg',
                        width: 55,
                        height: 55  ,
                        fit: BoxFit.cover,
                      )
                    : Image.memory(
                        base64Decode(dp),
                        width: 55,
                        height: 55,
                        fit: BoxFit.cover,
                      ),
                // child: Image.asset('images/OIP.jpeg',width: 55,height: 55,fit: BoxFit.cover,),
              ),
            ),
          )
        ],
        centerTitle: false,
        elevation: 0,
      ),

      body: WillPopScope(
        onWillPop: () {
          // dispose();
          onClosing();
          Navigator.of(context).pop();
          return Future(() => true);
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Divider(
              //   thickness: 1,
              //   color: Colors.grey[300],
              // ),
              // Padding(
              //   padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
              //   child: Text(
              //     'Below are messages with your friends.',
              //     style: FlutterFlowTheme.of(context).labelMedium,
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(16),
              //   child: TextField(
              //     onChanged: searchChats,
              //     decoration: InputDecoration(
              //       prefixIcon: const Icon(Icons.search),
              //       hintText: 'Search chats...',
              //     ),
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.fromLTRB(16,16,16,16),
                child: TextField(
                  controller: searchController,
                  // style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'search',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 7),
                  ),
                  onChanged: searchChats,
                ),
              ),
              if (allChats.isEmpty)
                Center(
                  child: Text('you have no chats'),
                ),
              if (allChats.isNotEmpty)
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: ((context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          // color: Colors.white54,
                          color: Colors.grey[300],
                          child: Column(
                            children: [
                              InkWell(
                                child: allChats[index][2] == true
                                    ? ChatWidget(
                                        allChats[index][3],
                                        allChats[index][1].substring(1).contains("data:image/png;")?'image':allChats[index][1].substring(1),
                                        allChats[index][1][0] == '0',
                                        allChats[index][4],
                                        allChats[index][0])
                                    : ChatWidget(
                                        allChats[index][3],
                                        'New Message',
                                        false,
                                        allChats[index][4],
                                        allChats[index][0]),
                                onTap: () {
                                  getno(allChats[index][3]);
                                  getphone(allChats[index][0]);
                                  openChat(widget.username, allChats[index][0],
                                      allChats[index][3], allChats[index][4],phonenumber);
                                  // setState(() {});
                                },
                              ),
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: FlutterFlowTheme.of(context).alternate,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    itemCount: allChats.length,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    onPressed: openNew, // Call your function to open a new chat screen
                    tooltip: 'Add',
                    child: Icon(Icons.add),
                    backgroundColor: Colors.blue,
                    heroTag: FloatingActionButtonLocation.endDocked,// Change the color as needed
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
