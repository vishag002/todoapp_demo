import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final myController = TextEditingController();

  // Hive box
  var box = Hive.box('myBox');
  // Keys list
  List myKeysList = [];

  @override
  void initState() {
    super.initState();
    myKeysList = box.keys.toList();
  }

  void saveButton() {
    box.add({"mytext": myController.text.trim(), "isCompleted": false});
    myKeysList = box.keys.toList();
    setState(() {});
    Navigator.pop(context);
    myController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ToDo App"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: myKeysList.length,
        itemBuilder: (context, index) {
          var item = box.get(myKeysList[index]);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              tileColor: Colors.lightBlue[200],
              title: Text(
                item['mytext'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              trailing: Checkbox(
                value: item["isCompleted"] ?? false,
                onChanged: (bool? value) {
                  box.put(myKeysList[index], {
                    "mytext": item["mytext"],
                    "isCompleted": value ?? false,
                  });
                  myKeysList = box.keys.toList();
                  setState(() {});
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.transparent,
                actions: [
                  Container(
                    height: 200,
                    width: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.blue,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: TextFormField(
                            controller: myController,
                            decoration: InputDecoration(
                              hintText: "Enter Text",
                              hintStyle: TextStyle(color: Colors.black38),
                              floatingLabelStyle:
                                  TextStyle(color: Colors.white),
                              border: OutlineInputBorder(),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            style: TextStyle(color: Colors.black),
                            keyboardType: TextInputType.multiline,
                            cursorColor: Colors.black,
                          ),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.white),
                          ),
                          onPressed: saveButton,
                          child: Text(
                            "Save",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(
          Icons.add,
          size: 35,
        ),
      ),
    );
  }
}
