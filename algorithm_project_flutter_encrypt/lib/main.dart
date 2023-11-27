import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class KeyPair {
  BigInt publicKey;
  BigInt privateKey;

  KeyPair(this.publicKey, this.privateKey);
}

KeyPair generateKeyPair() {
  Random random = Random();
  BigInt p = BigInt.from(17);
  BigInt q = BigInt.from(19);
  BigInt n = p * q;
  BigInt phi = (p - BigInt.one) * (q - BigInt.one);
  BigInt e = BigInt.from(5);
  BigInt d = e.modInverse(phi);

  return KeyPair(n, d);
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

class CustomerInfo {
  static final CustomerInfo _instance = CustomerInfo._internal();
  factory CustomerInfo() => _instance;

  CustomerInfo._internal();

  final List<Customer> customers = [
    Customer(name: '김관용', address: '서울', phoneNumber: '010-1234-5678'),
    Customer(name: '이태호', address: '경기', phoneNumber: '010-5678-1234'),
    Customer(name: '정은섭', address: '부산', phoneNumber: '010-9876-5432'),
    Customer(name: '박성은', address: '대구', phoneNumber: '010-4321-8765'),
  ];

  int getIndexByName(String name) {
    for (int i = 0; i < customers.length; i++) {
      if (customers[i].name == name) {
        return i;
      }
    }
    return -1;
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

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://media.istockphoto.com/id/1303567646/ko/%EC%82%AC%EC%A7%84/%EB%94%94%EC%A7%80%ED%84%B8-%EB%B0%B1%EA%B7%B8%EB%9D%BC%EC%9A%B4%EB%93%9C-%EB%B3%B4%EC%95%88-%EC%8B%9C%EC%8A%A4%ED%85%9C-%EB%B0%8F-%EB%8D%B0%EC%9D%B4%ED%84%B0-%EB%B3%B4%ED%98%B8.jpg?s=1024x1024&w=is&k=20&c=9sVfvLnqMg-nu3KMH1GAJ7TyNYVrv_ToskXD91765sI=',
              height: 350,
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
    var keyPair = generateKeyPair();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Encryption'),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Enter Name'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();

                CustomerInfo customerInfo = CustomerInfo();
                int index = customerInfo.getIndexByName(_nameController.text);

                if (index != -1) {
                  BigInt encryptedValue =
                  encryptService(index.toString(), keyPair.publicKey);
                  showDialog(
                    context: context,
                    builder: (context) =>
                        _showResultDialog(encryptedValue),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text('Name not found in customer list.'),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Close'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text('Do'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  BigInt encryptService(String input, BigInt publicKey) {
    List<int> bytes = input.codeUnits;
    BigInt message = BigInt.from(0);
    for (int byte in bytes) {
      message = message * BigInt.from(256) + BigInt.from(byte);
    }

    return message.modPow(BigInt.from(5), publicKey);
  }
}

class _showResultDialog extends StatelessWidget {
  final BigInt encryptedValue;

  _showResultDialog(this.encryptedValue);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Result'),
      content: Text('Encrypted Value: $encryptedValue'),
      actions: [
        ElevatedButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: encryptedValue.toString()));
            Navigator.pop(context);
          },
          child: Text('Copy'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}