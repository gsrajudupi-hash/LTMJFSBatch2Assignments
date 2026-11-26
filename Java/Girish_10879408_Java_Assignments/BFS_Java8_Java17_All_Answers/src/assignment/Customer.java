package assignment;

/**
 * Author	:10879408
 * Date		:Nov 24, 2026
 * Time		:8:17:50 PM
 * ProjectName	:BFS_Java8_Java17_All_Answers
 */
public final class Customer {

	private final int customerId; 
	private String name,email,city,phone,customerType;

	Customer(int id,String name,String email,String city,String phone,String type){
		this.customerId=id;
		this.name=name;
		this.email=email;
		this.city=city;
		this.phone=phone;
		this.customerType=type;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getCustomerType() {
		return customerType;
	}

	public void setCustomerType(String customerType) {
		this.customerType = customerType;
	}

	public int getCustomerId() {
		return customerId;
	}

	@Override 
	public String toString(){
		return "Customer{"+customerId+", "+name+", "+city+", "+customerType+"}";
	}
	@Override 
	public boolean equals(Object o){
		return o instanceof Customer c && customerId==c.customerId;
	}
	@Override 
	public int hashCode(){
		return Integer.hashCode(customerId);
	}
}
