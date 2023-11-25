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
  // 실제로는 더 안전한 방법을 사용해야 함
  Random random = Random();
  BigInt p = BigInt.from(17); // 소수 p
  BigInt q = BigInt.from(19); // 소수 q
  BigInt n = p * q; // 공개 키
  BigInt phi = (p - BigInt.one) * (q - BigInt.one);
  BigInt e = BigInt.from(5); // 공개 키
  BigInt d = e.modInverse(phi); // 개인 키

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

class CoustomerInfo extends StatelessWidget {
  final List<Customer> customers = [
    Customer(name: '김관용', address: '', phoneNumber: ''),
    Customer(name: '이태호', address: '', phoneNumber: ''),
    Customer(name: '정은섭', address: '', phoneNumber: ''),
    Customer(name: '박성은', address: '', phoneNumber: ''),
    // 고객정보리스트 추가
  ];
  int get length => customers.length;


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
    var keyPair = generateKeyPair();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Encryption'),
          content: TextField(controller: _nameController,
              decoration: InputDecoration(labelText: 'Enter Name')),
          actions: [
            ElevatedButton(
              onPressed: () async {
                BigInt encryptedValue = encryptService(_nameController.text, keyPair.publicKey);
                showDialog(
                  context: context,
                  builder: (context) => _showResultDialog(encryptedValue),
                );
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
  CoustomerInfo customerInfo = CoustomerInfo();

  BigInt encryptService(String input, BigInt publicKey) {
    for(int i=0;i<customerInfo.length;i++){
        if (customerInfo.customers[i].name == input) {
          int ind = i;
        }
      }
    BigInt ciphertext = encrypt(input, publicKey);
    return ciphertext;
  }
}

BigInt encrypt(String plaintext, BigInt publicKey) {
  // 간단한 방식으로 문자열을 숫자로 변환
  List<int> bytes = plaintext.codeUnits;
  BigInt message = BigInt.from(0);
  for (int byte in bytes) {
    message = message * BigInt.from(256) + BigInt.from(byte);
  }

  // 암호화
  return message.modPow(BigInt.from(5), publicKey);
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
              'https://cdn-icons-png.flaticon.com/512/8315/8315710.png',
              height: 350, // 이미지의 높이
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
          content: TextField(controller: _keyController, decoration: InputDecoration(labelText: 'Enter key')),
          actions: [
            ElevatedButton(
              onPressed: () async {
                /*
                String decryptedValue = decryptService(_keyController.text, keyPair.privateKey);
                showDialog(
                  context: context,
                  builder: (context) => _showDecryptResultDialog(decryptedValue),
                );
                 */
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

  CoustomerInfo customerInfo = CoustomerInfo();
/*
  String decryptService(String input, BigInt privateKey) {
    String detext = decrypt(input as BigInt, privateKey);
    return detext;
  }
 */
}
String decrypt(BigInt ciphertext, BigInt privateKey) {
  /*
  // 복호화
  BigInt decryptedMessage = ciphertext.modPow(privateKey, privateKey);

  // 숫자를 문자열로 변환
  String decryptedText = '';
  while (decryptedMessage >= BigInt.zero) {
    int byte = decryptedMessage.toUnsigned(8).toInt();
    decryptedText = String.fromCharCode(byte) + decryptedText;
    decryptedMessage >>= 8;
  }
   */
  return '';
}
class _showDecryptResultDialog extends StatelessWidget {
  final String decryptedValue;
  CoustomerInfo customerInfo = CoustomerInfo();
  _showDecryptResultDialog(this.decryptedValue);


  @override
  Widget build(BuildContext context) {
    /*
    // decryptedValue를 정수로 변환
    int customerIndex = int.tryParse(decryptedValue) ?? -1; // 기본값은 -1로 설정하거나 원하는 값으로 설정

    // CustomerInfo에서 고객 정보 가져오기
    String customerInformation = "No information available";
    if (customerIndex >= 0 && customerIndex < customerInfo.customers.length) {
      customerInformation = customerInfo.customers[customerIndex].toString();
    }*/
    return AlertDialog(
      title: Text('Customer Information'),
      content:Text('Decrypted Value: $decryptedValue'),
      actions: [
          ElevatedButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: decryptedValue));
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
