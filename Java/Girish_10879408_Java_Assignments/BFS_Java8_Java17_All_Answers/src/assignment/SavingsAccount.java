package assignment;

/**
 * Author	:10879408
 * Date		:Nov 24, 2026
 * Time		:8:28:50 PM
 * ProjectName	:BFS_Java8_Java17_All_Answers
 */
public final class SavingsAccount extends BankAccount {

	SavingsAccount(long n,int c,double b){
		super(n,c,b,"ACTIVE");
	}

	@Override
	String getAccountType() {
		return "SAVINGS";
	}

	@Override
	double minimumBalance() {

		return 1000;
	}

}
