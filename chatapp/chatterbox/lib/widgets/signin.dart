// ignore_for_file: must_be_immutable

import 'package:chatterbox/config.dart';
import 'package:chatterbox/screen/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatelessWidget {
  SignIn(this.changePage, {super.key});

  void Function() changePage;

  TextEditingController? userController = TextEditingController();
  String? Function(BuildContext, String?)? userControllerValidator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? passController = TextEditingController();
  String? Function(BuildContext, String?)? passControllerValidator;
  FocusNode? textFieldFocusNode1;

  void loginUser(BuildContext context) async {
    if (userController.text.isEmpty || passController.text.isEmpty) {
    } else {
      print(userController.text);
      print(passController.text);
      var reqBody = {
        "username": userController.text,
        "password": passController.text
      };

      var response = await http.post(
        Uri.parse(server + signin),
        headers: {"content-type": "application/json"},
        body: jsonEncode(reqBody),
      );

      if (jsonDecode(response.body)['connection'] == true && context.mounted) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString('username', userController.text);
        showMain(context, userController.text);
      } else if (jsonDecode(response.body)['connection'] == false) {
        changePage();
      }
    }
  }

  void showMain(BuildContext context, String username) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (ctx) => MainScreen(username)));
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      // alignment: const AlignmentDirectional(-0.2, 0.56),
      alignment: Alignment.center,
      child: Container(
        width: 339,
        height: 400,
        decoration: const BoxDecoration(
          color: Color(0x41FFFFFF),
        ),
        child: Align(
          alignment: const AlignmentDirectional(-1, 0),
          child: Align(
            alignment: const AlignmentDirectional(0, 0),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: const AlignmentDirectional(-1, 1),
                    child: Text(
                      'username',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Readex Pro',
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(8, 5, 8, 0),
                    child: TextFormField(
                      controller: userController,
                      focusNode: textFieldFocusNode1,
                      autofocus: true,
                      obscureText: false,
                      decoration: InputDecoration(
                        // labelText: 'username',
                        labelStyle: FlutterFlowTheme.of(context).labelMedium,
                        hintStyle: FlutterFlowTheme.of(context).labelMedium,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium,
                      validator: userControllerValidator.asValidator(context),
                    ),
                  ),
                  Align(
                    alignment: const AlignmentDirectional(-1, 0),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                      child: Text(
                        'password',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Readex Pro',
                              color: const Color(0x98000000),
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(8, 5, 8, 0),
                    child: TextFormField(
                      controller: passController,
                      focusNode: textFieldFocusNode2,
                      autofocus: true,
                      obscureText: true,
                      decoration: InputDecoration(
                        // labelText: 'password',
                        labelStyle: FlutterFlowTheme.of(context).labelMedium,
                        hintStyle: FlutterFlowTheme.of(context).labelMedium,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium,
                      validator: passControllerValidator.asValidator(context),
                    ),
                  ),
                  Align(
                    alignment: const AlignmentDirectional(-1, 1),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                      child: FFButtonWidget(
                        onPressed: () {
                          loginUser(context);
                        },
                        text: 'Sign in',
                        options: FFButtonOptions(
                          height: 40,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              24, 0, 24, 0),
                          iconPadding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Readex Pro',
                                    color: Colors.white,
                                  ),
                          elevation: 3,
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: const AlignmentDirectional(-1, 0),
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                          child: Text(
                            'Don\'t have an account?',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Readex Pro',
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 18, 0, 0),
                        child: FFButtonWidget(
                          onPressed: changePage,
                          text: 'Sign up',
                          options: FFButtonOptions(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                2, 0, 0, 0),
                            iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 0),
                            color: const Color(0x00FFFFFF),
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Readex Pro',
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                ),
                            elevation: 0,
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                              width: 0,
                            ),
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
