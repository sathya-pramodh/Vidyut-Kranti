import 'package:flutter/material.dart';


class LostAndFoundPage extends StatelessWidget {
  const LostAndFoundPage({super.key});

  // List<LostAndFoundCard> itemList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        child: Icon(
          Icons.add,
        ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => GestureDetector(
              onTap: () {},
              child: MyForm(),
              behavior: HitTestBehavior.opaque,
            ),
          );
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Lost and Found'),
      ),
      body: ListView(
        children: [
          LostAndFoundCard(
            isLost: true,
            busNumber: 'KA 05 MQ 6123',
            itemName: 'Mobile Phone',
            contactDetails: '+91-8102345678',
          ),
          LostAndFoundCard(
            isLost: true,
            busNumber: 'KA 05 MQ 6123',
            itemName: 'Laptop',
            contactDetails: '+91-8102345678',
          ),
          LostAndFoundCard(
            isLost: false,
            busNumber: 'KA 05 MQ 6123',
            itemName: 'Money',
            contactDetails: '+91-8102345678',
          ),
        ],
      ),
    );
  }
}

class LostAndFoundCard extends StatelessWidget {
  const LostAndFoundCard({
    super.key,
    required this.itemName,
    required this.busNumber,
    required this.isLost,
    required this.contactDetails,
  });

  final String itemName;
  final String busNumber;
  final String contactDetails;
  final bool isLost;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blueGrey,
        child: Text(
          isLost ? 'Lost' : 'Found',
          style: TextStyle(
            color: Colors.white,
            fontSize: isLost ? 16 : 12,
          ),
        ),
      ),
      title: Text(itemName),
      subtitle: Text(busNumber),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            child: Container(
              height: 150,
              padding: EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // GridTile(child: ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      isLost ? 'Lost' : 'Found',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Text('Item: ' + itemName),
                  Text("Bus Number: " + busNumber),
                  Text("Contact Details: " + contactDetails),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String itemName = "";
  String busNumber = "";
  String contactDetails = "";
  bool isLost = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 350,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Item Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter item name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    itemName = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Bus Number'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter bus number';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    busNumber = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contact Details'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter contact details';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    contactDetails = value;
                  });
                },
              ),
              Row(
                children: <Widget>[
                  Text('Is Lost?'),
                  Checkbox(
                    value: isLost,
                    onChanged: (value) {
                      setState(() {
                        isLost = value!;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              MaterialButton(
                color: Colors.blueGrey,
                textColor: Colors.white,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Do something with the form data, e.g., submit to a server
                    
                    print('Item Name: $itemName');
                    print('Bus Number: $busNumber');
                    print('Contact Details: $contactDetails');
                    print('Is Lost: $isLost');
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
