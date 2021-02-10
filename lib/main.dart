import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const Color kAccentColor = Color(0xFFFE7C64);
const Color kBackgroundColor = Color(0xFF19283D);
const Color kTextColorPrimary = Color(0xFFECEFF1);
const Color kTextColorSecondary = Color(0xFFB0BEC5);
const Color kButtonColorPrimary = Color(0xFFECEFF1);
const Color kButtonTextColorPrimary = Color(0xFF455A64);
const Color kIconColor = Color(0xFF455A64);

const String title = "Signup001 by Firebase";

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
        '/': (_) => _LoginForm(),
        '/signup': (_) => _SignupForm(),
      },
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  const _CustomTextField({
    Key key,
    @required this.labelText,
    @required this.hintText,
    @required this.obscureText,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
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
      obscureText: obscureText,
      onTap: () {},
    );
  }
}

class _LoginForm extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              _CustomTextField(
                labelText: 'Email',
                hintText: 'your email address goes here',
                obscureText: false,
                controller: _emailController,
              ),
              SizedBox(height: 48),
              _CustomTextField(
                labelText: 'Password',
                hintText: 'your password goes here',
                obscureText: true,
                controller: _passwordController,
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Forgot Password ?',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: kTextColorSecondary),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/signup');
                },
                child: Text('Sign up'),
              ),
              SizedBox(height: 48),
              Container(
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    AuthService as = AuthService(
                        email: _emailController.text,
                        password: _passwordController.text);
                    Future uc = as.signInWithEmailAndPassword();
                    print(uc);
                  },
                  child: Text(
                    'Login',
                    style: Theme.of(context).textTheme.button.copyWith(
                          color: kButtonTextColorPrimary,
                          fontSize: 18,
                        ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: kButtonColorPrimary,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignupForm extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SignUp'),
      ),
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              _CustomTextField(
                labelText: 'Email',
                hintText: 'your email address goes here',
                obscureText: false,
                controller: _emailController,
              ),
              SizedBox(height: 48),
              _CustomTextField(
                labelText: 'Password',
                hintText: 'your password goes here',
                obscureText: true,
                controller: _passwordController,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Login'),
              ),
              SizedBox(height: 48),
              Container(
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    AuthService as = AuthService(
                        email: _emailController.text,
                        password: _passwordController.text);
                    Future uc = as.createUserWithEmailAndPassword();
                    print(uc);
                  },
                  child: Text(
                    'Sign up',
                    style: Theme.of(context).textTheme.button.copyWith(
                          color: kButtonTextColorPrimary,
                          fontSize: 18,
                        ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: kButtonColorPrimary,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String email;
  final String password;
  AuthService({this.email, this.password});

  Future signInWithEmailAndPassword() async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return userCredential;
  }

  Future createUserWithEmailAndPassword() async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return userCredential;
  }

  Future sendPasswordResetEmail() async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return 'success';
    } catch (e) {
      return e.code;
    }
  }
}
