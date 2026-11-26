package TollBooth;

public class HighwayTollBooth implements TollBooth {
	   private static final int AXLE_RATE = 5;
	   private static final int WEIGHT_UNIT = 500;
	   private static final int WEIGHT_RATE = 10;
	   private int totalTrucks;
	   private double totalReceipts;
	   @Override
	   public void processArrival(Truck truck) {
	       int axles = truck.getAxles();
	       int weight = truck.getTotalWeightKg();
	       int weightUnits = weight / WEIGHT_UNIT;
	       double tollDue = (AXLE_RATE * axles) + (WEIGHT_RATE * weightUnits);
	       System.out.println("========================================");
	       System.out.println("          TRUCK ARRIVAL");
	       System.out.println("========================================");
	       System.out.println("Truck Make     : " + truck.getMake());
	       System.out.println("Number of Axles: " + axles);
	       System.out.println("Total Weight   : " + weight + " kg");
	       System.out.printf("Toll Due       : $%.2f%n", tollDue);
	       System.out.println("========================================");
	       System.out.println();
	       totalTrucks++;
	       totalReceipts += tollDue;
	   }
	   @Override
	   public void displayTotals() {
	       System.out.println("========================================");
	       System.out.println("        TOTALS SINCE LAST COLLECTION");
	       System.out.println("========================================");
	       System.out.println("Total Trucks   : " + totalTrucks);
	       System.out.printf("Total Receipts : $%.2f%n", totalReceipts);
	       System.out.println("========================================");
	       System.out.println();
	   }
	   @Override
	   public void collectReceipts() {
	       System.out.println("========================================");
	       System.out.println("          COLLECTING RECEIPTS");
	       System.out.println("========================================");
	       System.out.println("Total Trucks   : " + totalTrucks);
	       System.out.printf("Total Receipts : $%.2f%n", totalReceipts);
	       System.out.println("========================================");
	       System.out.println();
	       System.out.println("Totals have been reset.");
	       System.out.println();
	       totalTrucks = 0;
	       totalReceipts = 0.0;
	   }
	}
