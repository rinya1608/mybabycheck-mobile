import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mybabycheck_flutter/utils/rest.dart';
import 'package:http/http.dart' as http;

import 'model/news.dart';

class NewsWidget extends StatefulWidget {
  const NewsWidget({Key? key}) : super(key: key);
  @override
  _NewsWidgetState createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Новости",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: fetchNews(http.Client()),
        builder: (BuildContext context, AsyncSnapshot<List<News>?> listNews) {
          if (listNews.hasData) {
            return ListView.builder(
              itemCount: listNews.data!.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(top: 20.0),
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0.5,
                        blurRadius: 0.5,
                        offset: Offset(0, 3))
                  ]),
                  child: Column(children: [
                    Image.network(listNews.data![index].img),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(listNews.data![index].title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                fontFamily: ''))),
                    Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: Text(listNews.data![index].text))
                  ]),
                );
              },
            );
          } else
            return SpinKitFadingCircle(
              color: Colors.cyan,
              size: 100.0,
            );
        },
      ),
    );
  }
}
