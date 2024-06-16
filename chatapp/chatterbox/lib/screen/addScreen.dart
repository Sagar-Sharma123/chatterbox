import 'package:chatterbox/config.dart';
import 'package:chatterbox/screen/chatScreen.dart';
import 'package:chatterbox/widgets/chatWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

class AddUserScreen extends StatefulWidget {

  const AddUserScreen(this.currUsers, this.username, this.socket,this.phonenumber, {super.key});

  final List<String> currUsers;
  final String username;
  final IO.Socket? socket;
  final String phonenumber;

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen>
    with WidgetsBindingObserver {
  var allUsers = [];
  var newUsers = [];
  var filterUsers = [];

  TextEditingController? searchController = TextEditingController();

  void searchUser(String query) {
    final suggestion =
        newUsers.where((element) => element[1].contains(query)).toList();
    setState(() {
      filterUsers = suggestion;
    });
  }

  openChat(String sender, String receiver, String dname, String dp) {
    Route route = MaterialPageRoute(
        builder: (context) =>
            ChatScreen(sender, receiver, widget.socket, dname, dp,widget.phonenumber));
    Navigator.of(context).push(route).then((val) {
      if (val == true) {
        widget.currUsers.add(receiver);
      }
      setState(() {
        getAllUsers();
      });
    });
  }

  getAllUsers() async {
    var response = await http.get(Uri.parse(server + 'getAllUser'));
    allUsers = jsonDecode(response.body);
    setState(() {
      getNewUsers();
    });
  }

  getNewUsers() {
    newUsers = allUsers.where((val) {
      return !widget.currUsers.contains(val[0]);
    }).toList();
    filterUsers = newUsers;
    // setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    getAllUsers();
    widget.socket?.on('status', (value) {
      setState(() {
        // getAllUser();
      });
    });
    widget.socket?.on('receive', (value) {
      // print(value);
      if (!widget.currUsers.contains(value)) widget.currUsers.add(value);

      setState(() {
        getAllUsers();
      });
    });
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (AppLifecycleState.paused == state) {
      widget.socket?.emit('pause', widget.username);
    }
    if (AppLifecycleState.resumed == state) {
      // connect();
      widget.socket?.emit('signin', widget.username);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onHorizontalDragUpdate: (details) {
      if (details.delta.dx < 0) {
        // Swiping from left to right
        Navigator.of(context).pop();
      }
    },
      child:Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        automaticallyImplyLeading: false,
        title: Text(
          'New Friends',
          style: FlutterFlowTheme.of(context).headlineLarge,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
            color: Colors.black,
          ),
        ],
        centerTitle: false,
        elevation: 0,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
            child: Text(
              'Add new Friends to Chat',
              style: FlutterFlowTheme.of(context).labelMedium,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 7),
              ),
              onChanged: searchUser,
            ),
          ),
          if (filterUsers.isEmpty)
            const Expanded(
              child: Center(
                child: Text('No new user found'),
              ),
            ),
          if (filterUsers.isNotEmpty)
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: ((context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow:[
                            BoxShadow(
                              color : Color.fromARGB(255, 213, 205, 205),
                              offset : Offset.zero,
                              blurRadius :5.0,
                              spreadRadius :1.0,
                              blurStyle : BlurStyle.solid,
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            InkWell(
                              child:
                              ChatWidget(
                                  filterUsers[index][1],
                                  'Start Chatting...',
                                  false,
                                  filterUsers[index][2],
                                  filterUsers[index][0]),
                              onTap: () {
                                openChat(widget.username, filterUsers[index][0],
                                    filterUsers[index][1], filterUsers[index][2]);
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
                  itemCount: filterUsers.length,
                ),
              ),
            ),
        ],
      ),
    ));
  }
}