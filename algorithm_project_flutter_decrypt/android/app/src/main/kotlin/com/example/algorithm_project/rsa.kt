import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';

class RSAService {
    static AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>? keyPair;

    static Future<void> generateKeyPair() async {
        final keyGen = KeyGenerator('RSA')
        ..initialize(ParametersWithRandom(
            RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 64),
            SecureRandom('Fortuna')..seed(Uint8List(32)),
        ));

        keyPair = keyGen.generateKeyPair();
    }

    static String encrypt(String input) {
        if (keyPair == null) {
            throw Exception('Key pair not generated');
        }

        final encryptor = OAEPEncoding(RSAEngine())
        ..init(true, PublicKeyParameter<RSAPublicKey>(keyPair!.publicKey));
        final encryptedBytes = encryptor.process(Uint8List.fromList(utf8.encode(input)));
        final encryptedString = base64.encode(encryptedBytes);

        return encryptedString;
    }

    static String decrypt(String input) {
        if (keyPair == null) {
            throw Exception('Key pair not generated');
        }

        final decryptor = OAEPEncoding(RSAEngine())
        ..init(false, PrivateKeyParameter<RSAPrivateKey>(keyPair!.privateKey));
        final decryptedBytes = decryptor.process(base64.decode(input));
        final decryptedString = utf8.decode(decryptedBytes);

        return decryptedString;
    }
}
