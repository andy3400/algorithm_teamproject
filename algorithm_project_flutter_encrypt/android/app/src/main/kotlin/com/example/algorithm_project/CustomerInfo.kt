package rsa

class CustomerInfo    //name, phonenumber, address의 변수들 설정 및 초기화
(//name getter함수
        val name: String, //phonenumber getter함수
        val phoneNumber: String, private val address: String) {

    fun address(): String {
        return address
    } //address getter함수
    //CustomerInfo, getter함수 추가 후 고객 추가 정보 사용가능
}