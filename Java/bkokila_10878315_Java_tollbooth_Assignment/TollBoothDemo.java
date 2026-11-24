package trucktollbooth;
/**
*Author  : 10878315
*Date    : 21 Nov 2026
*Time 	 : 1:38:12 pm
*Project : CoreJavaAssignment
*/

public class TollBoothDemo {

	public static void main(String[] args) {
		TollBooth booth = new TollBooth();

        Truck t1 = new Truck(
                "T101", "Ford", 5, 12500);

        Truck t2 = new Truck(
                "T102", "Tata", 4, 11500);

       
        booth.calculateToll(t1);
        System.out.println();
        booth.calculateToll(t2);

        System.out.println("****************TOTALS SINCE LAST COLLECTION*****************");
        booth.displayTotals();

        
        booth.collectReceipts();

        System.out.println();
        System.out.println("After Collection:");
        booth.displayTotals();

	}

}
