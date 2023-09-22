import 'package:flutter/material.dart';
import 'package:vidyutkranti/components/search_card.dart';

class ComplaintPage extends StatelessWidget {
  const ComplaintPage({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Raise Complaint';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(appTitle, style: TextStyle(color: Colors.black)),
          centerTitle: true,
        ),
        body: const ComplaintForm(),
      ),
    );
  }
}

//Form Widget
class ComplaintForm extends StatefulWidget {
  const ComplaintForm({super.key});

  @override
  State<ComplaintForm> createState() => _ComplaintFormState();
}

class _ComplaintFormState extends State<ComplaintForm> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
              hintText: "Enter Bus Route Number",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your complaint';
              }
              return null;
            },
          ),
          const SizedBox(height: 40),
          Text("Enter Type of Complaint",
              style: TextStyle(
                fontSize: 17,
              )),
          Row(
            children: [
              IconButton(
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => Dialog(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SearchCard(
                            searchTitle: 'Enter Type of Complaint',
                            inputHintText: 'Select',
                            dropdownController: () {},
                            optionList: [
                              'Negligent Driving',
                              'Rude Behavior',
                              'Extra Charging',
                              'Item Lost',
                              'Other',
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Submit'),
                        ),
                      ],
                    ),
                  ),
                ),
                icon: Icon(Icons.bus_alert_rounded, size: 40),
              ),
            ],
          ),
          const SizedBox(height: 30),
          TextFormField(
            decoration: InputDecoration(
              hintText: "Enter your Complaint",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your complaint';
              }
              return null;
            },
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')));
                  }
                },
                child: const Text('Submit'),
              )),
        ],
      ),
    );
  }
}
