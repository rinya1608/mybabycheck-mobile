import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mybabycheck_flutter/RegistrationWidget.dart';
import 'package:mybabycheck_flutter/TestWidget.dart';
import 'package:mybabycheck_flutter/archiveWidget.dart';
import 'package:mybabycheck_flutter/childAddWidget.dart';
import 'package:mybabycheck_flutter/childUpdateWidget.dart';
import 'package:mybabycheck_flutter/newsWidget.dart';
import 'package:mybabycheck_flutter/profileWidget.dart';
import 'package:mybabycheck_flutter/utils/auth.dart';
import 'package:http/http.dart' as http;
import 'package:mybabycheck_flutter/utils/childApi.dart';
import 'package:mybabycheck_flutter/utils/securityStorage.dart';
import 'package:mybabycheck_flutter/utils/testApi.dart';
import 'package:mybabycheck_flutter/custom_icons.dart';
import 'loginWidget.dart';

void main() {
  runApp(const MyApp(null));
  //SecurityStorage.deleteAllFromStorage();
  //SecurityStorage.deleteFromStorage("user");
}

class MyApp extends StatelessWidget {
  const MyApp(Key? key) : super(key: key);
  static const String _title = 'MyBabyCheck';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      home: MyStatefulWidget(0),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget(this.page, {Key? key}) : super(key: key);
  int page = 0;
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  late int _pageIndex;
  List<Widget> _pages = [NewsWidget(), ArchiveWidget(), ProfileWidget()];
  // ignore: non_constant_identifier_names
  void TapAction(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _pageIndex = widget.page;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.newspaper_folded),
            label: 'Новости',
          ),
          BottomNavigationBarItem(
            icon:
                Icon(CustomIcons.free_icon_archive_hand_drawn_box_symbol_35439),
            label: 'Архив',
          ),
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.user),
            label: 'Профиль',
          ),
        ],
        onTap: TapAction,
        currentIndex: _pageIndex,
      ),
    );
  }
}
