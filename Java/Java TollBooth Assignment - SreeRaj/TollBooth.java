package assignment;

/**
 * @author 10858636
 * @date 18-11-2026 18:59
 */
public class TollBooth {
    private int numOfTrucksPassed;
    private double totalTollReceipts;
    private final Tollable tollCalculator;

    public TollBooth(Tollable toll) {
        numOfTrucksPassed = 0;
        totalTollReceipts = 0;
        this.tollCalculator = toll;
    }

    public void processTruck(Truck truck) {
        double toll = tollCalculator.calculateToll(truck);
        displayArrivalDetails(truck, toll);
        numOfTrucksPassed++;
        totalTollReceipts += toll;
    }

    //***truck arrival*** , truck made: , number of axles: , total weight: ,total due:
    public void displayArrivalDetails(Truck truck, double toll) {
        truck.displayDetails();
        System.out.println("Total due : $" + toll);
        System.out.println("==========================");
    }

    public void displayTotal() {
        System.out.println("=======================");
        System.out.println("Totals since last collection");
        System.out.println("=======================");
        System.out.println("Total truck  : " + numOfTrucksPassed);
        System.out.println("Total receipts  : " + totalTollReceipts);
        System.out.println("=======================");
    }

    public void collectReceipt() {
        System.out.println("=========================");
        System.out.println("\t COLLECTING RECIEPTS ");
        System.out.println("=========================");
        System.out.println("Total trucks: " + numOfTrucksPassed);
        System.out.println("Total number of reciepts: $" + totalTollReceipts);
        System.out.println("=========================");
        totalTollReceipts = 0.0;
        numOfTrucksPassed = 0;
    }
}
