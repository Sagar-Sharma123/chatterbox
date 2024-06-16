import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class sendText extends StatelessWidget {
  const sendText(this.displayText ,{super.key});

  final String displayText;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(1, 0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 10),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.65,
          ),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondary,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0),
              topLeft: Radius.circular(25),
              topRight: Radius.circular(0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
            child: displayText.contains("data:image/png")?InkWell(
              child: Image.memory(base64Decode(displayText.split(';')[1])
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
              image: DecorationImage(image: MemoryImage(base64Decode(displayText.split(';')[1])), fit: BoxFit.fill)),
              ),
              ),
            );}):Text(
              displayText,
              textAlign: TextAlign.start,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Readex Pro',
                fontSize: 16,
              ),
            ),
            // child: Text(
            //   displayText,
            //   textAlign: TextAlign.start,
            //   style: FlutterFlowTheme.of(context).bodyMedium.override(
            //         fontFamily: 'Readex Pro',
            //         fontSize: 16,
            //       ),
            // ),
          ),
        ),
      ),
    );
  }
}
