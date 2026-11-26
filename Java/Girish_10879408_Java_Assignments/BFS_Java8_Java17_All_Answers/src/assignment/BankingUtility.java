package assignment;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.atomic.AtomicLong;
import java.util.function.Consumer;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.function.Supplier;
import java.util.stream.Collectors;

/**
 * Author	:10879408
 * Date		:Nov 25, 2026
 * Time		:9:35:44 AM
 * ProjectName	:BFS_Java8_Java17_All_Answers
 */
public class BankingUtility {

	public static void main(String[] args){
		seed();
		service=new BankingService(customers,accounts,transactions);
		System.out.println("BFS Java 8 + Java 17 Assignment - Complete Demonstration\n");
		java8Answers();streamAnswers();optionalAndReferences();dateTimeAnswer();java17Answers();
		advancedAnswers();generateBankingDashboard();vivaAnswers();consoleDemoInfo();
	}


	static List<Customer> customers=new ArrayList<>(); 
	static List<BankAccount> accounts=new ArrayList<>(); 
	static List<Transaction> transactions=new ArrayList<>(); 
	static BankingService service;
	final static AtomicLong ACCOUNT_SEQ=new AtomicLong(100015);

	public static void java8Answers(){
		System.out.println("\nTASK 2 - Functional Interface & Lambdas");
		BankingOperation deposit=(amount,balance)->balance+amount, withdrawal=(amount,balance)->balance-amount, 
				interest=(rate,balance)->balance+(balance*rate/100);
				System.out.println("Deposit="+deposit.execute(1000,5000)+", Withdrawal="+withdrawal.execute(1000,5000)+","
						+ " Interest="+interest.execute(5,5000));
				Predicate<Customer> premium=c->"PREMIUM".equals(c.getCustomerType()), 
						bangalore=c->"Bangalore".equals(c.getCity()), mangalore=c->"Mangalore".equals(c.getCity()), 
						idAbove105=c->c.getCustomerId()>105;
						System.out.println("\nTASKS 3-6 - Predicate/Consumer/Function/Supplier");
						System.out.println("Premium count="+customers.stream().filter(premium).count()+", "
								+ "Bangalore="+customers.stream().filter(bangalore).count()+", "
								+ "Mangalore="+customers.stream().filter(mangalore).count()+", "
								+ "ID>105="+customers.stream().filter(idAbove105).count());
						Consumer<Customer> displayCustomer=System.out::println; 
						Function<Customer,String> getCustomerName=Customer::getName; 
						Supplier<Long> generator=ACCOUNT_SEQ::incrementAndGet;
						displayCustomer.accept(customers.get(0));
						System.out.println("Function name="+getCustomerName.apply(customers.get(0))+", "
								+ "supplied account="+generator.get());
	}

