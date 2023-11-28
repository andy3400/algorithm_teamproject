import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:convert';


void main() {
  runApp(MyApp());
}
class KeyPair {
  int publicKey;
  int privateKey;
  int n;

  KeyPair(this.n, this.publicKey, this.privateKey);
}

KeyPair generateKeyPair() {
  int p = 17;
  int q = 19;
  int n = p * q;
  int phi = (p-1)*(q-1);
  int e = 5;
  int d = e.modInverse(phi);

  return KeyPair(n, e, d);
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

class CustomerInfo extends StatelessWidget {
  final List<Customer> customers = [
    Customer(name: '김관용', address: '', phoneNumber: ''),
    Customer(name: '이태호', address: '', phoneNumber: ''),
    Customer(name: '정은섭', address: '', phoneNumber: ''),
    Customer(name: '박성은', address: '', phoneNumber: ''),
    // 고객정보리스트 추가
  ];
  int getIndexByName(String name) {
    for (int i = 0; i < customers.length; i++) {
      if (customers[i].name == name) {
        return i;
      }
    }
    return -1;
  }


  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
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
      home: DecryptionScreen(),
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://cdn-icons-png.flaticon.com/512/8315/8315710.png',
              height: 350,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showDeInputDialog(context);
              },
              child: Text('Decryption'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeInputDialog(BuildContext context) {
    var keyPair = generateKeyPair();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Decryption'),
          content: TextField(controller: _keyController, decoration: InputDecoration(labelText: 'Enter Key'),),
          actions: [
            ElevatedButton(
              onPressed: () async {
                String inp = _keyController.text;
                int input = int.parse(inp);
                print('$_keyController');
                int decryptedValue = decryptService(input, keyPair.n, keyPair.privateKey);
                showDialog(
                  context: context,
                  builder: (context) => _showDecryptResultDialog(decryptedValue),
                );
              },
              child: Text('Do'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  int decryptService(int input, int n, int privateKey) {
    int decrypted;
    decrypted = pow(input.toDouble(), privateKey).toInt()%n;
    return decrypted;
  }
}

class _showDecryptResultDialog extends StatelessWidget {
  final int decryptedValue;

  _showDecryptResultDialog(this.decryptedValue);

  @override
  Widget build(BuildContext context) {
    print('$decryptedValue');

    CustomerInfo customerInfo = CustomerInfo();
    int index = decryptedValue;
    String customerInfoText;

    if (index >= 0 && index < customerInfo.customers.length) {
      Customer customer = customerInfo.customers[index];
      customerInfoText = 'Name: ${customer.name}\n Address: ${customer.address}\nPhone Number: ${customer.phoneNumber}';
    } else {
      customerInfoText = 'Invlaid index';
    }

    return AlertDialog(
      title: Text('고객 정보'),
      content: Text(customerInfoText),
      actions: [
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
