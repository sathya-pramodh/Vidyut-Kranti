import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;
  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 5, right: 5),
              ),
              const SizedBox(height: 10),
              const Text(
                "User Profile",
                style: TextStyle(
                  fontFamily: 'LuckiestGuy',
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 120,
                height: 120,
                child: Image.asset("images/profile_placeholder.png"),
              ),
              const SizedBox(height: 20),
              Text('${user?.email}',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 40),
              const Divider(color: Colors.transparent),
            ],
          ),
        ),
      ),
    ));
  }
}
