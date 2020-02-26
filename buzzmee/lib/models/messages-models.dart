class MessagesModel {
  final dynamic id;
  final dynamic senderId;
    final dynamic username;
  final dynamic body;

 MessagesModel({this.id, this.senderId, this.username, this.body});

 MessagesModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        senderId = json['sender_id'],
        username = json['username'],
        body = json['body'];
}