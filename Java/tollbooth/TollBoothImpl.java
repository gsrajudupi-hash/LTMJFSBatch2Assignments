package com.tollbooth;
import java.util.ArrayList;
import java.util.List;

public class TollBoothImpl implements TollBooth, TollCalculator{

    private static final double AXLE_RATE = 5.0;
    private static final double WEIGHT_RATE = 10.0;
    private static final double WEIGHT_UNIT = 500.0;

    private int totalTrucks = 0;
    private double totalReceipts = 0.0;
    private final List<Truck> trucks = new ArrayList<>();

    @Override
    public double calculateTollAmount(Truck truck) {

        double axleCharge = truck.getAxles() * AXLE_RATE;

        double weightUnits = truck.getWeight() / WEIGHT_UNIT;

        double weightCharge = weightUnits * WEIGHT_RATE;

        return axleCharge + weightCharge;
    }

    @Override
    public void calculateToll(Truck truck) {

        double toll = calculateTollAmount(truck);

        totalTrucks++;
        totalReceipts += toll;
        trucks.add(truck);

        System.out.println("========================================");
        System.out.println("             TRUCK ARRIVAL");
        System.out.println("========================================");

        System.out.println("Truck Make      : " + truck.getMake());
        System.out.println("Number of Axles : " + truck.getAxles());
        System.out.println("Total Weight    : " + truck.getWeight() + " kg");

        System.out.printf("Toll Due        : $%.2f%n", toll);

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
        trucks.clear();

        System.out.println("Totals have been reset.");
    }

    @Override
    public void displayData() {

        System.out.println("========================================");
        System.out.println("      TOTALS SINCE LAST COLLECTION");
        System.out.println("========================================");

        System.out.println("Total Trucks   : " + totalTrucks);
        System.out.printf("Total Receipts : $%.2f%n", totalReceipts);

        System.out.println("========================================");
    }
}