	public static void streamAnswers(){
		System.out.println("\nTASKS 7-19 - Stream Analytics");
		System.out.println("Premium: "+customers.stream().filter(c->c.getCustomerType().equals("PREMIUM")).toList());
		System.out.println("Bangalore: "+customers.stream().filter(c->c.getCity().equals("Bangalore")).toList());
		System.out.println("Names starting A: "+customers.stream().filter(c->c.getName().startsWith("A")).toList());
		System.out.println("ID > 105: "+customers.stream().filter(c->c.getCustomerId()>105).toList());
		System.out.println("Names: "+customers.stream().map(Customer::getName).toList());
		System.out.println("Name ASC: "+customers.stream().sorted(Comparator.comparing(Customer::getName))
				.map(Customer::getName).toList());
		System.out.println("Name DESC: "+customers.stream()
		.sorted(Comparator.comparing(Customer::getName).reversed())
		.map(Customer::getName).toList());
		System.out.println("ID sort: "+customers.stream().
				sorted(Comparator.comparingInt(Customer::getCustomerId)).toList());
		System.out.println("Type/name: "+customers.stream().sorted(Comparator.comparing(Customer::getCustomerType)
				.thenComparing(Customer::getName)).toList());
		System.out.println("Highest account: "+accounts.stream()
		.max(Comparator.comparingDouble(BankAccount::getBalance)).orElseThrow());
		System.out.println("Lowest account: "+accounts.stream()
		.min(Comparator.comparingDouble(BankAccount::getBalance)).orElseThrow());
		double total=accounts.stream().map(BankAccount::getBalance).reduce(0.0,Double::sum);
		System.out.println("Total balance="+total);
		System.out.println("Average="+accounts.stream().mapToDouble(BankAccount::getBalance).average().orElse(0));
		System.out.println("Premium customer count="+customers.stream()
		.filter(c->c.getCustomerType().equals("PREMIUM")).count());
		System.out.println("Customers by city="+customers.stream()
		.collect(Collectors.groupingBy(Customer::getCity)));
		System.out.println("Accounts by type="+accounts.stream()
		.collect(Collectors.groupingBy(BankAccount::getAccountType,Collectors.counting())));
		System.out.println("Balance by type="+accounts.stream()
		.collect(Collectors.groupingBy(BankAccount::getAccountType,Collectors
				.summingDouble(BankAccount::getBalance))));
		Map<Integer,Double> byCustomer=accounts.stream()
				.collect(Collectors.groupingBy(BankAccount::getCustomerId,Collectors
						.summingDouble(BankAccount::getBalance)));
		System.out.println("High-value customers > 100000="+customers.stream()
		.filter(c->byCustomer.getOrDefault(c.getCustomerId(),0.0)>100000).toList());
		double dep=transactions.stream().filter(t->t.getTransactionType().equals("DEPOSIT"))
				.mapToDouble(Transaction::getAmount).sum(), wd=transactions.stream()
				.filter(t->t.getTransactionType().equals("WITHDRAW")).mapToDouble(Transaction::getAmount).sum();
		System.out.println("Deposits="+dep+", Withdrawals="+wd);
		System.out.println("Highest tx="+transactions.stream()
		.max(Comparator.comparingDouble(Transaction::getAmount)).orElseThrow());
		System.out.println("Lowest tx="+transactions.stream()
		.min(Comparator.comparingDouble(Transaction::getAmount)).orElseThrow());
		System.out.println("Tx count by type="+transactions.stream()
		.collect(Collectors.groupingBy(Transaction::getTransactionType,Collectors.counting())));
		System.out.println("Average tx="+transactions.stream().mapToDouble(Transaction::getAmount)
				.average().orElse(0));
		System.out.println("Tx above 50000="+transactions.stream().filter(t->t.getAmount()>50000).toList());
		demonstrateMandatoryStreams();
	}

	public static void demonstrateMandatoryStreams(){
		System.out.println("\nTASK 19 / Mandatory Stream Operations");
		System.out.println("flatMap account nos="+customers.stream().flatMap(c->accounts.stream()
				.filter(a->a.getCustomerId()==c.getCustomerId())).map(BankAccount::getAccountNumber)
				.limit(5).toList());
		System.out.println("distinct cities="+customers.stream().map(Customer::getCity)
				.distinct().sorted().toList());
		System.out.println("limit 3="+customers.stream().limit(3).toList());
		System.out.println("skip 3="+customers.stream().skip(3).limit(3).toList());
		System.out.println("partition premium="+customers.stream()
		.collect(Collectors.partitioningBy(c->c.getCustomerType().equals("PREMIUM"))));
		System.out.println("joined names="+customers.stream().map(Customer::getName)
				.collect(Collectors.joining(", ")));
		System.out.println("summingDouble="+accounts.stream()
		.collect(Collectors.summingDouble(BankAccount::getBalance))+", averagingDouble="+accounts.stream()
		.collect(Collectors.averagingDouble(BankAccount::getBalance)));
	}

	public static void optionalAndReferences(){
		System.out.println("\nTASK 20 - Optional");
		Optional<Customer> o=customers.stream().filter(c->c.getCustomerId()==101).findFirst();
		System.out.println("orElse="+o.orElse(customers.get(1)));
		System.out.println("orElseGet="+o.orElseGet(()->customers.get(2)));
		System.out.println("orElseThrow="+o.orElseThrow(()->new CustomerNotFoundException("101")));
		o.ifPresent(c->System.out.println("ifPresent="+c));
		System.out.println("\nTASK 21 - Method References");
		Consumer<Customer> instanceRef=System.out::println;Function<String,String> staticRef=String::valueOf;
		Supplier<ArrayList<Customer>> constructorRef=ArrayList::new;
		instanceRef.accept(customers.get(0));
		System.out.println(staticRef.apply("static reference")+", new list size="+constructorRef.get().size());
	}

