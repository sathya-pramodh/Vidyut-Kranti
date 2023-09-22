import 'package:flutter/material.dart';

class LostAndFoundPage extends StatelessWidget {
  const LostAndFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Lost and Found'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blueGrey,
              child: Text(
                "Lost",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            title: Text('Phone'),
            subtitle: Text('KA 05 MQ 6123'),
            onTap: () {},
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blueGrey,
              child: Text(
                "Lost",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            title: Text('Money'),
            subtitle: Text('KA 05 MQ 6123'),
            onTap: () {},
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blueGrey,
              child: Text(
                "Lost",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            title: Text('Laptop'),
            subtitle: Text('KA 05 MQ 6123'),
            onTap: () {},
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blueGrey,
              child: Text(
                "Found",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
            title: Text('Money'),
            subtitle: Text('KA 05 MQ 6123'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
