package com.example.assesements;

public class AlleghenyTollBooth  implements  TollBooth{

    private static final double AXLE_RATE = 5.0;
    private static final double WEIGHT_UNIT_RATE = 10.0;
    private static final double WEIGHT_UNIT_KG = 500.0;

    private int totalTrucks;
    private double totalReceipts;

    public AlleghenyTollBooth() {
        this.totalTrucks = 0;
        this.totalReceipts = 0.0;
    }

    @Override
    public double calculateToll(Truck truck) {

        if (truck == null) {
            throw new IllegalArgumentException("Truck cannot be null.");
        }

        double axleCharge = truck.getAxles() * AXLE_RATE;

        // Based on the assignment formula:
        // Weight Units = Total Weight / 500
        double weightUnits = truck.getWeight() / WEIGHT_UNIT_KG;

        double weightCharge = weightUnits * WEIGHT_UNIT_RATE;

        return axleCharge + weightCharge;
    }

    @Override
    public void calculateTollAndDisplay(Truck truck) {

        double toll = calculateToll(truck);

        totalTrucks++;
        totalReceipts += toll;

        System.out.println("========================================");
        System.out.println("TRUCK ARRIVAL");
        System.out.println("========================================");
        System.out.println("Truck ID       : " + truck.getTruckId());
        System.out.println("Truck Make     : " + truck.getMake());
        System.out.println("Number of Axles: " + truck.getAxles());
        System.out.printf(
                "Total Weight   : %.0f kg%n",
                truck.getWeight()
        );
        System.out.printf("Toll Due       : $%.2f%n", toll);
        System.out.println("========================================");
    }

    @Override
    public void displayData() {

        System.out.println();
        System.out.println("========================================");
        System.out.println("TOTALS SINCE LAST COLLECTION");
        System.out.println("========================================");
        System.out.println("Total Trucks   : " + totalTrucks);
        System.out.printf("Total Receipts : $%.2f%n", totalReceipts);
        System.out.println("========================================");
    }

    @Override
    public void collectReceipts() {

        System.out.println();
        System.out.println("========================================");
        System.out.println("COLLECTING RECEIPTS");
        System.out.println("========================================");
        System.out.println("Total Trucks   : " + totalTrucks);
        System.out.printf("Total Receipts : $%.2f%n", totalReceipts);
        System.out.println("========================================");

        totalTrucks = 0;
        totalReceipts = 0.0;

        System.out.println("Totals have been reset.");
    }
}


// ========================
// Custom Exception
// ========================
class InvalidTruckException extends Exception {

    public InvalidTruckException(String message) {
        super(message);
    }
}

