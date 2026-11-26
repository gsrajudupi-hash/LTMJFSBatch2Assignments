package assignment;

/**
 * Author	:10879408
 * Date		:Nov 24, 2026
 * Time		:8:30:02 PM
 * ProjectName	:BFS_Java8_Java17_All_Answers
 */
public non-sealed class LoanAccount extends BankAccount {

	LoanAccount(long n,int c,double b){
		super(n,c,b,"ACTIVE");
	}

	@Override
	String getAccountType() {
		return "LOAN";
	}

	@Override
	double minimumBalance() {
		return 0;
	}

}
