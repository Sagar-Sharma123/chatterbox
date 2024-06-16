// import 'package:flutter/material.dart';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// const agoraAppId = '89dd34b11dd94b17a0617a255f05b130';
// const token = "007eJxTYJg7/2q23R4PNclp5Vv3utVMKX+wq8c2cXpl9pMjsS8WH5NRYLCwTEkxNkkyNExJsQRS5okGZkDCyNQ0zcA0ydDYQD7TMK0hkJFhVmEgEyMDBIL4HAzJGYklRfn5uQwMAAw0IRU=";
// const channel = "chatroom";
//
// class VoiceCallScreen extends StatefulWidget {
//   final String channelName;
//
//   const VoiceCallScreen({Key? key, required this.channelName}) : super(key: key);
//
//   @override
//   _VoiceCallScreenState createState() => _VoiceCallScreenState();
// }
//
// class _VoiceCallScreenState extends State<VoiceCallScreen> {
//   int? _remoteUid;
//   bool _localUserJoined = false;
//   late RtcEngine _engine;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeAgora();
//   }
//
//   @override
//   void dispose() {
//     // Leave channel and destroy engine
//     _engine.leaveChannel();
//     _engine.release();
//     super.dispose();
//   }
//
//   Future<void> _initializeAgora() async {
//     await [Permission.microphone, Permission.camera].request();
//
//     //create the engine
//     var _engine = createAgoraRtcEngine();
//     await _engine.initialize(const RtcEngineContext(
//       appId: agoraAppId,
//       channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
//     ));
//
//     _engine.registerEventHandler(
//         RtcEngineEventHandler(
//           onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//             debugPrint("local user ${connection.localUid} joined");
//             setState(() {
//               _localUserJoined = true;
//             });
//           },
//           onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//             debugPrint("remote user $remoteUid joined");
//             setState(() {
//               _remoteUid = remoteUid;
//             });
//           },
//           onUserOffline: (RtcConnection connection, int remoteUid,
//               UserOfflineReasonType reason) {
//             debugPrint("remote user $remoteUid left channel");
//             setState(() {
//               _remoteUid = null;
//             });
//           },
//           onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
//             debugPrint(
//                 '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
//           },
//         ));
//     await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
//     await _engine.enableVideo();
//     await _engine.startPreview();
//
//     await _engine.joinChannel(
//       token: token,
//       channelId: channel,
//       uid: 0,
//       options: const ChannelMediaOptions(),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Voice Call'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             // End call
//             _engine.leaveChannel();
//             Navigator.pop(context);
//           },
//           child: Text('End Call'),
//         ),
//       ),
//     );
//   }
// }