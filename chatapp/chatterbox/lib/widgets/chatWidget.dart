// ignore: file_names
import 'dart:convert';

import 'package:chatterbox/config.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:http/http.dart' as http;

class ChatWidget extends StatelessWidget {
  ChatWidget(
      this.receiver, this.firstChat, this.isSend, this.dp, this.recUsername,
      {super.key});

  final String firstChat;
  final String receiver;
  final bool isSend;
  final String dp;
  final String recUsername;
  String status = "";

  getStatus(String user) async {
    var reqBody = {
      'user': user,
    };
    var response = await http.get(
        Uri.parse(server + 'checkStatus').replace(queryParameters: reqBody));

    // status = response.body;
    if (response.body == 'true') {
      status = 'online';
    } else {
      status = 'offline';
    }
  }

  // @override
  // void initState() {
  //   // super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // getFirstChat(receiver);
    getStatus(recUsername);
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
      child: Material(
        color: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(0),
            // border: Border.all(
            //   color: Colors.black,
            //   width: 1,
            // ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container(
                //   width: 60,
                //   height: 60,
                //   decoration: BoxDecoration(
                //     color: FlutterFlowTheme.of(context).accent1,
                //     shape: BoxShape.circle,
                //     // border: Border.all(
                //     //   color: FlutterFlowTheme.of(context).primary,
                //     //   width: 1,
                //     // ),
                //   ),
                //   child: Padding(
                //     padding: const EdgeInsets.all(2),
                //     child: ClipRRect(
                //       borderRadius: BorderRadius.circular(60),
                //       child: Image.network(
                //         'https://source.unsplash.com/random/1280x720?user&2',
                //         width: 44,
                //         height: 60,
                //         fit: BoxFit.cover,
                //       ),
                //     ),
                //   ),
                // ),
                CircleAvatar(
                  backgroundImage:
                      dp == 'default' ? AssetImage('images/OIP.jpeg') : null,
                  foregroundImage:
                      dp == 'default' ? null : MemoryImage(base64Decode(dp)),
                  radius: 30,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              receiver,
                              textAlign: TextAlign.start,
                              style: FlutterFlowTheme.of(context).headlineSmall,
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Text(
                                  "@" + recUsername,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                  maxLines: 20,
                                  overflow: TextOverflow.ellipsis,
                                  // textAlign: TextAlign.,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: isSend
                              ? const EdgeInsetsDirectional.fromSTEB(
                                  80, 4, 20, 6)
                              : const EdgeInsetsDirectional.fromSTEB(
                                  20, 4, 80, 6),
                          child: Align(
                            alignment: isSend
                                ? const AlignmentDirectional(1, 0)
                                : const AlignmentDirectional(-1, 0),
                            child: Text(
                              firstChat,
                              textAlign: TextAlign.start,
                              style: FlutterFlowTheme.of(context).bodyLarge,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Align(
                                alignment: AlignmentDirectional(-1, 0),
                                child: Text(
                                  "Click to Chat",
                                  textAlign: TextAlign.start,
                                  style:
                                      FlutterFlowTheme.of(context).labelSmall,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 2),
                              child: FutureBuilder(
                                  future: getStatus(recUsername),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Text(
                                        "",
                                        textAlign: TextAlign.start,
                                        style: FlutterFlowTheme.of(context)
                                            .labelSmall,
                                      );
                                    } else {
                                      return Text(
                                        status,
                                        textAlign: TextAlign.start,
                                        style: FlutterFlowTheme.of(context)
                                            .labelSmall,
                                      );
                                    }
                                  }),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
