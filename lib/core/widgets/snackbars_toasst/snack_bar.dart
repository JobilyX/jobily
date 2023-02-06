// import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

SnackBar appSnackBar(String snackText, {Color color = Colors.red}) => SnackBar(
      content: Text(
        tr(snackText),
        textAlign: TextAlign.center,
      ),
      duration: const Duration(seconds: 1),
      backgroundColor: color,
      // action: [SnackBarAction(label: tr("ok"), onPressed: (){})],
    );

class AppThiefs extends StatefulWidget {
  const AppThiefs({Key? key}) : super(key: key);

  @override
  State<AppThiefs> createState() => _AppThiefsState();
}

class _AppThiefsState extends State<AppThiefs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: Center(
            child: Text(tr("thiefs")),
          ))
        ],
      ),
    );
  }
}
