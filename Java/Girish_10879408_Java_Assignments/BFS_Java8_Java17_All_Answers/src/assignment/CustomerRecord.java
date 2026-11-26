package assignment;

import java.util.Objects;

/**
 * Author	:10879408
 * Date		:Nov 24, 2026
 * Time		:8:39:27 PM
 * ProjectName	:BFS_Java8_Java17_All_Answers
 */
public record CustomerRecord(int customerId,String name,String city,String customerType) {

}

record TransactionRecord(int transactionId,long accountNumber,String transactionType,double amount) {
	TransactionRecord { if(amount<=0)throw new IllegalArgumentException("Amount must be positive"); 
	Objects.requireNonNull(transactionType,"transactionType"); }
}
record AccountSummary(long accountNumber,String type,double balance) {}
record TransactionSummary(long count,double total,double average) {}
