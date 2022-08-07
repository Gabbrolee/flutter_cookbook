import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cookbook/shared/firebase_authentication.dart';


 FirebaseAuthentication? auth;
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? userId = '';
  String _message = "";
  bool _isLogin = false;
  final TextEditingController txtUserName = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();


  @override
  void initState() {
    Firebase.initializeApp().whenComplete((){
      auth = FirebaseAuthentication();
      setState(() {});
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Screen'),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async{
                auth!.logout().then((value){
                  setState(() {
                    if(value){
                      _message = "  $userId logout";
                    } else{
                      _message = "Unable to logout";
                    }
                  });
                });
              },
          )
        ],
      ),
      body: Container(
        child: ListView(
          children: [
            userInput(),
            userPassword(),
            btnMain(),
            txtMessage(),
          ],
        ),
      ),
    );
  }

  Widget userInput(){
    return Padding(
        padding: EdgeInsets.only(top: 128),
        child: TextFormField(
          controller: txtUserName,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'User Name',
            icon: Icon(Icons.verified_user),
          ),
          validator: (text) => text!.isEmpty ? "User name is required" : "",
        ),
    );
  }

  Widget userPassword(){
    return Padding(
      padding: EdgeInsets.only(top: 24, right: 20, left: 20),
      child: TextFormField(
        controller: txtPassword,
        keyboardType: TextInputType.emailAddress,
        obscureText: true,
        decoration: const InputDecoration(
          hintText: 'User Password',
          icon: Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Icon(Icons.enhanced_encryption, color: Colors.red, size: 25.0,),
          )
        ),
        validator: (text) => text!.isEmpty ? "User password is required" : "",
      ),
    );
  }

  Widget btnMain(){
    String btnText = !_isLogin ? "Login" : "Sign Up";
    return  Padding(
      padding: EdgeInsets.only(top: 128, left: 20, right: 20),
      child: Container(
        height: 60,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(color: Colors.red)
            ))
          ),
          child: Text(
            btnText,
            style: TextStyle(
              fontSize: 18.0,
              color: Theme.of(context).cardTheme.color
            ),
          ),
          onPressed: (){

            if(!_isLogin){
              auth!.login(txtUserName.text, txtPassword.text).then((value){
                if(value == null){
                  userId = txtUserName.text;
                  setState(() {
                    _message = "User $userId successfully sign in";
                  });
                }else {
                  setState(() {
                    _message = "Login Error";
                  });
                }
              });
            }else {
              auth?.createUser(txtUserName.text,  txtPassword.text).then((value){
                if(value != null){
                  _message = "Registration Error";
                }else{
                  userId = txtUserName.text;
                  setState(() {
                    _message = "User $userId successfully sign up";
                  });
                }
              });
            }
          },
        ),
      ),
    );
  }

  Widget btnSecondary(){
    String btnText = !_isLogin ? "SignUp" : "Login";
    return TextButton(
        child: Text(btnText),
        onPressed: (){
          setState(() {
            _isLogin = !_isLogin;
          });
        },
    );
  }

  Widget txtMessage(){
    return Text(
      _message,
      style: TextStyle(
        fontSize: 17,
        color: Theme.of(context).primaryColorDark,
        fontWeight: FontWeight.bold
      ),
    );
  }
}
