import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:to_do_app/models/todo.dart';
import 'package:to_do_app/view/todo/creating_todo.dart';

import '../../main.dart';

//Page showed when no task
class WithEmptyList extends StatefulWidget {
  WithEmptyList({Key key}) : super(key: key);

  @override
  _WithEmptyListState createState() => _WithEmptyListState();
}

class _WithEmptyListState extends State<WithEmptyList> {
  Box<Todo> todoBox;
  @override
  void initState() {
    super.initState();
    todoBox = Hive.box<Todo>(TODO_BOX);
  }

  @override
  Widget build(BuildContext context) {
    //List of menu
    var listItem = [
      "Total Tasks",
      "Active Tasks",
      "Tasks Done",
      "Active High Priority"
    ];
    return Expanded(
      child: Column(
        children: [
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: (30 / 20),
            shrinkWrap: true,
            children: List.generate(
              4,
              (index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        color: Color(0XFFF4F5F6),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, top: 30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "0",
                              style: TextStyle(
                                  color: Color(0XFFC1CF16),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            ),
                            Text(
                              listItem[index],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Center(
              child: Column(
                children: [
                  Text("NOTHING HERE",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("Just like your crush's replies",
                      style: TextStyle(color: Colors.blueGrey)),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                    ),
                    onPressed: () {
                      //redirect to the page of creating a new task
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreatingToDo()));
                    },
                    child: Text(
                      "START WITH A NEW TASK",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
