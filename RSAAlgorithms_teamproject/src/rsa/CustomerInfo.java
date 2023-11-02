package rsa;

import java.util.ArrayList;
import java.util.List;

public class CustomerInfo {
    private String name;
    private int index;
    private String phoneNumber;
    private String address;

    public CustomerInfo(String name, int index, String phoneNumber, String address) {
        this.name = name;
        this.index = index;
        this.phoneNumber = phoneNumber;
        this.address = address;
    }


	public String getName() {
        return name;
    }

    public int getIndex() {
        return index;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }
    public String address() {
    	return address;
    }
    
    static void staticMethod() {
    	
    }

    // 다른 고객 정보 관련 메서드를 추가할 수 있음
}