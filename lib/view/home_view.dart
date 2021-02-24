import 'package:flutter/material.dart';
import 'package:sql_small_project/helper/database_helper.dart';
import 'package:sql_small_project/model/user_model.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<UserModel> usersList = [];
  String name, phone, email;
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool flag = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Contacts'),
      ),
      body: getAllUser(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  getAllUser() {
    return FutureBuilder(
      future: _getData(),
      builder: (context, snapshot) {
        return createListView(context, snapshot);
      },
    );
  }

  Future<List<UserModel>> _getData() async {
    var dbHelper = DatabaseHelper.db;
    await dbHelper.getAllUsers().then((value) {
      print(value);
      usersList = value;
    });
    return usersList;
  }

  createListView(BuildContext context, AsyncSnapshot snapshot) {
    usersList = snapshot.data;

    if (usersList != null) {
      return ListView.builder(
        itemCount: usersList.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: UniqueKey(),
            background: Container(
              color: Colors.red,
            ),
            onDismissed: (directon){
              DatabaseHelper.db.deleteUser(usersList[index].id);
            },
            child: _buildItem(usersList[index], index),
          );
        },
      );
    } else {
      return Container();
    }
  }

  _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => openAlertBox(null),
      backgroundColor: Colors.red,
      child: Icon(Icons.add),
    );
  }

  openAlertBox(UserModel model) {
    if (model != null) {
      name = model.name;
      phone = model.phone;
      email = model.email;
      flag = true;
    } else {
      name = '';
      phone = '';
      email = '';
      flag = false;
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            width: 300,
            height: 200,
            child: Form(
              key: _key,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: name,
                    decoration: InputDecoration(
                      hintText: 'Add Name',
                      fillColor: Colors.grey[300],
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      return null;
                    },
                    onSaved: (String value) {
                      name = value;
                    },
                  ),
                  TextFormField(
                    initialValue: phone,
                    decoration: InputDecoration(
                      hintText: 'Add Phone',
                      fillColor: Colors.grey[300],
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      return null;
                    },
                    onSaved: (String value) {
                      phone = value;
                    },
                  ),
                  TextFormField(
                    initialValue: email,
                    decoration: InputDecoration(
                      hintText: 'Add email',
                      fillColor: Colors.grey[300],
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      return null;
                    },
                    onSaved: (String value) {
                      email = value;
                    },
                  ),
                  FlatButton(
                    onPressed: () {
                      flag ? editUser(model.id) : addUser();
                    },
                    child: Text(flag ? 'Edit User' : 'Add User'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void addUser() {
    _key.currentState.save();

    var dbHelper = DatabaseHelper.db;
    dbHelper
        .insertUser(UserModel(name: name, phone: phone, email: email))
        .then((value) {
      Navigator.pop(context);
      setState(() {});
    });
  }

  void editUser(int id) {
    _key.currentState.save();

    var dbHelper = DatabaseHelper.db;
    UserModel user = UserModel(
      id: id,
      name: name,
      phone: phone,
      email: email,
    );
    dbHelper.updateUser(user).then((value) {
      Navigator.pop(context);
      setState(() {
        flag = false;
      });
    });
  }

  _buildItem(UserModel model, int index) {
    return Card(
      child: ListTile(
        title: Row(
          children: [
            Column(
              children: [
                Container(
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.brown,
                    child: Text(
                      model.name.substring(0, 1).toLowerCase(),
                      style: TextStyle(fontSize: 35, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(Icons.account_circle),
                    Padding(padding: EdgeInsets.only(right: 10)),
                    Text(
                      model.name,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      softWrap: true,
                      maxLines: 2,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.phone),
                    Padding(padding: EdgeInsets.only(right: 10)),
                    Text(
                      model.phone,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      softWrap: true,
                      maxLines: 2,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.email),
                    Padding(padding: EdgeInsets.only(right: 10)),
                    Text(
                      model.email,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      softWrap: true,
                      maxLines: 2,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        trailing: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: IconButton(
            onPressed: () => _onEdit(model, index),
            icon: Icon(Icons.edit),
          ),
        ),
      ),
    );
  }

  _onEdit(UserModel model, int index) {
    openAlertBox(model);
  }
}
