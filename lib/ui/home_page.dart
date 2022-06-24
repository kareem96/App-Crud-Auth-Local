import 'package:app_crud_auth_local/ui/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/helper.dart';
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

  late DbHelper dbHelper;
  final _conUserId = TextEditingController();
  final _conDelUserId = TextEditingController();
  final _conUserName = TextEditingController();
  final _conEmail = TextEditingController();
  final _conPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserData();

    dbHelper = DbHelper();
  }

  Future<void> getUserData() async {
    final SharedPreferences sp = await _pref;

    setState(() {
      _conUserId.text = sp.getString("user_id")!;
      _conDelUserId.text = sp.getString("user_id")!;
      _conUserName.text = sp.getString("user_name")!;
      _conEmail.text = sp.getString("email")!;
      _conPassword.text = sp.getString("password")!;
    });
  }

  update() async {
    String uid = _conUserId.text;
    String uname = _conUserName.text;
    String email = _conEmail.text;
    String passwd = _conPassword.text;

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      User user = User(uid, uname, email, passwd);
      await dbHelper.updateUser(user).then((value) {
        if (value == 1) {
          alertDialog(context, const Text("Successful Update"));
          updateSP(user, true).whenComplete(() {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                    (Route<dynamic> route) => false);
          });
        } else {
          alertDialog(context, const Text("Error Update"));
        }
      }).catchError((error) {
        print(error);
        alertDialog(context, const Text("Error"));
      });
    }
  }

  delete() async {
    String delUserID = _conDelUserId.text;

    await dbHelper.deleteUser(delUserID).then((value) {
      if (value == 1) {
        alertDialog(context, const Text("Successful Delete"));
        updateSP(null, false).whenComplete(() {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
                  (Route<dynamic> route) => false);
        });
      }
    });
  }

  Future updateSP(User? user, bool add) async {
    final SharedPreferences sp = await _pref;

    if (add) {
      sp.setString("user_name", user!.user_name!);
      sp.setString("email", user.email!);
      sp.setString("password", user.password!);
    } else {
      sp.remove('user_id');
      sp.remove('user_name');
      sp.remove('email');
      sp.remove('password');
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
                      controller: _conUserId,
                      isEnable: false,
                      icon: Icons.person,
                      hintName: 'User ID'),
                  const SizedBox(height: 10.0),
                  TextFormEdit(
                      controller: _conUserName,
                      icon: Icons.person_outline,
                      inputType: TextInputType.name,
                      hintName: 'User Name'),
                  const SizedBox(height: 10.0),
                  TextFormEdit(
                      controller: _conEmail,
                      icon: Icons.email,
                      inputType: TextInputType.emailAddress,
                      hintName: 'Email'),
                  const SizedBox(height: 10.0),
                  TextFormEdit(
                    controller: _conPassword,
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
                      controller: _conDelUserId,
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
