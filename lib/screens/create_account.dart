import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:chatapp/models/register.dart';
class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();

  String? _gender;
  DateTime? _dateOfBirth;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dateOfBirth)
      setState(() {
        _dateOfBirth = picked;
        _dobController.text = _dateOfBirth!.toIso8601String();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng kí tài khoản'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Vui lòng nhập email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Mật khẩu'),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Vui lòng nhập mật khẩu';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Vui lòng nhập tên của bạn'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Vui lòng nhập ID';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
                SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                      labelText: 'Số điện thoại'
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Vui lòng nhập số điện thoại';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _gender,
                  decoration: InputDecoration(labelText: 'Giới tính'),
                  items: <String>['MALE', 'FEMALE'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _gender = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng chọn giới tính';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Ngày sinh'),
                  readOnly: true,
                  controller: _dobController,
                  onTap: () => _selectDate(context),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Vui lòng chọn ngày sinh';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Register register = Register(
                        email: _emailController.text,
                        password: _passwordController.text,
                        phone: _phoneController.text,
                        name: _nameController.text,
                        dob: _dobController.text,
                        gender: _gender,
                      );

                      // Chuyển đổi đối tượng Register thành JSON
                      String json = jsonEncode(register.toJson());

                      print(json);

                      // Gửi dữ liệu lên server bằng phương thức POST
                      var response = await http.post(
                        Uri.parse('http://192.168.56.1:8080/api/auth/register'),
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                        body: json,
                      );
                      print(response.body);
                      if (response.statusCode == 200 || response.statusCode == 201) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text("Đăng kí thành công")));
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('Đăng ký thất bại')));
                      }
                    }
                  },
                  child: Text('Đăng ký'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}