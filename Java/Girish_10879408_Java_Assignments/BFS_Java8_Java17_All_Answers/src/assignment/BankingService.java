package assignment;

import java.time.LocalDateTime;
import java.util.List;

/**
 * Author	:10879408
 * Date		:Nov 24, 2026
 * Time		:8:49:10 PM
 * ProjectName	:BFS_Java8_Java17_All_Answers
 */
public final class BankingService {

	private final List<Customer> customers; 
	private final List<BankAccount> accounts; 
	private final List<Transaction> transactions; 
	private int txId=1000;
	BankingService(List<Customer> c,List<BankAccount> a,List<Transaction> t){
		this.customers=c;
		this.accounts=a;
		this.transactions=t;
		this.txId=t.stream().mapToInt(Transaction::getTransactionId).max().orElse(1000);
	}
	Customer findCustomer(int id){
		return customers.stream().filter(c->c.getCustomerId()==id).findFirst()
				.orElseThrow(()->new CustomerNotFoundException("Customer not found: "+id));
	}
	BankAccount findAccount(long no){
		return accounts.stream().filter(a->a.getAccountNumber()==no).findFirst()
				.orElseThrow(()->new InvalidAccountException("Account not found: "+no));
	}
	void deposit(long no,double amount){
		validateAmount(amount);
		BankAccount a=findAccount(no);
		a.setBalance(a.getBalance()+amount);
		addTx(no,"DEPOSIT",amount,"Cash deposit");
	}
	void withdraw(long no,double amount){
		validateAmount(amount);
		BankAccount a=findAccount(no);
		if(a.getBalance()-amount<a.minimumBalance())
			throw new InsufficientBalanceException("Minimum balance "+a.minimumBalance()+" must be maintained");
		a.setBalance(a.getBalance()-amount);
		addTx(no,"WITHDRAW",amount,"Cash withdrawal");
	}

	void transfer(long from,long to,double amount){
		if(from==to)
			throw new InvalidTransactionException("Source and target must differ");
		validateAmount(amount);
		BankAccount s=findAccount(from),d=findAccount(to);
		if(s.getBalance()-amount<s.minimumBalance())
			throw new InsufficientBalanceException("Insufficient transferable balance");
		s.setBalance(s.getBalance()-amount);
		d.setBalance(d.getBalance()+amount);
		addTx(from,"TRANSFER",amount,"Transfer to "+to);
		addTx(to,"DEPOSIT",amount,"Transfer from "+from);
	}

	double calculateInterest(long no,double rate){
		if(rate<0)
			throw new InvalidTransactionException("Rate cannot be negative");
		BankAccount a=findAccount(no);
		double i=a.getBalance()*rate/100;
		addTx(no,"INTEREST",i,"Interest @ "+rate+"%");
		a.setBalance(a.getBalance()+i);return i;
	}

	double checkBalance(long no){
		return findAccount(no).getBalance();
	}
	private void validateAmount(double x){
		if(x<=0)throw new InvalidTransactionException("Amount must be positive");
	}

	private void addTx(long no,String type,double amt,String desc){
		transactions.add(new Transaction(++txId,no,type,amt,LocalDateTime.now(),desc));
	}

}
