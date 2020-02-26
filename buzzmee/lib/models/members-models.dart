class MembersModel {
  final dynamic id;
  final dynamic username;
  final dynamic firstName;
  final dynamic lastName;
  final dynamic phone;

  MembersModel({this.id, this.username, this.firstName, this.lastName, this.phone});

  MembersModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        lastName = json['last_name'],
        firstName = json['first_name'],
        phone = json['phone_number'],
        username= json['username'];
}