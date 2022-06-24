import 'package:app_crud_auth_local/common/helper.dart';
import 'package:app_crud_auth_local/common/text_form_field.dart';
import 'package:app_crud_auth_local/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.dart';
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  final _controllerUserId = TextEditingController();
  final _controllerPassword = TextEditingController();
  var dbHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DbHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CRUD LOCAL"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                "LOGIN",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormEdit(
                  controller: _controllerUserId,
                  icon: Icons.person,
                  hintName: 'User ID'),
              const SizedBox(height: 10.0),
              TextFormEdit(
                controller: _controllerPassword,
                icon: Icons.lock,
                hintName: 'Password',
                isObscureText: true,
              ),
              Container(
                margin: const EdgeInsets.all(30.0),
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: login,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Does not have account? '),
                  ElevatedButton(
                    child: const Text('Signup'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RegisterPage()));
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  login() async {
    String uid = _controllerUserId.text;
    String passwd = _controllerPassword.text;

    if (uid.isEmpty) {
      alertDialog(context, const Text("Please Enter User ID"));
    } else if (passwd.isEmpty) {
      alertDialog(context, const Text("Please Enter Password"));
    } else {
      await dbHelper.getLoginUser(uid, passwd).then((userData) {
        if (userData != null) {
          sharedPref(userData).whenComplete(() {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
                (Route<dynamic> route) => false);
          });
        } else {
          alertDialog(context, const Text("Error: User Not Found"));
        }
      }).catchError((error) {
        print(error);
        alertDialog(context, const Text("Error: Login Fail"));
      });
    }
  }

  Future sharedPref(User user) async {
    final SharedPreferences sp = await _pref;

    sp.setString("user_id", user.user_id!);
    sp.setString("user_name", user.user_name!);
    sp.setString("email", user.email!);
    sp.setString("password", user.password!);
  }
}