	public static void dateTimeAnswer(){
		System.out.println("\nTASK 22 - Date/Time API");
		LocalDate d=LocalDate.now();
		LocalTime t=LocalTime.now();
		LocalDateTime dt=LocalDateTime.of(d,t);
		DateTimeFormatter f=DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm:ss");
		System.out.println("Date="+d+", Time="+t.withNano(0)+", DateTime="+dt.format(f));
	}

	public static void java17Answers(){
		System.out.println("\nTASKS 23-29 - Java 17");
		CustomerRecord r1=new CustomerRecord(101,"Rahul","Bangalore","PREMIUM"),
				r2=new CustomerRecord(101,"Rahul","Bangalore","PREMIUM");
		System.out.println("CustomerRecord="+r1+", accessor="+r1.name()+", equals="+r1.equals(r2)+", "
				+ "hash="+r1.hashCode());
		System.out.println("TransactionRecord="+new TransactionRecord(1,100001,"DEPOSIT",5000));
		accounts.stream().limit(3).forEach(BankingUtility::patternMatchAccount);
		for(String type:List.of("DEPOSIT","WITHDRAW","TRANSFER","INTEREST","OTHER"))
			System.out.println(type+" => "+classify(type));
		System.out.println(statement(accounts.get(0)));
		System.out.println(customerJson(customers.get(0)));
		System.out.println(accountJson(accounts.get(0)));
		System.out.println(transactionJson(transactions.get(0)));
	}

	static void patternMatchAccount(BankAccount a){
		if(a instanceof SavingsAccount s)
			System.out.println("Savings balance="+s.getBalance());
		else if(a instanceof CurrentAccount c)
			System.out.println("Current balance="+c.getBalance());
		else if(a instanceof LoanAccount l)
			System.out.println("Loan balance="+l.getBalance());
	}
	public static String classify(String type){
		return switch(type){
		case "DEPOSIT","INTEREST"->"CREDIT";
		case "WITHDRAW","LOAN_PAYMENT"->"DEBIT";
		case "TRANSFER"->"TRANSFER";
		default->"UNKNOWN";
		};
	}
	public static String statement(BankAccount a){
		Customer c=customers.stream().filter(x->x.getCustomerId()==a.getCustomerId())
				.findFirst().orElseThrow();return """
						================================
						BANK ACCOUNT STATEMENT
						================================
						Account Number : %d
						Customer       : %s
						Account Type   : %s
						Balance        : %.2f
						Status         : %s
						================================
						""".formatted(a.getAccountNumber(),c.getName(),a.getAccountType(),a.getBalance(),a.getStatus());
	}
	public static String customerJson(Customer c){
		return """
				{"customerId":%d,"name":"%s","city":"%s","customerType":"%s"}
				""".formatted(c.getCustomerId(),c.getName(),c.getCity(),c.getCustomerType());
	}
	public static String accountJson(BankAccount a){
		return """
				{"accountNumber":%d,"customerId":%d,"accountType":"%s","balance":%.2f,"status":"%s"}
				""".formatted(a.getAccountNumber(),a.getCustomerId(),a.getAccountType(),a.getBalance(),a.getStatus());
	}
	public static String transactionJson(Transaction t){
		return """
				{"transactionId":%d,"accountNumber":%d,"type":"%s","amount":%.2f}
				""".formatted(t.getTransactionId(),t.getAccountNumber(),t.getTransactionType(),t.getAmount());
	}

	public static void advancedAnswers(){
		System.out.println("\nTASKS 31-34 - Advanced Operations & Exceptions");
		try{
			service.deposit(100001,1000);
			service.withdraw(100001,500);
			service.transfer(100001,100002,1000);
			System.out.println("Interest="+service.calculateInterest(100001,2));
			System.out.println("Balance="+service.checkBalance(100001));
		}
		catch(RuntimeException e){
			System.out.println("Handled: "+e.getMessage());
		}
		System.out.println("All tx count="+transactions.size());
		System.out.println("Deposits="+transactions.stream()
		.filter(t->t.getTransactionType().equals("DEPOSIT")).toList());
		System.out.println("Withdrawals="+transactions.stream()
		.filter(t->t.getTransactionType().equals("WITHDRAW")).toList());
		System.out.println("Transfers="+transactions.stream()
		.filter(t->t.getTransactionType().equals("TRANSFER")).toList());
		System.out.println(">50000="+transactions.stream()
		.filter(t->t.getAmount()>50000).toList());
		System.out.println("Sorted="+transactions.stream()
		.sorted(Comparator.comparing(Transaction::getTransactionDate)).limit(5).toList());
		System.out.println("Latest 5="+transactions.stream()
		.sorted(Comparator.comparing(Transaction::getTransactionDate).reversed()).limit(5).toList());
		multiCriteriaAndSummary();
	}

