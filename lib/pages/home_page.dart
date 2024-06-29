import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/methods/auth_methods.dart';
import 'package:todo/pages/login_screens.dart';
import 'package:todo/utility/dialog_box.dart';
import 'package:todo/utility/todo_tile.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() {
    return _HomepageState();
  }
}

class _HomepageState extends State<HomePage> {
  final _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String currentuser_uid = AuthMethods().getcurrentuser();

  // List todolist = [
  //   ['be productive', false],
  //   ['do exercise', false]
  // ];
  void tapcheckbox(String uid) async {
    // setState(() {
    //   todolist[index][1] = !todolist[index][1];
    // });
    var currentdata;
    await _firestore.collection('users')
        .doc(currentuser_uid).collection('Todo List').doc(uid).get().then(
      (value) {
        currentdata = value.data()!;
      },
    );
    var currentbool = !currentdata['task status'];
    _firestore
        .collection('users')
        .doc(currentuser_uid)
        .collection('Todo List')
        .doc(uid)
        .update(
      {'task status': currentbool},
    );
  }
  void signout(BuildContext context) async {
      final auth = AuthMethods();
      try {
        await auth.signout();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      } catch (e) {
        print(
          e.toString(),
        );
      }
    }

  void oncancelling() {
    Navigator.of(context).pop();
  }

  void newitem() async {
    // setState(() {
    //   todolist.add([_controller.text, false]);
    //   _controller.clear();
    // });
    var doc_id = const Uuid().v4();
    await _firestore
        .collection('users')
        .doc(currentuser_uid)
        .collection('Todo List')
        .doc(doc_id)
        .set(
      {
        'task name': _controller.text,
        'task status': false,
        'todo_id': doc_id,
        'user_uid': currentuser_uid
      },
    );
    Navigator.of(context).pop();
  }

  void additem() {
    showDialog(
      context: context,
      builder: (context) => DialogBox(
        textcontroller: _controller,
        onCancel: oncancelling,
        onSave: newitem,
      ),
    );
    _controller.clear();
  }

  void remove(String uid) async {
    await _firestore
        .collection('users')
        .doc(currentuser_uid)
        .collection('Todo List')
        .doc(uid)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 92, 133, 245),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 118, 149, 241),
        title: const Center(
          child: Text('TODO'),
        ),
        actions: [
          IconButton(
            onPressed:()=> signout(context),
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: additem,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
          stream: _firestore
              .collection('users')
              .doc(currentuser_uid)
              .collection('Todo List')
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('something went wrong!'),
              );
            }
            if (snapshot.connectionState==ConnectionState.waiting) {
              return const Center(
                child: Text('something went wrong!'),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return TodoTile(
                  changed: (value) {
                    return tapcheckbox(
                      snapshot.data!.docs[index].data()['todo_id'],
                    );
                  },
                  taskname: snapshot.data!.docs[index].data()['task name'],
                  taskstatus: snapshot.data!.docs[index].data()['task status'],
                  ondelete: (context) => remove(
                    snapshot.data!.docs[index].data()['todo_id'],
                  ),
                );
              },
            );
          }),
    );
  }
}
 /*ListView.builder(
        itemCount: todolist.length,
        itemBuilder: (context, index) {
          return TodoTile(
            changed: (value) {
              return tapcheckbox(value, index);
            },
            taskname: todolist[index][0],
            taskstatus: todolist[index][1],
            ondelete: (context) => remove(index),
          );
        },
      ),*/