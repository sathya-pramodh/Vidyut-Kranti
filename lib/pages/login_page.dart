import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vidyutkranti/pages/home_page.dart';
import 'package:vidyutkranti/pages/register_page.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   home: LoginPage(),
    // );
    return LoginPage();
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF394867),
      body: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return LoginScreen();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? _error = "";
  Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      setState(() => _error = e.message);
    }

    return user;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailcontroller = TextEditingController();
    TextEditingController _passwordcontroller = TextEditingController();
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Icon(
              Icons.bus_alert,
              size: 60,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Center(
            child: Text(
              "BusTrack",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            padding: EdgeInsets.all(22),
            margin: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              children: [
                TextField(
                  controller: _emailcontroller,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "User Email",
                    prefixIcon: Icon(
                      Icons.mail,
                      color: Colors.black,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.blueGrey,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  cursorColor: Color.fromARGB(255, 44, 63, 105),
                ),
                SizedBox(
                  height: 26.0,
                ),
                TextField(
                  controller: _passwordcontroller,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "User Password",
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.black,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.blueGrey,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  cursorColor: Color.fromARGB(255, 44, 63, 105),
                ),
                SizedBox(height: 8),
                Text(_error!),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: RawMaterialButton(
                        elevation: 2,
                        splashColor: Colors.blueAccent,
                        fillColor: Color.fromARGB(255, 44, 63, 105),
                        onPressed: () async {
                          User? user = await loginUsingEmailPassword(
                              email: _emailcontroller.text,
                              password: _passwordcontroller.text,
                              context: context);
                          if (user != null) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HomePage()));
                          }
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: RawMaterialButton(
                        elevation: 2,
                        splashColor: Colors.blueAccent,
                        fillColor: Color.fromARGB(255, 44, 63, 105),
                        onPressed: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Register()));
                        },
                        child: Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
