import 'user.dart';
class Register {
  User? user;

  Register({this.user});

  Register.fromJson(Map<String, dynamic> json) {
    user?.email = json['email'];
    user?.password = json['password'];
    user?.name = json['name'];
    user?.phone = json['phone'];
    user?.dob = json['dob'];
    user?.gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.user?.email;
    data['password'] = this.user?.password;
    data['name'] = this.user?.name;
    data['phone'] = this.user?.phone;
    data['dob'] = this.user?.dob;
    data['gender'] = this.user?.gender;

    return data;
  }
}