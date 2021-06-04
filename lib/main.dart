import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  Future<String> _getFutureValue() async {
    // 擬似的に通信中を表現するために１秒遅らせる
    await Future.delayed(
      Duration(seconds: 5),
    );

    try {
      /// 正常パターン
      return Future.value("データの取得に成功しました");

      /// snapshot.hasDataがfalseになる
      // return Future.value(null);

      /// snapshot.hadErrorがtrueになる
      // throw Exception("データの取得に失敗しました");
    } catch (error) {
      return Future.error(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FutureBuilder Demo'),
      ),
      body: Center(
        child: FutureBuilder(
          future: _getFutureValue(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            // 通信中はインジケーターを表示
            if (snapshot.connectionState != ConnectionState.done) {
              return CircularProgressIndicator();
            }

            // エラー発生時はエラーメッセージを表示
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            // データがnullでないかチェック
            if (snapshot.hasData) {
              //最初の1秒はデータがまだないため、nullチェック(!)を入れておく
              return Text(snapshot.data!);
            } else {
              return Text("データが存在しません");
            }
          },
        ),
      ),
    );
  }
}
