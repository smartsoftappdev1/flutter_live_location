import 'package:flutter/material.dart';
import 'package:flutter_live_location/api/auth_api.dart';
import 'package:flutter_live_location/login/login_screen.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../components/default_button.dart';
import '../../components/form_error.dart';
import '../../employee_list_screen.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  late ProgressDialog pr;
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool remember = false;
  final List<String> errors = [];
  String? _token;


  void addError({required String error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  void _handleSubmitted() async {
    final FormState form = _formKey.currentState!;
    if (!form.validate()) {
      showSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      pr.show();
      await AuthApi.authenticateUser(email!, password!).then((value) => {
            pr.hide(),
            if(value!=null){
              print("token: ${value['token']}"),
              Navigator.push(context, MaterialPageRoute(builder: (_) => EmployeeListScreen()))
            }
          });
    }
  }



  void showSnackBar(String s) {
    final snackBar = SnackBar(
      content: Text(s),
      backgroundColor: const Color(0xffae00f0),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context);
    pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    return Theme(
      data: ThemeData(
        primaryColor: Colors.redAccent,
        primaryColorDark: Colors.red,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            buildEmailFormField(),
            const SizedBox(height: 30),
            buildPasswordFormField(),
            const SizedBox(height: 30),

            // Align(alignment: Alignment.topRight,
            // child: GestureDetector(
            //       onTap: () => Navigator.pushNamed(
            //           context, ForgotPasswordScreen.routeName),
            //       child: Text(
            //         "Forgot Password",
            //         style: TextStyle(decoration: TextDecoration.underline),
            //       ),x`xX     XX`X
            //     )
            // ),
            FormError(errors: errors),
            const SizedBox(height: 20),
            DefaultButton(
              text: "Continue",
              press: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  KeyboardUtil.hideKeyboard(context);
                  _handleSubmitted();
                  // Navigator.pushNamed(context, HomePage.routeName);
                }
              }, color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  bool _hidepass = true;

  void ViewPass(){
    setState(() {
      _hidepass = !_hidepass;
    });
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: _hidepass,
      onSaved: (newValue) => password = newValue!,
      autofillHints: const [AutofillHints.password],
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please Enter your password");
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: "Please Enter your password");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        floatingLabelStyle: const TextStyle(color: Colors.redAccent),
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: InkWell(
          onTap: ViewPass,
            child: _hidepass? const Icon(Icons.visibility_off):const Icon(Icons.visibility),),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.redAccent,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black26,
            width: 2.0,
          ),
        ),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofillHints: [AutofillHints.email],
      onSaved: (newValue) => email = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please Enter your email");
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: "Please Enter your email");
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        floatingLabelStyle: TextStyle(color: Colors.redAccent),
        focusedBorder: OutlineInputBorder(
            //borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(
              color: Colors.redAccent,
            ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black26,
            width: 2.0,
          ),
        ),
        prefixIcon: Icon(Icons.mail_outline),
      ),
    );
  }
}


class KeyboardUtil {
  static void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}
