import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:jiffy/jiffy.dart';
import 'package:to_do_app/models/todo.dart';
import 'package:to_do_app/view/todo/my_home_page.dart';

import '../../main.dart';
import 'modifying_todo.dart';

//page show more about task
class TodoDetails extends StatefulWidget {
  //parameter from previous screen
  final Todo list;
  final String id;
  const TodoDetails({ Key key, this.list, this.id }) : super(key: key);

  @override
  _TodoDetailsState createState() => _TodoDetailsState();
}

class _TodoDetailsState extends State<TodoDetails> {
  Box<Todo> todoBox;
  @override
    void initState() {
      super.initState();
      todoBox = Hive.box<Todo>(TODO_BOX);
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: (){
            Navigator.of(context).pop();
          }
        ),
        brightness: Brightness.dark,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                 width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Image.file(
                  File(widget.list.image),
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 80,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blueGrey,
                      ),
                      child: Center(child: Text(widget.list.priority, style: TextStyle(color: Colors.white)))
                    ),
                    Row(
                      children: [
                        Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.grey[300],
                         ),
                          child: IconButton(
                            onPressed: () {
                              //edit button
                              Navigator.push(
                                context,
                                  new MaterialPageRoute(
                                      builder: (context) => ModifiyingTodo(id: widget.id.toString(), list: widget.list)
                                )
                              );
                            }, 
                            icon: Icon(Icons.edit_sharp),
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.grey[300],
                          ),
                          child: IconButton(
                            onPressed: () {
                              //comfimation dialoge
                              showDialog(
                                context: context, 
                                builder: (BuildContext ctx) {
                                  return AlertDialog(
                                    title: Text("Please Comfirm"),
                                    content: Text("Are you sure you want to delete?"),
                                    actions: [
                                      TextButton(
                                        onPressed: (){
                                          Navigator.of(context).pop();
                                        }, 
                                        child: Text("No")
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          await todoBox.deleteAt(int.parse(widget.id));
                                          Navigator.of(context).pop();
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage()));
                                        }, 
                                        child: Text("Yes")
                                      )
                                    ],
                                  );
                                },
                              );
                            }, 
                            icon: Icon(Icons.clear_outlined),
                          ),
                        ),
                        SizedBox(width: 10),
                        //task status button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          side: BorderSide(color: Colors.black),
                         ),
                          onPressed: () async {
                            //changing status
                           Todo todo = Todo(image: widget.list.image, title: widget.list.title, description: widget.list.description, priority: widget.list.priority, createDate: widget.list.createDate, modifiedDate: widget.list.modifiedDate, status: widget.list.status == "done" ? null : "done");
                           await todoBox.putAt(int.parse(widget.id), todo);
                           //redirect page after saving
                           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage()));
                          }, 
                          child: 
                          //changing button depending to status
                          widget.list.status == "done" ?
                          Text("REVERSE",
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                          )
                          :Text("DONE",
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                          ),
                        ),   
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(widget.list.title,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text("Description",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(widget.list.description,
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        //date format using Jiffy plugin
                        Expanded(child: Text("Created "+Jiffy(widget.list.createDate).format('dd MMM yyyy'), style: TextStyle(color: Color(0XFF1C2834)))),
                        
                        Expanded(child: Text("Modified "+Jiffy(widget.list.modifiedDate).format('dd MMM yyyy'), style: TextStyle(color: Color(0XFF1C2834)))),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }
}