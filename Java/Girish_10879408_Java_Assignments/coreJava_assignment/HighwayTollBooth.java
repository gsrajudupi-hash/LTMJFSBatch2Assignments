package coreJava_assignment;

/**
* Author	:10879408
* Date		:Nov 23, 2026
* Time		:9:51:14 AM
* ProjectName	:CoreJava
*/

import java.util.ArrayList;
import java.util.List;

public class HighwayTollBooth implements TollBooth {
    private int totalTrucks;
    private double totalReceipts;
    private final TollCalculator calculator;
    private final List<Truck> processedTrucks;

    public HighwayTollBooth(TollCalculator calculator) {
        if (calculator == null) {
            throw new IllegalArgumentException("Toll calculator cannot be null.");
        }
        this.calculator = calculator;
        this.processedTrucks = new ArrayList<>();
    }

    @Override
    public void calculateToll(Truck truck) {
        if (truck == null) {
            throw new IllegalArgumentException("Truck cannot be null.");
        }
        double toll = calculator.calculateToll(truck);
        totalTrucks++;
        totalReceipts += toll;
        processedTrucks.add(truck);

        System.out.println("========================================");
        System.out.println("            TRUCK ARRIVAL");
        System.out.println("========================================");
        System.out.println("Truck ID        : " + truck.getId());
        System.out.println("Truck Make      : " + truck.getMake());
        System.out.println("Number of Axles : " + truck.getAxles());
        System.out.printf("Total Weight    : %.0f kg%n", truck.getWeight());
        System.out.printf("Toll Due        : $%.2f%n", toll);
        System.out.println("========================================");
    }

    @Override
    public void displayTotals() {
        System.out.println("========================================");
        System.out.println("     TOTALS SINCE LAST COLLECTION");
        System.out.println("========================================");
        System.out.println("Total Trucks   : " + totalTrucks);
        System.out.printf("Total Receipts : $%.2f%n", totalReceipts);
        System.out.println("========================================");
    }

    @Override
    public void collectReceipts() {
        System.out.println("========================================");
        System.out.println("          COLLECTING RECEIPTS");
        System.out.println("========================================");
        System.out.println("Total Trucks   : " + totalTrucks);
        System.out.printf("Total Receipts : $%.2f%n", totalReceipts);
        System.out.println("========================================");
        totalTrucks = 0;
        totalReceipts = 0.0;
        processedTrucks.clear();
        System.out.println("Totals have been reset.");
    }
}
