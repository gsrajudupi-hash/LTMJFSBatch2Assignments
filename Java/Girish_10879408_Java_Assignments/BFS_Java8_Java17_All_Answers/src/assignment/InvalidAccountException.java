package assignment;

/**
 * Author	:10879408
 * Date		:Nov 24, 2026
 * Time		:8:14:03 PM
 * ProjectName	:BFS_Java8_Java17_All_Answers
 */
public class InvalidAccountException extends RuntimeException { 
	InvalidAccountException(String m){super(m);
	} 
}
class InsufficientBalanceException extends RuntimeException { 
	InsufficientBalanceException(String m){super(m);
	} 
}
class InvalidTransactionException extends RuntimeException { 
	InvalidTransactionException(String m){super(m);
	} 
}
class CustomerNotFoundException extends RuntimeException { 
	CustomerNotFoundException(String m){super(m);
	} 
}
