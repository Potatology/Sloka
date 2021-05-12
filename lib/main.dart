import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:flutter/services.dart' show rootBundle;

import 'gita.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sloka Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _listItem(index, snapshot) {
    List<Widget> slokaItems = [];
    for (var sloka in snapshot.data.chapters[(index + 1).toString()]) {
      slokaItems.add(Text(sloka));
    }
    index += 1;
    return ExpansionTile(
      title: Text('Chapter $index'),
      children: slokaItems,
    );
  }

  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/storage/gita.json');
  }

  Future<Gita> fetchGita() async {
    var _gitaJsonAsset = await loadAsset();
    var _decodedJson = await convert.json.decode(_gitaJsonAsset);
    var _gita = Gita.fromJson(_decodedJson);
    //var _gitaempty = Gita.empty();

    // for (var i = 1; i < 19; i++) {
    //   for (var jsonname in _gita.chapters[i.toString()]) {
    //     String slokajson =
    //         await rootBundle.loadString('assets/storage/ $jsonname');
    //
    //     Sloka currentSloka = Sloka.fromJson(slokajson);
    //     print(currentSloka);
    //     _gitaempty.chapters[i.toString()].add();
    //   }
    // }

    // return _gitaempty;

    return _gita;
  }

  Future<Gita> _gita;

  @override
  void initState() {
    _gita = fetchGita();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.blue,
            height: _screenSize.height,
          ),
          DraggableScrollableSheet(
              initialChildSize: 0.4,
              minChildSize: 0.06,
              maxChildSize: 0.8,
              expand: true,
              builder: (BuildContext context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: FutureBuilder(
                    future: _gita,
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data.chapters.length,
                          controller: scrollController,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              child: _listItem(index, snapshot),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      } else
                        return CircularProgressIndicator();
                    },
                  ),
                );
              })
        ],
      ),
    );
  }
}
