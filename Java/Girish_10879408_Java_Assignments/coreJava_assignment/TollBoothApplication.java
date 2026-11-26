package coreJava_assignment;

/**
* Author	:10879408
* Date		:Nov 23, 2026
* Time		:9:51:14 AM
* ProjectName	:CoreJava
*/

public class TollBoothApplication {
    public static void main(String[] args) {
        TollCalculator calculator = new StandardTollCalculator();
        TollBooth tollBooth = new HighwayTollBooth(calculator);

        try {
            Truck truck1 = new BasicTruck("TRK001", "Ford", 5, 12500);
            Truck truck2 = new BasicTruck("TRK002", "Tata", 4, 11500);

            tollBooth.calculateToll(truck1);
            tollBooth.calculateToll(truck2);
            tollBooth.displayTotals();
            tollBooth.collectReceipts();

            System.out.println("\nAfter receipt collection:");
            tollBooth.displayTotals();
        } catch (IllegalArgumentException e) {
            System.err.println("Invalid truck information: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("Unexpected error: " + e.getMessage());
        }
    }
}
