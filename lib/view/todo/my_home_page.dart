import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:jiffy/jiffy.dart';
import 'package:to_do_app/models/todo.dart';
import 'package:to_do_app/view/todo/creating_todo.dart';

import '../../main.dart';
import 'empty_list.dart';
import 'todo_details.dart';

//my homepage loaded after splash screen
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//variable which will hold data from box
var filteredBox;
class _MyHomePageState extends State<MyHomePage> {
  //variable i will use for hive box initialisation
  Box<Todo> todoBox;
  //return boolean value which will help to hide or show search textfield
  bool isSearching = false;
  @override
    void initState() {
      super.initState();
      //box initialisation
      todoBox = Hive.box<Todo>(TODO_BOX);
      //store data form box
      filteredBox = todoBox.values.toList();  
    }
     
  @override
  Widget build(BuildContext context) {
    //search by todo's title
    _filteredBox(value) {
      setState(() {
        filteredBox = todoBox.values
          .where(
              (todo) => todo.title.toLowerCase().contains(value.toLowerCase())
              )
          .toList();    
      });
    }
    // filter by todo's priority
    _priorityFilterBox(value) {
      setState(() {
        filteredBox = todoBox.values
          .where(
              (todo) => todo.priority.contains(value)
              )
          .toList();    
      });
    }
    //list of menu
    var listItem = ["Total Tasks", "Active Tasks", "Tasks Done"];
    // used for counting completed task 
    var count = todoBox.values.where((c) => c.status == "done").toList().length;
    //list of data in menu
    var total = [todoBox.length, todoBox.length - count, count];
    return Scaffold(
      body: SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        //Header of page area
                         child: AppBar(
                          automaticallyImplyLeading: false,
                          title: 
                          !isSearching ?
                          Container(
                            height: 30,
                            width: 30,
                            child: Image.asset(
                              "assets/IW_logo.png",
                              fit: BoxFit.cover
                            ),
                          )
                          //search textfield
                          :TextFormField(
                            onChanged: (value) {
                              // calling a function
                              _filteredBox(value);
                            },
                            style: TextStyle(color: Colors.white),
                            autofocus: true,
                            decoration: InputDecoration(
                              icon: Icon(Icons.search, color: Colors.white),
                              hintText: "Search...",
                              hintStyle: TextStyle(color: Colors.white)
                            ),
                          ),
                          // button area
                          actions: [
                            //search button when it is taped shows textfield
                            !isSearching ?
                            IconButton(
                              icon: Icon(Icons.search), 
                              onPressed: (){
                                setState(() {
                                  isSearching = true;                                
                                });
                              }
                            )
                            // cancel button when it is taped hide text field
                            :IconButton(
                              icon: Icon(Icons.cancel), 
                              onPressed: (){
                                setState(() {
                                   isSearching = false;   
                                   // when it is taped it rest returned list for search to original value
                                   filteredBox =  todoBox.values.toList();                            
                                });
                              }
                            ),
                            // popup menu area
                            !isSearching ?
                              Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                                child: PopupMenuButton(
                                  offset: const Offset(0, 20),
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                    child: Column(
                                      children: [
                                        Text("FILTER BY PRIORITY", style: TextStyle(fontWeight: FontWeight.bold),),
                                        Divider(),
                                      ],
                                    ),
                                    ),
                                    //Menu of priorty
                                    PopupMenuItem(
                                      child: InkWell(
                                        onTap: () async{
                                         _priorityFilterBox("LOW");
                                        },
                                        child: Text("Low priority"),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      child: InkWell(
                                        onTap: () async{
                                          _priorityFilterBox("MEDIUM");
                                        },
                                        child: Text("Medium priority"),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      child: InkWell(
                                        onTap: () async{
                                          _priorityFilterBox("HIGH");
                                        },
                                        child: Text("High priority"),
                                      ),
                                    ),
                                  ],
                                  child: Icon(
                                    Icons.filter_list,
                                  )
                                ),
                            )
                            :Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // body
                  Positioned(
                    top: 60,
                    left:30,
                    right: 30,
                    bottom: 0.0,
                    child: Container(
                      color: Color(0XFFFFFFFF),
                      height: MediaQuery.of(context).size.height,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Welcome", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                            todoBox.values.isEmpty ?
                            //this page displayed when no task created
                            WithEmptyList()
                            //this shows menu and it value
                            :GridView.count(
                              crossAxisCount: 3,
                              crossAxisSpacing: 2.0,
                              mainAxisSpacing: 2.0,
                              childAspectRatio: (110 / 80),
                              shrinkWrap: true,
                              children: List.generate(
                                3,
                                (index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                        color: Color(0XFFF4F5F6),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8.0, top: 20),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              total[index].toString(),
                                              style: TextStyle(
                                                  color: Color(0XFFC1CF16),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              listItem[index],
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      )
                                    ),
                                  );
                                },
                              ),
                            ),
                            todoBox.values.isEmpty ?
                            Container()
                            //this page appeared when there is atleast one task created
                            :Expanded(
                                child: ListView.separated(
                                  itemCount: filteredBox.length,
                                  itemBuilder: (context, index){
                                  final list = filteredBox[index];
                                  var count = index + 1;
                                       return Opacity(
                                         //check task status for setting opacity of listTile
                                        opacity: list.status == "done" ? 0.2 : 1,
                                        child: ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              minLeadingWidth: 10,
                                              leading: Icon(
                                                Icons.check_box_outlined,
                                                size: 30,
                                                color: Color(0XFF1C2834),
                                              ),
                                              title: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                    "$count " + list.title,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold, fontSize: 16),
                                                  )),
                                                  IconButton(
                                                    icon: Icon(Icons.more_vert),
                                                    onPressed: () {},
                                                  ),
                                                ],
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      width: 80,
                                                      height: 20,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        //check priority for setting color of background
                                                        color: 
                                                        list.priority == "MEDIUM" ?
                                                        Color(0XFF1C2834)
                                                        :list.priority == "LOW" ?
                                                        Color(0XFFF4F5F6)
                                                        :Colors.black,
                                                      ),
                                                      child: Center(
                                                          child: Text(list.priority,
                                                              style:
                                                              //check priority for setting color of text
                                                                  TextStyle(color:
                                                                  list.priority == "MEDIUM" ? 
                                                                  Colors.white
                                                                  :list.priority == "LOW" ?
                                                                  Color(0XFF1C2834)
                                                                  :Color(0XFFC1CF16),
                                                                  )))),
                                                  SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      // date format using Jiffy plugin
                                                      Expanded(
                                                          child: Text(
                                                              "Created " +
                                                                  Jiffy(list.createDate)
                                                                      .format('dd MMM yyyy'),
                                                              style: TextStyle(
                                                                  color: Color(0XFF1C2834)))),
                                                      Expanded(
                                                          child: Text(
                                                              "Modified " +
                                                                  Jiffy(list.modifiedDate)
                                                                      .format('dd MMM yyyy'),
                                                              style: TextStyle(
                                                                  color: Color(0XFF1C2834)))),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              onTap: () {
                                                //redirect to the page when you tap 
                                                Navigator.push(
                                                    context,
                                                    new MaterialPageRoute(
                                                        builder: (context) => TodoDetails(
                                                            id: index.toString(), list: list)));
                                              },
                                            ),
                                         
                                      );
                                    },
                                    separatorBuilder: (_, index) => Divider(),
                                    shrinkWrap: true,
                                )
                              ),
                          ],
                        ),
                      )
                    ),
                  )
                ],
              ),
      ),
      // redirect to the page of creating new task 
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0XFF1C2834),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CreatingToDo()));
        },
        tooltip: 'To-do',
        child: Icon(Icons.add),
      ),
    );
  }
}