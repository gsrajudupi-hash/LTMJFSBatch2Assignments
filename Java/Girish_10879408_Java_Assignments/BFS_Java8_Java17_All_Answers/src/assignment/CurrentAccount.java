package assignment;

/**
 * Author	:10879408
 * Date		:Nov 24, 2026
 * Time		:8:29:49 PM
 * ProjectName	:BFS_Java8_Java17_All_Answers
 */
public final class CurrentAccount extends BankAccount {

	CurrentAccount(long n,int c,double b){
		super(n,c,b,"ACTIVE");
	}

	@Override
	String getAccountType() {
		return "CURRENT";
	}

	@Override
	double minimumBalance() {
		return 5000;
	}

}
