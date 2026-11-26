package assignment;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Author	:10879408
 * Date		:Nov 24, 2026
 * Time		:8:36:25 PM
 * ProjectName	:BFS_Java8_Java17_All_Answers
 */
public final class Transaction {

	private final int transactionId; 
	private final long accountNumber; 
	private final String transactionType; 
	private final double amount; 
	private final LocalDateTime transactionDate; 
	private final String description;
	Transaction(int id,long no,String type,double amount,LocalDateTime dt,String d){
		this.transactionId=id;
		this.accountNumber=no;
		this.transactionType=type;
		this.amount=amount;
		this.transactionDate=dt;
		this.description=d;
	}

	public int getTransactionId() {
		return transactionId;
	}

	public long getAccountNumber() {
		return accountNumber;
	}

	public String getTransactionType() {
		return transactionType;
	}

	public double getAmount() {
		return amount;
	}

	public LocalDateTime getTransactionDate() {
		return transactionDate;
	}

	public String getDescription() {
		return description;
	}

	@Override 
	public String toString(){
		return transactionId+" | "+accountNumber+" | "+transactionType+" | "+String.format("%.2f",amount)+" | "+transactionDate.format(DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm"))+" | "+description;
	}

}
