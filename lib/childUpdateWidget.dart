import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mybabycheck_flutter/CustomTextField.dart';
import 'package:mybabycheck_flutter/CustomTextFieldDatePicker.dart';
import 'package:mybabycheck_flutter/SecondCustomTextField.dart';
import 'package:mybabycheck_flutter/model/sex.dart';
import 'package:mybabycheck_flutter/profileWidget.dart';
import 'package:mybabycheck_flutter/utils/childApi.dart';
import 'package:mybabycheck_flutter/utils/CustomDateUtils.dart';
import 'package:mybabycheck_flutter/utils/rest.dart';
import 'package:http/http.dart' as http;
import 'package:mybabycheck_flutter/main.dart';
import 'package:mybabycheck_flutter/utils/securityStorage.dart';
import 'model/child.dart';
import 'model/news.dart';

class ChildUpdateWidget extends StatefulWidget {
  const ChildUpdateWidget({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  _ChildUpdateWidgetState createState() => _ChildUpdateWidgetState();
}

class _ChildUpdateWidgetState extends State<ChildUpdateWidget> {
  Sex _sex = Sex.MALE;
  late TextEditingController _nameController;
  late TextEditingController _dateController;
  late TextEditingController _weekController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _dateController = TextEditingController();
    _weekController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _weekController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              "Данные ребенка",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            IconButton(
                icon: Icon(
                  Icons.done,
                  color: Colors.black,
                ),
                onPressed: () {
                  updateChild(
                      http.Client(),
                      SecurityStorage.readFromStorage("user"),
                      widget.id,
                      _nameController.text,
                      EnumToString.convertToString(_sex),
                      _dateController.text,
                      _weekController.text);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyStatefulWidget(2)));
                })
          ]),
          backgroundColor: Colors.white,
        ),
        body: FutureBuilder(
          future: fetchChild(http.Client(), widget.id),
          builder: (BuildContext context, AsyncSnapshot<Child?> child) {
            if (child.hasData) {
              return ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Column(children: [
                      Container(
                        margin: EdgeInsets.only(top: 50),
                        child: Column(children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Имя",
                              textAlign: TextAlign.left,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 18),
                            ),
                          ),
                          SecondCustomTextField(
                              hintText: "Имя",
                              controller: _nameController
                                ..text = child.data!.name)
                        ]),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Column(children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Дата рождения",
                              textAlign: TextAlign.end,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 18),
                            ),
                          ),
                          CustomTextFieldDatePicker(
                              hintText: "Дата",
                              controller: _dateController
                                ..text = child.data!.bornDate.year.toString() +
                                    "-" +
                                    child.data!.bornDate.month.toString() +
                                    "-" +
                                    child.data!.bornDate.day.toString())
                        ]),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Column(children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Неделя рождения",
                              textAlign: TextAlign.left,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 18),
                            ),
                          ),
                          SecondCustomTextField(
                              hintText: "Номер недели",
                              controller: _weekController
                                ..text = child.data!.bornWeek.toString())
                        ]),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Column(children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Пол",
                                textAlign: TextAlign.end,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 18),
                              ),
                            ),
                            ListTile(
                              title: const Text('Мужской'),
                              leading: Radio<Sex>(
                                  value: Sex.MALE,
                                  groupValue: _sex,
                                  onChanged: (Sex? value) {
                                    setState(() {
                                      _sex = value!;
                                    });
                                  }),
                            ),
                            ListTile(
                              title: const Text('Женский'),
                              leading: Radio<Sex>(
                                  value: Sex.FEMALE,
                                  groupValue: _sex,
                                  onChanged: (Sex? value) {
                                    setState(() {
                                      _sex = value!;
                                    });
                                  }),
                            ),
                          ])),
                    ]);
                  });
            } else {
              return SpinKitFadingCircle(
                color: Colors.cyan,
                size: 100.0,
              );
            }
          },
        ));
  }
}
