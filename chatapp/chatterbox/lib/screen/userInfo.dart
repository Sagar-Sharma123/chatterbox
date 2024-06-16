import 'package:chatterbox/config.dart';
import 'package:chatterbox/screen/mainScreen.dart';
import 'package:chatterbox/widgets/bottomSelect.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GetUserScreen extends StatefulWidget {
  GetUserScreen(this.username, this.dname, this.dp, this.sbText, {super.key});

  final String username;
  final String dname;
  String dp;
  final String sbText;

  @override
  State<GetUserScreen> createState() => _GetUserScreenState();
}

class _GetUserScreenState extends State<GetUserScreen> {
  ImagePicker picker = ImagePicker();

  final unfocusNode = FocusNode();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? dnameController;
  String? Function(BuildContext, String?)? textControllerValidator;

  // var dp = '';

  save(String dname, String dp) async {
    // print(dnameController.text);
    if (!(dname.isEmpty && dp.isEmpty)) {
      var reqBody = {
        'username': widget.username,
        'dname': dname.isEmpty ? widget.username : dname,
        'dp': dp.isEmpty ? "default" : dp,
      };
      // print(file);
      var res = await http.post(
        Uri.parse(server + 'save'),
        headers: {"content-type": "application/json"},
        body: jsonEncode(reqBody),
      );
    }

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) {
          return MainScreen(widget.username);
        },
      ), (route) => false);
    }

    // var res = await http.get(Uri.parse(server + 'save'));
    // a = jsonDecode(res.body)['file'];
    // setState(() {});
  }

  getImageCamera() async {
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
    widget.dp = b64;
    setState(() {});
  }

  getImageGallery() async {
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
    widget.dp = base64Image;
    setState(() {
      widget.dp = base64Image;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    dnameController = TextEditingController(text: widget.dname);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.delta.dx < 0 && details.primaryDelta!.abs() > details.delta.dy.abs()) {
            // Swiping from left to right
            Navigator.of(context).pop();
          }
        },
      child: Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        automaticallyImplyLeading: false,
        title: Align(
          alignment: const AlignmentDirectional(0, 0),
          child: Text(
            'Enter Your Info',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  color: Colors.white,
                  fontSize: 22,
                ),
          ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 2,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 100, 0, 10),
            child: CircleAvatar(
              radius: 100,
              // backgroundColor: Icons.verified_user
              backgroundImage: widget.dp == 'default'
                  ? const AssetImage('images/OIP.jpeg')
                  : null,
              foregroundImage: widget.dp == 'default'
                  ? null
                  : MemoryImage((base64Decode(widget.dp))),
            ),
          ),
          TextButton.icon(
            onPressed: () {
              // showBottomSheet(
              //   context: context,
              //   builder: (context) {
              //     return Text('hello');
              //   },
              // );
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return SelectSource(getImageCamera, getImageGallery);
                  // final pickedImage = await ImagePicker().pickImage(
                  //   source: ImageSource.gallery,
                  //   imageQuality: 50,
                  //   maxWidth: 150,
                  // );
                  // var path;
                  // if (pickedImage == null)
                  //   path = '//images/OIP.jpeg';
                  // else
                  // var path = pickedImage!.path;
                  // List<int> imageBytes = pickedImage!.readAsBytesSync();
                  // if (pickedImage == null) {
                  //   var bytes = await ;
                  //   print(bytes);
                  //
                  //   return;
                  // }
                  // print(path);
                  // var bytes = await File(path).readAsBytes();
                  // // print(bytes);
                  // var b64 = base64Encode(bytes);
                  // // print(b64);
                  // var dbytes = base64Decode(b64);
                  // var image = Image.memory(dbytes);
                  // print(image);
                  // await save(b64);
                  // await save(b64);
                },
              );
            },
            icon: Icon(Icons.image),
            label: Text('Add Image'),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                  child: Text(
                    'Display Name:',
                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                          fontFamily: 'Readex Pro',
                          fontSize: 20,
                        ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                    child: TextFormField(
                      // initialValue: widget.dname,
                      controller: dnameController,
                      focusNode: textFieldFocusNode,
                      // autofocus: true,
                      obscureText: false,
                      decoration: InputDecoration(
                        // labelText: 'Label here...',
                        labelStyle: FlutterFlowTheme.of(context).labelMedium,
                        hintStyle: FlutterFlowTheme.of(context).labelMedium,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 4,
                          ),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blueAccent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 4,
                          ),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 4,
                          ),
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Readex Pro',
                            fontSize: 18,
                          ),
                      validator: textControllerValidator.asValidator(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(0, 200, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                    child: FFButtonWidget(
                      onPressed: () {
                        // print('Button pressed ...');
                        if (widget.sbText == 'Skip') {
                          save('', '');
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      text: widget.sbText,
                      options: FFButtonOptions(
                        width: 160,
                        height: 50,
                        color: FlutterFlowTheme.of(context).primaryBtnText,
                        textStyle: FlutterFlowTheme.of(context)
                            .labelLarge
                            .override(
                                fontFamily: 'Readex Pro',
                                fontWeight: FontWeight.normal,
                                color: Colors.black87),
                        elevation: 2,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(7, 0, 0, 0),
                    child: FFButtonWidget(
                      onPressed: () {
                        // print('Button pressed ...');
                        save(dnameController.text, widget.dp);
                        // print(dnameController.text);
                      },
                      text: 'Save',
                      options: FFButtonOptions(
                        width: 160,
                        height: 50,
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle:
                            FlutterFlowTheme.of(context).labelLarge.override(
                                  fontFamily: 'Readex Pro',
                                  color: Colors.white,
                                ),
                        elevation: 2,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      // if (a.isNotEmpty) Image.memory((base64Decode(a))),
      // if (a.isEmpty) Image.asset('images/OIP.jpeg')
    ));
  }
}
