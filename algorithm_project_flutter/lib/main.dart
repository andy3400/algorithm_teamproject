import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class Customer {
  String name;
  String address;
  String phoneNumber;

  Customer({
    required this.name,
    required this.address,
    required this.phoneNumber,
  });
}

class CoustomerInfo extends StatelessWidget {
  final List<Customer> customers = [
    Customer(name: '김관용', address: '', phoneNumber: ''),
    Customer(name: '이태호', address: '', phoneNumber: ''),
    Customer(name: '정은섭', address: '', phoneNumber: ''),
    Customer(name: '박성은', address: '', phoneNumber: ''),
    // 고객정보리스트 추가
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}


class EncryptionService {
  static const platform = MethodChannel('encryption_channel');

  static Future<String> encrypt(String data) async {
    try {
      final String result = await platform.invokeMethod('encrypt', {'data': data});
      return result;
    } on PlatformException catch (e) {
      return 'Error: ${e.message}';
    }
  }

  static Future<String> decrypt(String data) async {
    try {
      final String result = await platform.invokeMethod('decrypt', {'data': data});
      return result;
    } on PlatformException catch (e) {
      return 'Error: ${e.message}';
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RSA Encryption App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EncryptionScreen(),
    );
  }
}
class EncryptionScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Encryption'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DecryptionScreen()),
              );
            },
            child: Text('Go Decryption'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your encryption-related image here
            Image.network(
              'https://media.istockphoto.com/id/1303567646/ko/%EC%82%AC%EC%A7%84/%EB%94%94%EC%A7%80%ED%84%B8-%EB%B0%B1%EA%B7%B8%EB%9D%BC%EC%9A%B4%EB%93%9C-%EB%B3%B4%EC%95%88-%EC%8B%9C%EC%8A%A4%ED%85%9C-%EB%B0%8F-%EB%8D%B0%EC%9D%B4%ED%84%B0-%EB%B3%B4%ED%98%B8.jpg?s=1024x1024&w=is&k=20&c=9sVfvLnqMg-nu3KMH1GAJ7TyNYVrv_ToskXD91765sI=',
              height: 350, // 이미지의 높이
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                _showInputDialog(context);
              },
              child: Text('Encryption'),
            ),
          ],
        ),
      ),
    );
  }

  void _showInputDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Encryption'),
          content: TextField(controller: _nameController, decoration: InputDecoration(labelText: 'Enter Name')),
          actions: [
            ElevatedButton(
              onPressed: () async {
                String encryptedData = await EncryptionService.encrypt(_nameController.text);
                _showResultDialog(context, 'Encrypted Value: $encryptedData');
                Navigator.of(context).pop(); // Dialog 닫기
              },
              child: Text('Do'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialog 닫기
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showResultDialog(BuildContext context, String result) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Result'),
          content: Column(
            children: [
              Text(result),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }
}


class DecryptionScreen extends StatelessWidget {
  final TextEditingController _keyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Decryption'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Go Encryption'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your decryption-related image here
            Image.network(
              'https://media.istockphoto.com/id/1303567646/ko/%EC%82%AC%EC%A7%84/%EB%94%94%EC%A7%80%ED%84%B8-%EB%B0%B1%EA%B7%B8%EB%9D%BC%EC%9A%B4%EB%93%9C-%EB%B3%B4%EC%95%88-%EC%8B%9C%EC%8A%A4%ED%85%9C-%EB%B0%8F-%EB%8D%B0%EC%9D%B4%ED%84%B0-%EB%B3%B4%ED%98%B8.jpg?s=1024x1024&w=is&k=20&c=9sVfvLnqMg-nu3KMH1GAJ7TyNYVrv_ToskXD91765sI=',
              width: 100, // 이미지의 너비
              height: 100, // 이미지의 높이
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                _showInputDialog(context);
              },
              child: Text('Decryption'),
            ),
          ],
        ),
      ),
    );
  }

  void _showInputDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Decryption'),
          content: Column(
            children: [
              TextField(controller: _keyController, decoration: InputDecoration(labelText: 'Enter Key')),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  String decryptedData = await EncryptionService.decrypt(_keyController.text);
                  _showResultDialog(context, 'Decrypted Value: $decryptedData');
                  Navigator.of(context).pop(); // Dialog 닫기
                },
                child: Text('Do'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Dialog 닫기
                },
                child: Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showResultDialog(BuildContext context, String result) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Result'),
          content: Column(
            children: [
              Text(result),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

}