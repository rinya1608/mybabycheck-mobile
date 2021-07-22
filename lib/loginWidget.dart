import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mybabycheck_flutter/CustomTextField.dart';
import 'package:mybabycheck_flutter/RegistrationWidget.dart';
import 'package:mybabycheck_flutter/main.dart';
import 'package:mybabycheck_flutter/newsWidget.dart';
import 'package:mybabycheck_flutter/utils/auth.dart';
import 'package:mybabycheck_flutter/utils/securityStorage.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool invalidUserData = false;

  void setInvalidUserData(bool state) {
    setState(() {
      invalidUserData = state;
    });
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 70.0),
            child: Column(
              children: [
                Image.asset("assets/images/logo.png"),
                Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Добрый день!",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 23.0),
                    )),
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: Text(
                    "Введите свою почту и пароль чтобы войти",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 70.0),
            child: Column(
              children: [
                invalidUserData
                    ? Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          "Email или пароль введены не верно",
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    : Text(""),
                CustomTextField(
                    hintText: 'Email',
                    prefixIcon: Icons.email,
                    controller: _emailController),
                Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: CustomTextField(
                      hintText: 'Пароль',
                      prefixIcon: Icons.lock,
                      controller: _passwordController,
                      obsureText: true,
                    )),
                Container(
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.only(top: 10.0),
                    child: Text("Забыли пароль?",
                        style: TextStyle(color: Colors.grey)))
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 30.0),
            child: Column(
              children: [
                SizedBox(
                  width: 165.0,
                  height: 50.0,
                  child: ElevatedButton(
                      onPressed: () {
                        userLogin(http.Client(), _emailController.text,
                                _passwordController.text)
                            .then((user) => {
                                  if (user != null)
                                    {
                                      SecurityStorage.writeToStorage(
                                              'user', jsonEncode(user))
                                          .then((value) =>
                                              setInvalidUserData(false)),
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyStatefulWidget(0)))
                                    }
                                  else
                                    {setInvalidUserData(true)}
                                });
                      },
                      child: Text(
                        "Войти",
                        style: TextStyle(fontSize: 20.0),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Colors.grey;
                            return Colors.cyan;
                          }),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0))))),
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Нет аккаунта?"),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegistrationWidget()));
                    },
                    child: Text(
                      "Зарегистрируйтесь",
                      style: TextStyle(color: Colors.cyan),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
