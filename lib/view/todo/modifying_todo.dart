import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:images_picker/images_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:to_do_app/models/todo.dart';

import '../../main.dart';
import 'my_home_page.dart';

//Page used for modification
class ModifiyingTodo extends StatefulWidget {
  //used for validating form
  final Todo list;
  final String id;
  const ModifiyingTodo({ Key key, this.list, this.id }) : super(key: key);

  @override
  _ModifiyingTodoState createState() => _ModifiyingTodoState();
}

class _ModifiyingTodoState extends State<ModifiyingTodo> {
  GlobalKey<FormState> _formkey = new GlobalKey();
  bool visible = false;
  File file;
  String uploadedImage;
  final image = TextEditingController();
  final title = TextEditingController();
  final description = TextEditingController();
  final priority = TextEditingController();
  
  Box<Todo> todoBox;
  @override
    void initState() {
      super.initState();
      todoBox = Hive.box<Todo>(TODO_BOX);
    }
    //used for picking the image from gallery
    Future pickImage() async{
      //directory
      final dir = await getTemporaryDirectory();
      //select image from gallery
      List<Media> res = await ImagesPicker.pick(
        count: 1,
        pickType: PickType.image,
      );
      setState(() async{
        //if file selected save image to directory then return path
        if(res[0].path != null)
        await ImagesPicker.saveImageToAlbum(File(res[0].path), albumName: dir.path);
        uploadedImage = res[0].path;
      });
    }
  @override
  Widget build(BuildContext context) {
    //String dropdownValuepriority = widget.list.priority == "" ? "CHOOSE" :widget.list.priority;
   String dropdownValuepriority = widget.list.priority;
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
        child: Padding(
          padding: const EdgeInsets.all(12.0),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Form(
                  key: this._formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Modify Task",
                        style:TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Add Image",
                        style:TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: image,
                        showCursor: true,
                        readOnly: true,
                        minLines: 3,
                        maxLines: 5,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          hintText: "Tap to add Image",
                          border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(5),
                           borderSide: BorderSide.none
                          ),
                          contentPadding: EdgeInsets.only(left: 80.0, top:50.0),
                        ),
                        onTap: () {
                          // calling function
                          pickImage();  
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Title",
                        style:TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: title..text = widget.list.title,
                        validator: (String value) {
                          if (value.isEmpty)
                            return "Title is required";
                            return null;
                        },
                        maxLength: 140,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          hintText: "Task title(140 Characters)",
                          border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(5),
                           borderSide: BorderSide.none
                          ),
                          contentPadding: EdgeInsets.only(left: 10.0),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Description",
                        style:TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: description..text = widget.list.description,
                        validator: (String value) {
                          if (value.isEmpty)
                            return "Description is required";
                            return null;
                        },
                        minLines: 3,
                        maxLines: 5,
                        maxLength: 240,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          hintText: "240 Character",
                          border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(5),
                           borderSide: BorderSide.none
                          ),
                          contentPadding: EdgeInsets.only(left: 10.0, top: 30.0),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Priority",
                        style:TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownButtonFormField<String>(
                        value: dropdownValuepriority,
                        onChanged: (String newValuepriority) {
                          setState(() {
                            dropdownValuepriority = newValuepriority;
                            priority.text = newValuepriority;
                          });
                        },
                        items: <String>[
                          'LOW', 
                          'MEDIUM',
                          'HIGH'
                        ].map<DropdownMenuItem<String>>(
                            (String valuepriority) {
                          return DropdownMenuItem<String>(
                            value: valuepriority,
                            child: Text(valuepriority),
                          );
                        }).toList(),
                        validator: (String item) {
                            if (item == null || item == "")
                              return "Priority is required";
                            else if (item == "CHOOSE")
                              return "Priority is required";
                            else
                              return null;
                          },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide.none,
                            ),
                             contentPadding: EdgeInsets.only(left: 10.0),
                        ),
                      ),
                      
                      SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                        ),
                        onPressed: () async {
                          //check form validation
                          if (_formkey.currentState.validate()) {
                          _formkey.currentState.save(); 
                          //to update data in hive
                          Todo todo = Todo(image: "$uploadedImage" == "null" ? widget.list.image : "$uploadedImage", title: title.text, description: description.text, priority: priority.text == "" ? widget.list.priority :priority.text, createDate: widget.list.createDate, modifiedDate: DateTime.now(), status: widget.list.status);
                           await todoBox.putAt(int.parse(widget.id), todo);
                           //cleaning text field after modification
                           title.clear();
                           description.clear();
                           priority.clear();
                           image.clear();
                           //show message after modification
                           Fluttertoast.showToast(
                              msg: "Change Saved",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 5,
                              backgroundColor: Colors.red[300],
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage()));
                        }},
                        child: Text(
                          "SAVE CHANGE",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}
