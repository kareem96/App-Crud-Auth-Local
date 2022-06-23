import 'package:app_crud_auth_local/ui/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/text_form_field.dart';
import '../database/database_helper.dart';
import '../model/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  DbHelper? dbHelper;
  final _controllerDeleteUserId = TextEditingController();
  final _controllerUserId = TextEditingController();
  final _controllerUserName = TextEditingController();
  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
  }

  Future<void> getUser() async{
    final SharedPreferences sharedPreferences = await _pref;
    setState(() {
      _controllerDeleteUserId.text = sharedPreferences.getString("userId") ?? "";
      _controllerUserId.text = sharedPreferences.getString("userId") ?? "";
      _controllerUserName.text = sharedPreferences.getString("userName") ?? "";
      _controllerEmail.text = sharedPreferences.getString("email") ?? "";
      _controllerPassword.text = sharedPreferences.getString("password") ?? "";

    });
  }
  update() async {
    String uid = _controllerUserId.text;
    String username = _controllerUserName.text;
    String email = _controllerEmail.text;
    String password = _controllerPassword.text;

    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      User user = User(uid, username, email, password);
      await dbHelper?.updateUser(user).then((value) {
        if (value == 1) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully Updated")));

          updateSharedPref(user, true).whenComplete(() {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
                    (Route<dynamic> route) => false);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error Update")));

        }
      }).catchError((error) {
        print(error);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error")));
      });
    }
  }

  delete() async {
    String delUserID = _controllerUserId.text;

    await dbHelper?.deleteUser(delUserID).then((value) {
      if (value == 1) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully Deleted")));
        updateSharedPref(null, false).whenComplete(() {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()), (Route<dynamic> route) => false);
        });
      }
    });
  }

  Future updateSharedPref(User? user, bool add) async {
    final SharedPreferences sharedPreferences = await _pref;

    if (add) {
      sharedPreferences.setString("userName", user?.userName ?? "");
      sharedPreferences.setString("email", user?.email ?? "");
      sharedPreferences.setString("password", user?.password ?? "");
    } else {
      sharedPreferences.remove('userId');
      sharedPreferences.remove('userName');
      sharedPreferences.remove('email');
      sharedPreferences.remove('password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: const EdgeInsets.only(top: 20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Update
                  TextFormEdit(
                      controller: _controllerUserId,
                      isEnable: false,
                      icon: Icons.person,
                      hintName: 'User ID'),
                  const SizedBox(height: 10.0),
                  TextFormEdit(
                      controller: _controllerUserName,
                      icon: Icons.person_outline,
                      inputType: TextInputType.name,
                      hintName: 'User Name'),
                  const SizedBox(height: 10.0),
                  TextFormEdit(
                      controller: _controllerEmail,
                      icon: Icons.email,
                      inputType: TextInputType.emailAddress,
                      hintName: 'Email'),
                  const SizedBox(height: 10.0),
                  TextFormEdit(
                    controller: _controllerPassword,
                    icon: Icons.lock,
                    hintName: 'Password',
                    isObscureText: true,
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    margin: const EdgeInsets.all(30.0),
                    width: double.infinity,
                    child: ElevatedButton(
                      child: const Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: update,
                    ),
                  ),
                  //Delete
                  TextFormEdit(
                      controller: _controllerDeleteUserId,
                      isEnable: false,
                      icon: Icons.person,
                      hintName: 'User ID'),
                  const SizedBox(height: 10.0),
                  Container(
                    margin: const EdgeInsets.all(30.0),
                    width: double.infinity,
                    child: ElevatedButton(
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: delete,
                    ),
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
