package rsa;
import java.util.HashMap;

public interface MyEncryption {
    HashMap<String, String> createKeypairAsString();
    String encrypt(String plainText, String stringPublicKey);
    String decrypt(String encryptedText, String stringPrivateKey);

    static void staticMethod() {
    	
    }
}
