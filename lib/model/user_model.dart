import 'package:sql_small_project/helper/constance.dart';

class UserModel {
  int id;
  String name, email, phone;

  UserModel({this.id, this.name, this.email, this.phone});

  toJson(){
    return {
      columnName : name,
      columnPhone : phone,
      columnEmail : email,
    };
  }

  UserModel.fromJson(Map<dynamic , dynamic> map){
    if(map == null){
      return;
    }
    name = map[columnName];
    phone = map[columnPhone];
    email = map[columnEmail];

  }

}
