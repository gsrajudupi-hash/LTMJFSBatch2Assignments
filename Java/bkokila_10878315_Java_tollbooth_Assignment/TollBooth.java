package trucktollbooth;
/**
*Author  : 10878315
*Date    : 21 Nov 2026
*Time 	 : 1:27:41 pm
*Project : CoreJavaAssignment
*/

public class TollBooth implements ITollBoothService{
	
	private int totalTrucks = 0;
    private double totalReceipts = 0;
    
    public void calculateToll (Truck truck) {
    	int axleCharge=truck.getAxles()*5;
    	int weighCharge= (truck.getWeight()/500)*10;
    	
    	double totalTollCharge=axleCharge+weighCharge;
    	
    	totalTrucks++;
    	
    	totalReceipts+=totalTollCharge;
    	    	
    	 System.out.println("*****************TRUCK ARRIVAL*******************");
    	System.out.println("Truck Make: "
                + truck.getMake());

        System.out.println("Number of Axles: "
                + truck.getAxles());

        System.out.println("Total Weight: "
                + truck.getWeight());

        System.out.println("Toll Due: $" + totalTollCharge);
    }

    public void displayTotals() {
    	
        System.out.println("Total Trucks: "
                + totalTrucks);

        System.out.println("Total Receipts: $"
                + totalReceipts);
    }

    public void collectReceipts() {
    	System.out.println("****************COLLECTING RECEIPTS*****************");
        displayTotals();

        totalTrucks = 0;
        totalReceipts = 0;

        System.out.println("Totals have been reset.");
    }
}