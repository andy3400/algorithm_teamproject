package rsa

import java.util.HashMap

interface MyEncryption {
    fun createKeypairAsString(): HashMap<String?, String?>?
    fun encrypt(plainText: String?, stringPublicKey: String?): String?
    fun decrypt(encryptedText: String?, stringPrivateKey: String?): String?
} //암호화 및 복호화 기능 추상화, 다른 클래스에서 기능 구체적으로 구현하도록 하는 인터페이스
