import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

const String title = 'SignUp by Firebase';
const Color kAccentColor = Color(0xFFFE7C64);
const Color kBackgroundColor = Color(0xFF19283D);
const Color kTextColorPrimary = Color(0xFFECEFF1);
const Color kTextColorSecondary = Color(0xFFB0BEC5);
const Color kButtonColorPrimary = Color(0xFFECEFF1);
const Color kButtonTextColorPrimary = Color(0xFF455A64);
const Color kIconColor = Color(0xFF455A64);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData.dark(),
      routes: {
        '/': (_) => MainPage(),
      },
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: _SignInForm(),
        ),
      ),
    );
  }
}

class _CustomeTextField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  const _CustomeTextField({
    Key key,
    @required this.labelText,
    @required this.hintText,
    @required this.obscureText,
    @required this.controller,
  }) : super(key: key);

  @override
  __CustomeTextFieldState createState() => __CustomeTextFieldState();
}

class __CustomeTextFieldState extends State<_CustomeTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        hintStyle: TextStyle(color: kTextColorSecondary),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: kAccentColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: kTextColorSecondary,
          ),
        ),
      ),
      obscureText: widget.obscureText,
    );
  }
}

class _SignInForm extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String _email = "";
    String _password = "";
    return Column(
      children: [
        _CustomeTextField(
          labelText: 'Email',
          hintText: 'your email address goes here',
          obscureText: false,
          controller: _emailController,
        ),
        SizedBox(height: 48),
        _CustomeTextField(
          labelText: 'Password',
          hintText: 'your password goes here',
          obscureText: true,
          controller: _passwordController,
        ),
        SizedBox(height: 4),
        Text(
          'Forgot Password?',
          style: Theme.of(context)
              .textTheme
              .bodyText2
              .copyWith(color: kTextColorSecondary),
        ),
        SizedBox(height: 48),
        Container(
          width: double.infinity,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: kButtonColorPrimary,
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              'Sign up',
              style: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(color: kButtonTextColorPrimary, fontSize: 18),
            ),
            onPressed: () async {
              _email = _emailController.text;
              _password = _passwordController.text;

              // SignUp
              try {
                UserCredential userCredential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: _email, password: _password);
                print(userCredential);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  print('The Password provides is too weak');
                } else if (e.code == 'emami-already-in-use') {
                  print('The account already exists for that email.');
                }
              } catch (e) {
                print(e);
              }

              // SingIn

              // try {
              //   UserCredential userCredential = await FirebaseAuth.instance
              //       .signInWithEmailAndPassword(
              //           email: 'ayabin.jp@gmail.com', password: 'Password');
              //   print(userCredential.user.email);
              // } on FirebaseAuthException catch (e) {
              //   if (e.code == 'user-not-found') {
              //     print('No User for that email.');
              //   } else if (e.code == 'wrong-password') {
              //     print('Wrong password provided for that user.');
              //   }
              // }
            },
          ),
        ),
      ],
    );
  }
}
