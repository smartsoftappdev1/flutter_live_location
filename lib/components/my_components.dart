import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyComponents{

  ///for snack bar
  mySnackBar(BuildContext context, String massage){
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.blue,
        content: Text(
          massage,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  ///for wrong snackbar
  wrongSnackBar(BuildContext context, String exp){
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red.withOpacity(.8),
        content: Text(
          exp,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal
          ),
        ),
      ),
    );
  }

  ///for alert dialog
  exitAlertDialog(BuildContext context){
    showDialog(
        context: context,
        builder: (context)=> AlertDialog(
          content: Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                    text: 'Are you sure want to exit from '),
                TextSpan(
                  text:
                  'MeekaGo?',
                  style: TextStyle(
                      fontWeight:
                      FontWeight.bold,
                      color: Colors.blue),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: ()=>Navigator.pop(context),
                child: Text('NO',style: TextStyle(color: Colors.blue),)
            ),
            TextButton(
                onPressed: ()=>SystemNavigator.pop(),
                child: Text('Exit',style: TextStyle(color: Colors.red),)
            ),
          ],
        )
    );
  }
}