	public static void multiCriteriaAndSummary(){
		System.out.println("\nADVANCED CHALLENGE");
		String type="SAVINGS";
		double minimum=20000;
		List<AccountSummary> search=accounts.stream()
				.filter(a->(type==null||a.getAccountType().equals(type))&&a.getBalance()>=minimum)
				.map(a->new AccountSummary(a.getAccountNumber(),a.getAccountType(),a.getBalance()))
				.toList();System.out.println("Dynamic search="+search);
				Map<Integer,Double> totals=accounts.stream()
						.collect(Collectors.groupingBy(BankAccount::getCustomerId,
								Collectors.summingDouble(BankAccount::getBalance)));
				System.out.println("Top 3 customers="+customers.stream()
				.sorted(Comparator.comparingDouble((Customer c)->totals.getOrDefault(c.getCustomerId(),0.0))
						.reversed()).limit(3).toList());
				System.out.println("Premium partition="+customers.stream()
				.collect(Collectors.partitioningBy(c->c.getCustomerType().equals("PREMIUM"))));
				Map<String,TransactionSummary> summary=transactions.stream()
						.collect(Collectors.groupingBy(Transaction::getTransactionType,Collectors
								.collectingAndThen(Collectors.toList(),l->new TransactionSummary(l.size(),l.stream()
										.mapToDouble(Transaction::getAmount).sum(),l.stream()
										.mapToDouble(Transaction::getAmount).average().orElse(0)))));
				System.out.println("Transaction summary="+summary);
	}

	public static void generateBankingDashboard(){
		long premium=customers.stream().filter(c->c.getCustomerType().equals("PREMIUM")).count();
		double total=accounts.stream().mapToDouble(BankAccount::getBalance).sum(),avg=accounts.stream()
				.mapToDouble(BankAccount::getBalance).average().orElse(0),max=accounts.stream()
				.mapToDouble(BankAccount::getBalance).max().orElse(0);
		double dep=transactions.stream().filter(t->classify(t.getTransactionType())
				.equals("CREDIT")&&t.getTransactionType().equals("DEPOSIT"))
				.mapToDouble(Transaction::getAmount).sum(),wd=transactions.stream()
				.filter(t->t.getTransactionType().equals("WITHDRAW")).mapToDouble(Transaction::getAmount)
				.sum();Map<String,Long> at=accounts.stream()
				.collect(Collectors.groupingBy(BankAccount::getAccountType,Collectors.counting()));
		Map<String,Long> cities=customers.stream()
						.collect(Collectors.groupingBy(Customer::getCity,Collectors.counting()));
		String dashboard="""
						================ BANKING ANALYTICS DASHBOARD ================
						Customers: %d | Premium: %d | Accounts: %d
						Total Balance: %.2f | Average: %.2f | Highest: %.2f
						Transactions: %d | Deposits: %.2f | Withdrawals: %.2f
						Accounts by Type: %s
						Customers by City: %s
						==============================================================
						""".formatted(customers.size(),premium,accounts.size(),total,avg,max,
								transactions.size(),dep,wd,at,cities);
		System.out.println("\nTASK 30\n"+dashboard);
	}

	public static void consoleDemoInfo(){
		System.out.println("\nTASK 35 - Console menu requirements implemented as BankingService operations."
				+ " Menu options: Add Customer, Display Customers, Search Customer, Add Account, Display Accounts, "
				+ "Deposit, Withdraw, Transfer, Balance, Transaction History, Analytics, Customer Report,"
				+ "Account Type Report, Transaction Report, Statement, Exit. "
				+ "This single-file assessment demonstrates the corresponding operations without requiring packages.");
		}

