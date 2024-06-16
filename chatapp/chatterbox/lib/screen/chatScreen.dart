import 'dart:convert';
import 'dart:io';

import 'package:chatterbox/config.dart';
import 'package:chatterbox/screen/VoiceCallScreen.dart';
import 'package:chatterbox/widgets/receive.dart';
import 'package:chatterbox/widgets/send.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  const ChatScreen(this.sender, this.receiver, this.socket, this.dname, this.dp,this.phonenumber,
      {super.key});

  final IO.Socket? socket;
  final String sender;
  final String receiver;
  final String dname;
  final String dp;
  final String phonenumber;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  var msg = [];
  bool isChatted = false;

  FocusNode? textFieldFocusNode;
  TextEditingController? sendController = TextEditingController();
  String? Function(BuildContext, String?)? sendControllerValidator;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (AppLifecycleState.paused == state) {
      // widget.socket?.emit('pause', widget.sender);
      seenMsg(widget.sender, widget.receiver);
    }
    // if (AppLifecycleState.resumed == state) {
    //   widget.socket?.emit('signin', widget.sender);
    // }
    // print(state);
  }

  seenMsg(String sender, String receiver) async {
    var reqBody = {
      'sender': sender,
      'receiver': receiver,
    };
    await http
        .get(Uri.parse(server + 'seen').replace(queryParameters: reqBody));
  }

  sendNew(String sender, String receiver) async {
    var reqBody = {
      'sender': sender,
      'receiver': receiver,
    };
    await http.get(Uri.parse(server + 'new').replace(queryParameters: reqBody));
  }

  receiveSocket() {
    widget.socket?.on('receive', (data) {
      setState(() {
        getChat();
      });
    });
  }

  sendSocket() {
    widget.socket?.emit('send', widget.receiver);
  }

  getChat() async {
    var reqBody = {
      'sender': widget.sender,
      'receiver': widget.receiver,
    };
    var response = await http
        .get(Uri.parse(server + chat).replace(queryParameters: reqBody));

    var retValue = jsonDecode(response.body);

    if (retValue.toString() != '{}') {
      isChatted = true;
      msg = retValue;
      setState(() {});
    }
  }

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) => getChat());
    getChat();

    receiveSocket();
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  sendMessage() async {
    if (sendController.text.isNotEmpty) {
      isChatted = true;
      var reqBody = {
        'sender': widget.sender,
        'receiver': widget.receiver,
        'msg': sendController.text
      };

      var response = await http.post(
        Uri.parse(server + chat),
        headers: {"content-type": "application/json"},
        body: jsonEncode(reqBody),
      );

      if (jsonDecode(response.body)['send']) {
        sendController?.clear();
        await sendNew(widget.sender, widget.receiver);
        sendSocket();
        setState(() {
          getChat();
        });
      }
    }
  }

  // void sendDocument() async {
  //   try {
  //     final path = await FlutterDocumentPicker.openDocument();
  //     if (path != null) {
  //       // Send the document using sockets or perform any other operations
  //       print('Selected document path: $path');
  //       // Example: sendMessage(path, widget.sourchat.id, widget.chatModel.id);
  //     } else {
  //       // User canceled the document picking operation
  //       print('Document picking canceled');
  //     }
  //   } catch (e) {
  //     print('Error picking document: $e');
  //     // Handle error
  //   }
  // }

  void openCamera() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
      maxWidth: 340,
    );
    if (pickedImage == null) {
      return;
    }
    if (context.mounted) {
      Navigator.of(context).pop();
    }
    // currImage = pickedImage;
    var path = pickedImage!.path;
    List<int> imageBytes = await File(path).readAsBytes();
    var b64 = base64Encode(imageBytes);
    sendController.text = "data:image/png;"+b64;
    // setState(() {});
  }

  void openGallery() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxWidth: 340,
    );
    if (pickedImage == null) {
      return;
    }
    if (context.mounted) {
      Navigator.of(context).pop();
    }
    // currImage = pickedImage;
    var path = pickedImage!.path;
    final File imageFile = File(path!);
    if (!imageFile.existsSync()) {
      // Handle the case where the image file doesn't exist
      return;
    }
    final List<int> imageBytes = await imageFile.readAsBytes();
    final String base64Image = base64Encode(imageBytes);
    sendController.text = "data:image/png;"+base64Image;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onHorizontalDragUpdate: (details) {
      if (details.delta.dx < 0 && details.primaryDelta!.abs() > details.delta.dy.abs()) {
        // Swiping from left to right
        Navigator.of(context).pop(isChatted);
      }
    },
      child: Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        automaticallyImplyLeading: false,
        title: Align(
          alignment: const AlignmentDirectional(-1, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: InkWell(
                  child: widget.dp == 'default'
                      ? Image.asset(
                    'images/OIP.jpeg',
                    width: 49,
                    height: 49,
                    fit: BoxFit.cover,
                  )
                      : Image.memory(
                    base64Decode(widget.dp),
                    width: 49,
                    height: 49,
                    fit: BoxFit.cover,
                  ),
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
                                image: DecorationImage(image: widget.dp == 'default'?AssetImage('images/OIP.jpeg') as ImageProvider:MemoryImage(base64Decode(widget.dp)), fit: BoxFit.cover)),
                          ),
                        ),
                      );},
                )
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 2*MediaQuery.of(context).size.width/3.5,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                      child: Text(
                        widget.dname,
                        style:
                            FlutterFlowTheme.of(context).headlineMedium.override(
                                  fontFamily: 'Outfit',
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                      ),
                    ),
                  ),
                  // SizedBox(width: 50,),
                  // Padding(
                  //     padding: const EdgeInsetsDirectional.fromSTEB(8,0,0,0),
                  //     child:Column(
                  //         children: [
                  //           ElevatedButton(
                  //             onPressed: () {
                  //               // Logic to initiate voice call
                  //               print('Initiating voice call...');
                  //             },
                  //             child: Icon(Icons.phone),
                  //           ),
                  //           SizedBox(height: 20),
                  //           ElevatedButton(
                  //             onPressed: () {
                  //               // Logic to initiate video call
                  //               print('Initiating video call...');
                  //             },
                  //             child: Icon(Icons.videocam),
                  //           ),
                  //         ]
                  //     )
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 40,),
                      InkWell(
                        child: Icon(Icons.phone,color: Colors.green,),
                        onTap: (){
                          // VoiceCallScreen(channelName: 'chatroom',);
                          FlutterPhoneDirectCaller.callNumber(widget.phonenumber);
                        },
                      ),
                      // SizedBox(width: 20,),
                      // InkWell(
                      //   child: Icon(Icons.video_camera_front_rounded,color: Colors.green,),
                      // ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        centerTitle: false,
        elevation: 2,
      ),
      body: WillPopScope(
        onWillPop: () {
          Navigator.of(context).pop(isChatted);
          return new Future(() => false);
        },
        child: Align(
          alignment: const AlignmentDirectional(0, 1),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemBuilder: (ctx, idx) {
                    String disText = msg[msg.length - idx - 1];
                    String tog = disText[0];
                    return tog == '0'
                        ? sendText(disText.substring(1))
                        : receiveText(disText.substring(1));
                  },
                  itemCount: msg.length,
                  shrinkWrap: true,
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                child: Container(
                  width:MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0x3157636C),
                    // borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(-1, 1),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 5, 10),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: FlutterFlowTheme.of(context).alternate,
                                // border: Border.all(
                                //   color: Colors.grey,
                                //   width: 2,
                                // )
                              ),
                              child: Row(
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxHeight: 100,
                                      ),
                                      child: Container(
                                        width: MediaQuery.sizeOf(context).width * 0.675,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(4.0,0,0,0),
                                          child: TextFormField(
                                            controller: sendController,
                                            focusNode: textFieldFocusNode,
                                            autofocus: false,
                                            obscureText: false,
                                            maxLines: null,
                                            decoration: InputDecoration(
                                              hintText: 'Message Something',
                                              hintStyle:
                                                  FlutterFlowTheme.of(context).labelMedium,
                                              border: InputBorder.none,
                                              // Optionally, you can remove the underline as well
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.transparent),
                                              ),
                                              focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.transparent),
                                              ),
                                              // enabledBorder: OutlineInputBorder(
                                              //   // borderSide: BorderSide(
                                              //   //   color: FlutterFlowTheme.of(context)
                                              //   //       .alternate,
                                              //   //   width: 2,
                                              //   // ),
                                              //   borderRadius: BorderRadius.circular(20),
                                              // ),
                                              // focusedBorder: OutlineInputBorder(
                                              //   borderSide: BorderSide(
                                              //     color:
                                              //         FlutterFlowTheme.of(context).primary,
                                              //     width: 2,
                                              //   ),
                                              //   borderRadius: BorderRadius.circular(20),
                                              // ),
                                              // errorBorder: OutlineInputBorder(
                                              //   // borderSide: BorderSide(
                                              //   //   color: FlutterFlowTheme.of(context).error,
                                              //   //   width: 2,
                                              //   // ),
                                              //   borderRadius: BorderRadius.circular(0),
                                              // ),
                                              // focusedErrorBorder: OutlineInputBorder(
                                              //   // borderSide: BorderSide(
                                              //   //   color: FlutterFlowTheme.of(context).error,
                                              //   //   width: 2,
                                              //   // ),
                                              //   borderRadius: BorderRadius.circular(0),
                                              // ),
                                            ),
                                            style: FlutterFlowTheme.of(context).bodyMedium,
                                            validator: sendControllerValidator
                                                .asValidator(context),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    offset: Offset(0, 100),
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (BuildContext context) {
                                      return [
                                        // PopupMenuItem(
                                        //   child: ListTile(
                                        //     leading: Icon(Icons.insert_drive_file),
                                        //     title: Text('Document'),
                                        //     onTap: () {
                                        //       // Handle document option
                                        //     },
                                        //   ),
                                        // ),
                                        PopupMenuItem(
                                          child: ListTile(
                                            leading: Icon(Icons.camera_alt),
                                            title: Text('Camera'),
                                            onTap: () {
                                              // Handle camera option
                                              openCamera();
                                            },
                                          ),
                                        ),
                                        PopupMenuItem(
                                          child: ListTile(
                                            leading: Icon(Icons.insert_photo),
                                            title: Text('Gallery'),
                                            onTap: () {
                                              // Handle gallery option
                                              openGallery();
                                            },
                                          ),
                                        ),
                                        // Add more options as needed
                                      ];
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width * 0.075,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Icon(Icons.attach_file, color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                  // Container(
                                  //   width: MediaQuery.of(context).size.width*0.075,
                                  //   child: Align(
                                  //     alignment: Alignment.center,
                                  //     child: Icon(Icons.mic,color: Colors.grey,),
                                  //   ),
                                  // )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(0, 0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 8, 10),
                            child: FlutterFlowIconButton(
                              borderColor: FlutterFlowTheme.of(context).primary,
                              borderRadius: 20,
                              borderWidth: 1,
                              buttonSize: 50,
                              fillColor: FlutterFlowTheme.of(context).accent1,
                              icon: Icon(
                                Icons.send,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 30,
                              ),
                              onPressed: () {
                                // print('IconButton pressed ...');
                                sendMessage();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    )
    );
  }
}
