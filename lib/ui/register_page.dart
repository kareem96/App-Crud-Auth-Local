import 'package:app_crud_auth_local/common/text_form_field.dart';
import 'package:app_crud_auth_local/ui/login_page.dart';
import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../model/user.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = new GlobalKey<FormState>();

  final _controllerUserId = TextEditingController();
  final _controllerUserName = TextEditingController();
  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();
  final _controllerConfirmPassword = TextEditingController();
  var dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
  }

  signUp() async {
    String uid = _controllerUserId.text;
    String username = _controllerUserName.text;
    String email = _controllerEmail.text;
    String password = _controllerPassword.text;
    String confirmPassword = _controllerConfirmPassword.text;

    if (_formKey.currentState!.validate()) {
      if (password != confirmPassword) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Password No Match")));
      } else {
        _formKey.currentState?.save();

        User user = User(uid, username, email, password);
        await dbHelper.saveData(user).then((userData) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Successfully Saved")));

          Navigator.push(
              context, MaterialPageRoute(builder: (_) => LoginPage()));
        }).catchError((error) {
          print(error);
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Error: Login Fail")));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD LOCAL'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "REGISTER",
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
                TextFormEdit(
                  controller: _controllerConfirmPassword,
                  icon: Icons.lock,
                  hintName: 'Confirm Password',
                  isObscureText: true,
                ),
                Container(
                  margin: const EdgeInsets.all(30.0),
                  width: double.infinity,
                  child: ElevatedButton(
                    child: const Text(
                      'Signup',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: signUp,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Does you have account? '),
                    ElevatedButton(
                      child: const Text('Sign In'),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => LoginPage()),
                            (Route<dynamic> route) => false);
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