	public static void vivaAnswers(){System.out.println("""

			INTERVIEW ANSWERS
			1. Functional Interface: an interface with exactly one abstract method; it may have default/static methods and is a lambda target. @FunctionalInterface enables compiler checking.
			2. Predicate<T> tests T and returns boolean; Function<T,R> transforms T to R; Consumer<T> accepts T and returns nothing; Supplier<T> takes no argument and supplies T.
			3. filter keeps elements matching a predicate; map transforms one element to one result; flatMap transforms each element to a stream and flattens nested streams.
			4. reduce combines stream elements into one value, e.g. summing balances, when the operation is associative and a collector is not a better fit.
			5. groupingBy creates Map<K,...> for many keys; partitioningBy always divides elements into true/false groups using a Predicate.
			6. Optional represents a possibly absent result and is useful mainly for return values; it avoids returning null and forces explicit absence handling.
			7. A record is a concise immutable data-carrier declaration. Its components are private final and accessor methods, equals, hashCode and toString are generated.
			8. A record cannot extend another class because it implicitly extends java.lang.Record; it can implement interfaces.
			9. A sealed class/interface explicitly restricts which types may extend/implement it through permits or permitted direct subclasses.
			10. sealed restricts subclasses; final forbids subclassing; non-sealed reopens an inherited sealed hierarchy for unrestricted subclassing.
			11. Pattern matching for instanceof combines type checking and binding, eliminating a separate explicit cast and reducing boilerplate/cast errors.
			12. A switch statement primarily controls execution; a switch expression produces a value, supports -> labels and requires exhaustive handling for relevant types.
			13. Text blocks provide readable multi-line strings with fewer escape characters, suitable for reports, SQL, JSON and HTML-like content.
			14. Records became final in Java 16 and sealed classes became final in Java 17. Both were preview features in earlier releases.
			15. Intermediate stream operations, e.g. filter/map/sorted, return another stream and are lazy. Terminal operations, e.g. collect/reduce/count, trigger processing and produce a result/side effect.
			16. Lazy evaluation means intermediate operations execute only when a terminal operation starts traversal, allowing pipeline fusion and short-circuiting.
			17. For thread safety, protect account mutations with per-account locks (ReentrantLock) acquired in stable account-number order for transfers, keep shared collections concurrent or guarded, make transactions atomic and avoid exposing mutable account state.
			""");
	}

	public static void seed(){
		customers.addAll(List.of(new Customer(101,"Rahul","rahul@gmail.com","Bangalore","9876543210","PREMIUM"),
				new Customer(102,"Priya","priya@gmail.com","Mangalore","9876543211","REGULAR"),
				new Customer(103,"Arun","arun@gmail.com","Mysore","9876543212","PREMIUM"),
				new Customer(104,"Sneha","sneha@gmail.com","Udupi","9876543213","REGULAR"),
				new Customer(105,"Kiran","kiran@gmail.com","Bangalore","9876543214","PREMIUM"),
				new Customer(106,"Ananya","ananya@gmail.com","Hyderabad","9876543215","REGULAR"),
				new Customer(107,"Vikram","vikram@gmail.com","Bangalore","9876543216","PREMIUM"),
				new Customer(108,"Meera","meera@gmail.com","Chennai","9876543217","REGULAR"),
				new Customer(109,"Aditya","aditya@gmail.com","Mangalore","9876543218","PREMIUM"),
				new Customer(110,"Neha","neha@gmail.com","Pune","9876543219","REGULAR")));
		for(int i=0;i<15;i++){
			long n=100001L+i;
			int cid=101+(i%10);
			double b=15000+(i*9000);
			BankAccount a=switch(i%3){
			case 0->new SavingsAccount(n,cid,b);
			case 1->new CurrentAccount(n,cid,b);
			default->new LoanAccount(n,cid,b);
			};
			accounts.add(a);
			}
		String[] types={"DEPOSIT","WITHDRAW","TRANSFER","INTEREST"};
		for(int i=1;i<=30;i++){
			BankAccount a=accounts.get((i-1)%accounts.size());
			transactions.add(new Transaction(i,a.getAccountNumber(),
					types[(i-1)%types.length],5000+(i*2500),LocalDateTime.now().minusDays(30-i)
					.withNano(0),"Sample transaction "+i));}
	}

}
