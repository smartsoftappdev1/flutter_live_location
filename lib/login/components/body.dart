import 'package:flutter/material.dart';
import 'sign_form.dart';

class Body extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 50,left: 32,right: 32),
              child:  Column(
              children: <Widget>[
                SizedBox(height:  MediaQuery.of(context).size.height * (80 / 812.0),),
                const Text(
                  "Sign in with your email and password ",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                SignForm(),
                const SizedBox(height: 20),

              ],
            ),
          )
        ),
      ),
    );
  }
}
