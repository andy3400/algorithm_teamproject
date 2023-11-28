package rsa;
import java.util.HashMap;

public interface MyEncryption {
    HashMap<String, String> createKeypairAsString();
    String encrypt(String plainText, String stringPublicKey);
    String decrypt(String encryptedText, String stringPrivateKey);
    
}//암호화 및 복호화 기능 추상화, 다른 클래스에서 기능 구체적으로 구현하도록 하는 인터페이스
