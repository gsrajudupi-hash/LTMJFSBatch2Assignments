package TollBooth;

public class TollBoothDemo {

	public static void main(String[] args) {
	       TollBooth booth = new HighwayTollBooth();
	       // First truck (from the problem statement)
	       Truck truck1 = new Truck("Ford", 5, 12500);
	       booth.processArrival(truck1);
	       // Second truck (to match the $525 total shown in sample)
	       Truck truck2 = new Truck("Volvo", 5, 10000);
	       booth.processArrival(truck2);
	       booth.displayTotals();
	       booth.collectReceipts();
	       // Show that totals are reset
	       booth.displayTotals();

	}

}
