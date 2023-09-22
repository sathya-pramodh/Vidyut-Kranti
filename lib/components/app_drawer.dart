import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multilevel_drawer/multilevel_drawer.dart';
import '../pages/complaint.dart';
import '../pages/lost_and_found_page.dart';
import 'package:vidyutkranti/pages/login_page.dart';

class AppDrawer extends StatefulWidget {
  AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => AppDrawerState();
}

class AppDrawerState extends State<AppDrawer> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return MultiLevelDrawer(
      divisionColor: Colors.grey,
      rippleColor: Color(0xFF9BA4B5),
      backgroundColor: Color.fromARGB(255, 213, 223, 240),
      header: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            SafeArea(
              child: GestureDetector(
                onTap: () {
                  if (user == null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  }
                },
                child: Column(children: [
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    foregroundImage:
                        AssetImage('images/profile_placeholder.png'),
                  ),
                  const SizedBox(height: 15),
                  (user == null)
                      ? const Text(
                          "Guest",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        )
                      : Text(
                          user!.email!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ]),
              ),
            ),
          ],
        ),
      ),
      // itemHeight: 70,
      children: [
        MLMenuItem(
          content: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 10,
                ),
                const Icon(
                  Icons.report,
                  color: Color(0xFF394867),
                  size: 25,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "Report \nComplaint",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  overflow: TextOverflow.fade,
                ),
              ],
            ),
          ),
          onClick: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => ComplaintPage()));
          },
        ),
        MLMenuItem(
          content: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 10,
                ),
                const Icon(
                  Icons.search_off_rounded,
                  color: Color(0xFF394867),
                  size: 25,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "Lost and Found",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  overflow: TextOverflow.fade,
                ),
              ],
            ),
          ),
          onClick: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => LostAndFoundPage()));
          },
        ),
        MLMenuItem(
          content: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 10,
                ),
                const Icon(
                  Icons.logout,
                  color: Color(0xFF394867),
                  size: 25,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "Sign Out",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  overflow: TextOverflow.fade,
                ),
              ],
            ),
          ),
          onClick: () async {
            await FirebaseAuth.instance.signOut();
            setState(() => user = null);
          },
        ),
        MLMenuItem(
          content: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [],
            ),
          ),
          onClick: () {},
        )
      ],
    );
  }
}
