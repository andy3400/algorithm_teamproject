import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Transfer location App",
        home: Scaffold(
            appBar: AppBar(
              title: Text("Hello, Transfer location App"),
              backgroundColor: Colors.deepPurple,
            ),
            body: Builder(
                builder: (context) => SingleChildScrollView(
                    child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(
                            child: Column(children: [
                              Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    'Hello customer',
                                    style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue[800]),
                                  )),
                              Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    'change your location in Encryption',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.deepPurpleAccent),
                                  )),
                              Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Image.network(
                                    'https://media.istockphoto.com/id/1303567646/ko/%EC%82%AC%EC%A7%84/%EB%94%94%EC%A7%80%ED%84%B8-%EB%B0%B1%EA%B7%B8%EB%9D%BC%EC%9A%B4%EB%93%9C-%EB%B3%B4%EC%95%88-%EC%8B%9C%EC%8A%A4%ED%85%9C-%EB%B0%8F-%EB%8D%B0%EC%9D%B4%ED%84%B0-%EB%B3%B4%ED%98%B8.jpg?s=1024x1024&w=is&k=20&c=9sVfvLnqMg-nu3KMH1GAJ7TyNYVrv_ToskXD91765sI=',
                                    height: 350,
                                  )),
                              Padding(
                                  padding: EdgeInsets.all(15),
                                  child: ElevatedButton(
                                    child: Text('Encryption'),
                                    onPressed: () => performEncryption(context),
                                  )),
                            ])))))));
  }

  void performEncryption(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Encryption'),
          content: TextField(),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }
}
