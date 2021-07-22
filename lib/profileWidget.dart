import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mybabycheck_flutter/TestWidget.dart';
import 'package:mybabycheck_flutter/childAddWidget.dart';
import 'package:mybabycheck_flutter/childUpdateWidget.dart';
import 'package:mybabycheck_flutter/loginWidget.dart';
import 'package:mybabycheck_flutter/utils/childApi.dart';
import 'package:mybabycheck_flutter/utils/CustomDateUtils.dart';
import 'package:mybabycheck_flutter/utils/rest.dart';
import 'package:http/http.dart' as http;
import 'package:mybabycheck_flutter/utils/securityStorage.dart';

import 'model/child.dart';
import 'model/news.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  var _future;
  @override
  void initState() {
    _future =
        fetchChilds(http.Client(), SecurityStorage.readFromStorage("user"));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _future.then((value) => {
          print(value),
          if (value == null)
            {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginWidget()))
            }
        });
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Профиль",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Container(
                child: IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChildAddWidget()));
              },
            ))
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
          future: _future,
          builder:
              (BuildContext context, AsyncSnapshot<List<Child>?> listChilds) {
            if (listChilds.hasData) {
              return ListView.builder(
                itemCount: listChilds.data!.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: Size.infinite.width,
                    height: 110.0,
                    child: Container(
                      margin: EdgeInsets.only(top: 9.0),
                      decoration: BoxDecoration(color: Colors.white),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  listChilds.data![index].name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.0),
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 120.0,
                                      height: 40.0,
                                      child: Container(
                                        margin: EdgeInsets.only(right: 10.0),
                                        child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          TestWidget(
                                                              "2",
                                                              listChilds
                                                                  .data![index]
                                                                  .id)));
                                            },
                                            child: Text(
                                              "Анкеты",
                                              style: TextStyle(fontSize: 20.0),
                                            ),
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .resolveWith<Color?>(
                                                            (Set<MaterialState>
                                                                states) {
                                                  if (states.contains(
                                                      MaterialState.pressed))
                                                    return Colors.grey;
                                                  return Colors.cyan;
                                                }),
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    5.0))))),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 60.0,
                                      height: 40.0,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ChildUpdateWidget(
                                                            id: listChilds
                                                                .data![index]
                                                                .id)));
                                          },
                                          child: Icon(Icons.edit_rounded),
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty
                                                      .resolveWith<Color?>((Set<
                                                              MaterialState>
                                                          states) {
                                                if (states.contains(
                                                    MaterialState.pressed))
                                                  return Colors.grey;
                                                return Colors.cyan;
                                              }),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0))))),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Возраст: " +
                                  CustomDateUtils
                                      .monthsAndDaysBetweenDateNowAndDate(
                                          listChilds.data![index].bornDate),
                              style: TextStyle(fontSize: 22.0),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return SpinKitFadingCircle(
                color: Colors.cyan,
                size: 100.0,
              );
            }
          }),
    );
  }
}
