package rsa;

public class CustomerInfo {
    private String name;
    private String phoneNumber;
    private String address;

    public CustomerInfo(String name, String phoneNumber, String address) {
        this.name = name;
        this.phoneNumber = phoneNumber;
        this.address = address;
    }//name, phonenumber, address의 변수들 설정 및 초기화 
    

	public String getName() {
        return name;
    }//name getter함수

    public String getPhoneNumber() {
        return phoneNumber;
    }//phonenumber getter함수
    
    public String address() {
    	return address;
    }//address getter함수
    
    
    //CustomerInfo, getter함수 추가 후 고객 추가 정보 사용가능
}