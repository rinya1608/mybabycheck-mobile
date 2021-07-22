import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mybabycheck_flutter/model/EnumAnswers.dart';
import 'package:mybabycheck_flutter/model/question.dart';
import 'package:mybabycheck_flutter/utils/testApi.dart';
import 'package:http/http.dart' as http;
import 'package:mybabycheck_flutter/utils/testApi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'model/theme.dart';

class TestWidget extends StatefulWidget {
  const TestWidget(
    this.month,
    this.childId, {
    Key? key,
  }) : super(key: key);

  final String month;
  final String childId;

  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  late Future<List<ThemeModel>?> _future;

  @override
  void initState() {
    _future =
        fetchThemeWithAnswers(http.Client(), widget.month, widget.childId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Анкета",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            TextButton(
                onPressed: () async {
                  List<Question> list = [];
                  List<pw.Text> NoList = [];
                  List<pw.Text> YesList = [];
                  List<pw.Text> NotSureList = [];
                  final pdf = pw.Document();
                  final output = await getTemporaryDirectory();
                  final file = File("${output.path}/report.pdf");
                  final ByteData fontData =
                      await rootBundle.load('assets/fonts/open-sans.ttf');
                  final ttf = pw.Font.ttf(fontData.buffer.asByteData());
                  final pw.TextStyle textStyle =
                      pw.TextStyle(font: ttf, fontSize: 40);
                  _future.then((themeList) async => {
                        themeList!.forEach((theme) {
                          theme.questions.forEach((question) {
                            list.add(question);
                            if (question.answer == EnumAnswers.NO)
                              NoList.add(pw.Text("-" + question.text,
                                  style: textStyle));
                            if (question.answer == EnumAnswers.YES)
                              YesList.add(pw.Text("-" + question.text,
                                  style: textStyle));
                            if (question.answer == EnumAnswers.NOT_SURE)
                              NotSureList.add(pw.Text("-" + question.text,
                                  style: textStyle));
                          });
                        }),
                        print(jsonEncode(list)),
                        sendAnswers(http.Client(),
                            "a90b1e11-45dd-4f86-987e-c20595637939", list),
                        pdf.addPage(pw.Page(
                            pageFormat: PdfPageFormat.a4,
                            build: (pw.Context context) {
                              return pw.Column(children: [
                                pw.Text(
                                    "Спасибо, что участвуете в проекте MyBabyCheck.Ниже представлен список Ваших ответов и перечень навыков, которые освоил ваш ребенок в возрасте 2 месяца",
                                    style: textStyle),
                                pw.Text("Вы ответили «Да» на следующие пункты:",
                                    style: textStyle),
                                pw.Column(children: YesList),
                                pw.Text(
                                    "Вы ответили «Не знаю» на следующие пункты:",
                                    style: textStyle),
                                pw.Column(children: NotSureList),
                                pw.Text(
                                    "Обратите внимание, что на эти пункты Вы ответили «Нет»:",
                                    style: textStyle),
                                pw.Column(children: NoList),
                                pw.Text(
                                    "Вы знаете своего ребёнка лучше всех. Но, если он не освоил отдельные навыки,понаблюдайте за ним. Если Вас что-либо беспокоит, поделитесь своими опасениями сврачом.",
                                    style: textStyle)
                              ]);
                            })),
                        file.writeAsBytes(await pdf.save()),
                      });
                },
                child: Text("Скачать PDF"))
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: _future,
        builder:
            (BuildContext context, AsyncSnapshot<List<ThemeModel>?> listTheme) {
          if (listTheme.hasData) {
            return ListView.builder(
              itemCount: listTheme.data!.length,
              itemBuilder: (context, index) {
                return Container(
                  child: Column(children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        listTheme.data![index].title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Column(
                      children:
                          listTheme.data![index].questions.map((question) {
                        return new Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "-" + question.text,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Column(
                              children: [
                                RadioListTile<EnumAnswers>(
                                  title: const Text('Да'),
                                  value: EnumAnswers.YES,
                                  groupValue: question.answer,
                                  onChanged: (EnumAnswers? value) {
                                    setState(() {
                                      question.answer = value!;
                                    });
                                  },
                                ),
                                RadioListTile<EnumAnswers>(
                                  title: const Text('Нет'),
                                  value: EnumAnswers.NO,
                                  groupValue: question.answer,
                                  onChanged: (EnumAnswers? value) {
                                    setState(() {
                                      question.answer = value!;
                                    });
                                  },
                                ),
                                RadioListTile<EnumAnswers>(
                                  title: const Text('Не знаю'),
                                  value: EnumAnswers.NOT_SURE,
                                  groupValue: question.answer,
                                  onChanged: (EnumAnswers? value) {
                                    setState(() {
                                      question.answer = value!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        );
                      }).toList(),
                    )
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
