import 'package:flutter/material.dart';
import 'package:multilevel_drawer/multilevel_drawer.dart';
import 'package:vidyutkranti/pages/complaint.dart';

import 'package:vidyutkranti/pages/login_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

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
              child: Text(
                "BusTrack",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(),
          ],
        ),
      ),
      children: [
        MLMenuItem(
          content: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 15,
                ),
                const Icon(
                  Icons.account_circle_outlined,
                  color: Color(0xFF394867),
                  size: 25,
                ),
                const SizedBox(
                  width: 20,
                ),
                const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          onClick: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Login()));
          },
        ),
        MLMenuItem(
          content: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 15),
                const Text(
                  "Report Complaint",
                  style: TextStyle(
                    fontSize: 20,
                  ),
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
                const SizedBox(width: 15),
                const Text(""),
              ],
            ),
          ),
          onClick: () {},
        )
      ],
    );
  }
}
