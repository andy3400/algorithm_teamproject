import java.security.KeyPairGenerator
import java.security.KeyPair
import java.security.PrivateKey
import java.security.PublicKey
import java.security.Signature
import java.util.Base64

class RSAEncryption {

    private lateinit var privateKey: PrivateKey
    private lateinit var publicKey: PublicKey

    init {
        generateKeyPair()
    }

    private fun generateKeyPair() {
        val keyPairGenerator = KeyPairGenerator.getInstance("RSA")
        keyPairGenerator.initialize(2048)
        val keyPair: KeyPair = keyPairGenerator.genKeyPair()
        privateKey = keyPair.private
        publicKey = keyPair.public
    }

    fun encrypt(text: String): String {
        val cipher = javax.crypto.Cipher.getInstance("RSA")
        cipher.init(javax.crypto.Cipher.ENCRYPT_MODE, publicKey)
        val encryptedBytes: ByteArray = cipher.doFinal(text.toByteArray())
        return Base64.getEncoder().encodeToString(encryptedBytes)
    }

    fun decrypt(encryptedText: String): String {
        val cipher = javax.crypto.Cipher.getInstance("RSA")
        cipher.init(javax.crypto.Cipher.DECRYPT_MODE, privateKey)
        val encryptedBytes: ByteArray = Base64.getDecoder().decode(encryptedText)
        val decryptedBytes: ByteArray = cipher.doFinal(encryptedBytes)
        return String(decryptedBytes)
    }
}
