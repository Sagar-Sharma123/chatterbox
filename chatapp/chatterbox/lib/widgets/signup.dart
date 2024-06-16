// ignore_for_file: must_be_immutable

import 'package:chatterbox/config.dart';
import 'package:chatterbox/screen/userInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatelessWidget {
  SignUp(this.changePage, {super.key});

  void Function() changePage;
  TextEditingController? userController = TextEditingController();
  String? Function(BuildContext, String?)? userControllerValidator;
  FocusNode? textFieldFocusNode2;
  TextEditingController? passController = TextEditingController();
  String? Function(BuildContext, String?)? passControllerValidator;
  FocusNode? textFieldFocusNode1;
  FocusNode? textFieldFocusNode3;
  TextEditingController? phoneController = TextEditingController();
  String? Function(BuildContext, String?)? phoneControllerValidator;

  void registerUser(BuildContext context) async {
    if (userController.text.isEmpty ||
        passController.text.isEmpty ||
        phoneController.text.isEmpty) {
    } else {
      var reqBody = {
        "phonenumber": phoneController.text,
        "username": userController.text,
        "password": passController.text
      };
      var response = await http.post(
        Uri.parse(server + singup),
        body: jsonEncode(reqBody),
        headers: {"content-type": "application/json"},
      );
      if (jsonDecode(response.body)['connection'] && context.mounted) {
        // changePage();
        // getMain(userController.text);
        // GetUserScreen(userController.text);
        // Navigator.of(context).

        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString('username', userController.text);
        showUser(context, userController.text);
      }
    }
  }

  void showUser(BuildContext context, String username) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => GetUserScreen(username, "", "default", "Skip")));
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      // alignment: const AlignmentDirectional(-0.2, 0.56),
      alignment: Alignment.center,
      child: Container(
        width: 339,
        height: 532,
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
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: const AlignmentDirectional(-1, 0),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                        child: Text(
                          'Phone-Number',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
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
                        controller: phoneController,
                        focusNode: textFieldFocusNode3,
                        autofocus: true,
                        obscureText: false,
                        decoration: InputDecoration(
                          // labelText: 'E-mail',
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
                        validator:
                            phoneControllerValidator.asValidator(context),
                      ),
                    ),
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
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
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
                            registerUser(context);
                          },
                          text: 'Sign up',
                          options: FFButtonOptions(
                            height: 40,
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24, 0, 24, 0),
                            iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
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
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 20, 0, 0),
                            child: Text(
                              'Already have an Account?',
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
                            text: 'Sign in',
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
            )),
      ),
    );
  }
}
