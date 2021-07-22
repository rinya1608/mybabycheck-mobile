import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mybabycheck_flutter/CustomTextField.dart';
import 'package:mybabycheck_flutter/newsWidget.dart';
import 'package:mybabycheck_flutter/utils/auth.dart';
import 'package:mybabycheck_flutter/utils/securityStorage.dart';
import 'package:mybabycheck_flutter/main.dart';

class RegistrationWidget extends StatefulWidget {
  const RegistrationWidget({Key? key}) : super(key: key);
  @override
  _RegistrationWidgetState createState() => _RegistrationWidgetState();
}

class _RegistrationWidgetState extends State<RegistrationWidget> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _repeatPasswordController;
  int errorState = 0;

  void setErrorState(int state) {
    setState(() {
      errorState = state;
    });
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _repeatPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 90.0),
            child: Text("Регистрация",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0)),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 20.0),
            child: Text("Заполните все поля, чтобы создать аккаунт",
                style: TextStyle(color: Colors.grey)),
          ),
          (errorState == 1)
              ? Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 45),
                  child: Text(
                    "пользователь с таким email уже существует",
                    style: TextStyle(color: Colors.red),
                  ))
              : (errorState == 2)
                  ? Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 45),
                      child: Text(
                        "Пароли не совпадают",
                        style: TextStyle(color: Colors.red),
                      ))
                  : Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 45),
                    ),
          Container(
            margin: EdgeInsets.only(top: 5),
            alignment: Alignment.center,
            child: CustomTextField(
                hintText: "Email",
                prefixIcon: Icons.email,
                controller: _emailController),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 30.0),
            child: CustomTextField(
              hintText: "Пароль",
              prefixIcon: Icons.lock,
              controller: _passwordController,
              obsureText: true,
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 30.0),
            child: CustomTextField(
              hintText: "Подтвердите пароль",
              prefixIcon: Icons.lock,
              controller: _repeatPasswordController,
              obsureText: true,
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 40.0),
            child: SizedBox(
              width: 250.0,
              height: 50.0,
              child: ElevatedButton(
                  onPressed: () {
                    if (_passwordController.text
                            .compareTo(_repeatPasswordController.text) ==
                        0) {
                      userRegistration(http.Client(), _emailController.text,
                              _passwordController.text)
                          .then((value) => {
                                print(value),
                                if (value!.contains("message"))
                                  {
                                    showDialog<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                                "На вашу почту отправлено письмо с инструкцией для окончания регистрации."),
                                          );
                                        }),
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyStatefulWidget(0)))
                                  }
                                else
                                  {setErrorState(1)}
                              });
                    } else {
                      setErrorState(2);
                    }
                  },
                  child: Text(
                    "Зарегистрироваться",
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
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0))))),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 30.0),
            child: Text(
              "Нажимая на “Зарегистрироваться”, вы даете согласие на обработку и хранение всех введённых вами данных, в том числе персональных.",
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
