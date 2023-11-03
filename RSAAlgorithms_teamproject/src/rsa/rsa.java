package rsa;

import javax.crypto.Cipher;
import java.security.*;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Scanner;

public class rsa implements MyEncryption {
	// 수정 테스트
	/*
	 * 공개키와 개인키 한 쌍 생성
	 */
	@Override
	public HashMap<String, String> createKeypairAsString() {
		HashMap<String, String> stringKeypair = new HashMap<>();

		try {
			SecureRandom secureRandom = new SecureRandom();
			KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance("RSA");
			keyPairGenerator.initialize(2048, secureRandom);
			KeyPair keyPair = keyPairGenerator.genKeyPair();

			PublicKey publicKey = keyPair.getPublic();
			PrivateKey privateKey = keyPair.getPrivate();

			String stringPublicKey = Base64.getEncoder().encodeToString(publicKey.getEncoded());
			String stringPrivateKey = Base64.getEncoder().encodeToString(privateKey.getEncoded());

			stringKeypair.put("publicKey", stringPublicKey);
			stringKeypair.put("privateKey", stringPrivateKey);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return stringKeypair;
	}

	/*
	 * 암호화 : 공개키로 진행
	 */
	@Override
	public String encrypt(String plainText, String stringPublicKey) {
		String encryptedText = null;

		try {
			// 평문으로 전달받은 공개키를 사용하기 위해 공개키 객체 생성
			KeyFactory keyFactory = KeyFactory.getInstance("RSA");
			byte[] bytePublicKey = Base64.getDecoder().decode(stringPublicKey.getBytes());
			X509EncodedKeySpec publicKeySpec = new X509EncodedKeySpec(bytePublicKey);
			PublicKey publicKey = keyFactory.generatePublic(publicKeySpec);

			// 만들어진 공개키 객체로 암호화 설정
			Cipher cipher = Cipher.getInstance("RSA");
			cipher.init(Cipher.ENCRYPT_MODE, publicKey);

			byte[] encryptedBytes = cipher.doFinal(plainText.getBytes());
			encryptedText = Base64.getEncoder().encodeToString(encryptedBytes);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return encryptedText;
	}

	/*
	 * 복호화 : 개인키로 진행
	 */
	@Override
	public String decrypt(String encryptedText, String stringPrivateKey) {
		String decryptedText = null;

		try {
			// 평문으로 전달받은 공개키를 사용하기 위해 공개키 객체 생성
			KeyFactory keyFactory = KeyFactory.getInstance("RSA");
			byte[] bytePrivateKey = Base64.getDecoder().decode(stringPrivateKey.getBytes());
			PKCS8EncodedKeySpec privateKeySpec = new PKCS8EncodedKeySpec(bytePrivateKey);
			PrivateKey privateKey = keyFactory.generatePrivate(privateKeySpec);

			// 만들어진 공개키 객체로 복호화 설정
			Cipher cipher = Cipher.getInstance("RSA");
			cipher.init(Cipher.DECRYPT_MODE, privateKey);

			// 암호문을 평문화하는 과정
			byte[] encryptedBytes =  Base64.getDecoder().decode(encryptedText.getBytes());
			byte[] decryptedBytes = cipher.doFinal(encryptedBytes);
			decryptedText = new String(decryptedBytes);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return decryptedText;
	}
	public int getIndexOfName(String customerName, List<CustomerInfo> customerList) {
	    for (int i = 0; i < customerList.size(); i++) {
	        if (customerList.get(i).getName().equals(customerName)) {
	            return i; // 이름이 일치하는 고객을 찾으면 해당 인덱스를 반환
	        }
	    }
	    return -1; // 이름이 일치하는 고객을 찾지 못한 경우 -1을 반환하거나 다른 값을 사용할 수 있습니다.
	}

	public static void main(String[] args) {
		MyEncryption enc = new rsa(); //non static 에러 방지
		List<CustomerInfo> custls = new ArrayList<>();	//고객 정보 리스트 생성
		Scanner sc = new Scanner(System.in);
        rsa a = new rsa();//non static 에러 방지
       

		
		custls.add(new CustomerInfo("김관용","",""));	//("이름", "전화번호", "주소")
        custls.add(new CustomerInfo("이태호","",""));
        custls.add(new CustomerInfo("정은섭","",""));
        custls.add(new CustomerInfo("박성은","",""));
        
        System.out.println("암호화 할 사람의 이름을 입력하세요: ");
        String s1 = sc.next(); //찾고자 하는 사람의 이름을 입력
        int ind = (a.getIndexOfName(s1, custls)+1); //custls의 인덱스 + 1 해서 암호화, 복호화 중 곱,나누기에서 0으로 인한 에러 방지
		//System.out.println(ind);	//index확인
        
		HashMap<String, String> rsaKeyPair = enc.createKeypairAsString();
		String publicKey = rsaKeyPair.get("publicKey");
		String privateKey = rsaKeyPair.get("privateKey");

		System.out.println("만들어진 공개키:" + publicKey);
		System.out.println("만들어진 개인키:" + privateKey);

		String plainText = "플레인 텍스트";
		System.out.println("평문: " + plainText);

		String encryptedText = enc.encrypt(plainText, publicKey);
		System.out.println("암호화: " + encryptedText);

		String decryptedText = enc.decrypt(encryptedText, privateKey);
		System.out.println("복호화: " + decryptedText);
	}
}