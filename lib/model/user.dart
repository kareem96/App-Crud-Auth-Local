class User{
  String? userId;
  String? userName;
  String? email;
  String? password;

  User(this.password, this.email, this.userId, this.userName);

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      "userId":userId,
      "userName":userName,
      "email":email,
      "password":password,
    };
    return map;
  }

  User.fromMap(Map<String, dynamic> map){
    userId = map["userId"];
    userName = map["userName"];
    email = map["email"];
    password = map["password"];
  }
}