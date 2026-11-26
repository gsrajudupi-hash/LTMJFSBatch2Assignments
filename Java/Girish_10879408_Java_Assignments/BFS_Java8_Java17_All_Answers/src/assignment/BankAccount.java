package assignment;

/**
 * Author	:10879408
 * Date		:Nov 24, 2026
 * Time		:8:23:03 PM
 * ProjectName	:BFS_Java8_Java17_All_Answers
 */
public abstract sealed class BankAccount permits SavingsAccount,CurrentAccount,LoanAccount {
	private final long accountNumber; 
	private final int customerId; 
	private double balance; 
	private String status;

	BankAccount(long no,int cid,double bal,String status){
		if(bal<0)
			throw new IllegalArgumentException("Negative opening balance");
		this.accountNumber=no;
		this.customerId=cid;
		this.balance=bal;
		this.status=status;
	}
	long getAccountNumber(){return accountNumber;} 
	int getCustomerId(){return customerId;} 
	double getBalance(){return balance;} 
	String getStatus(){return status;}
	void setBalance(double v){balance=v;} 
	void setStatus(String s){status=s;}

	abstract String getAccountType(); 
	abstract double minimumBalance();

	@Override 
	public String toString(){
		return getAccountType()+"{"+accountNumber+", customer="+customerId+", balance="+String.format("%.2f",balance)+", "+status+"}";
	}


}
