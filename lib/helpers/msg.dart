
import 'package:flutter/material.dart';


enum AlertDialogType {
  SUCCESS,
  ERROR,
  WARNING,
  INFO,
  PERSON
}

class CustomAlertDialog extends StatefulWidget {
  final AlertDialogType type;
  final String title;
  final String content;
  final Widget icon;
  final String buttonLabel;
  final showftxt;
  final bool resend;
  final bool deladv;
  final String  showftxtleble;
  final String showftxthint;
  final bool isnum;
  final TextStyle titleStyle = TextStyle(
      fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold);

  CustomAlertDialog(
      {Key key,
        this.title = "Successful",
        @required this.content,
        this.icon,
        this.showftxt,
        this.showftxtleble="كود التحقق",
        this.showftxthint="ادخل كود التحقق هنا",
        this.isnum=true,
        this.resend,
        this.deladv,
        this.type = AlertDialogType.INFO,
        this.buttonLabel = "حسنا"})
      : super(key: key);

  @override
  _CustomAlertDialogState createState() => new _CustomAlertDialogState();

}


class _CustomAlertDialogState extends State<CustomAlertDialog> {
  final code = TextEditingController();
  String checkuserv="";
  bool chkuser=false;


  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Container(
          alignment: Alignment.center,
          child: Container(
            margin: const EdgeInsets.fromLTRB(25,15,25,15),
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 10.0),
                widget.icon ??
                    Icon(
                      _getIconForType(widget.type),
                      color: _getColorForType(widget.type),
                      size: 50,
                    ),
                const SizedBox(height: 10.0),
                Text(
                  widget.title,
                  style: widget.titleStyle,
                  textAlign: TextAlign.center,
                ),
                Divider(),
                Text(
                  widget.content,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40.0),
                SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                    color: Colors.grey[100],
                    padding: const EdgeInsets.all(5.0),
                    child: Text(widget.buttonLabel),
                    onPressed: () => Navigator.pop(context, true),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  IconData _getIconForType(AlertDialogType type) {
    switch (type) {
      case AlertDialogType.WARNING:
        return Icons.warning;
      case AlertDialogType.SUCCESS:
        return Icons.check_circle;
      case AlertDialogType.ERROR:
        return Icons.error;
      case AlertDialogType.PERSON:
        return Icons.person_pin;
      case AlertDialogType.INFO:
      default:
        return Icons.info_outline;
    }
  }

  Color _getColorForType(AlertDialogType type) {
    switch (type) {
      case AlertDialogType.WARNING:
        return Colors.orange;
      case AlertDialogType.SUCCESS:
        return Colors.green;
      case AlertDialogType.ERROR:
        return Colors.red;
      case AlertDialogType.INFO:
      default:
        return Colors.blue;
    }
  }
}



