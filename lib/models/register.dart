class Register {
  String? email;
  String? password;
  String? name;
  String? phone;
  String? dob;
  String? gender;

  Register(
      {this.email,
        this.password,
        this.name,
        this.phone,
        this.dob,
        this.gender});

  Register.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    name = json['name'];
    phone = json['phone'];
    dob = json['dob'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['dob'] = this.dob;
    data['gender'] = this.gender;

    return data;
  }
}