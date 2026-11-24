package truckassigment;
/**
* @user:  10878560
*  @time:  3:56:24 pm
*  @date:  21 Nov 2026
*  @todo:  TODO
*
*
**/
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;



// Base class representing a vehicle
abstract class Vehicle implements TollCalculator {

    private final String vehicleId;
    private final String make;
    private final int numberOfAxles;
    private final long totalWeight;

    public Vehicle(String vehicleId, String make,
                   int numberOfAxles, long totalWeight) {

        if (vehicleId == null || vehicleId.isBlank()) {
            throw new IllegalArgumentException(
                    "Vehicle ID cannot be empty");
        }

        if (make == null || make.isBlank()) {
            throw new IllegalArgumentException(
                    "Vehicle make cannot be empty");
        }

        if (numberOfAxles <= 0) {
            throw new IllegalArgumentException(
                    "Number of axles must be greater than zero");
        }

        if (totalWeight <= 0) {
            throw new IllegalArgumentException(
                    "Vehicle weight must be greater than zero");
        }

        this.vehicleId = vehicleId.trim();
        this.make = make.trim();
        this.numberOfAxles = numberOfAxles;
        this.totalWeight = totalWeight;
    }

    public String getVehicleId() {
        return vehicleId;
    }

    public String getMake() {
        return make;
    }

    public int getNumberOfAxles() {
        return numberOfAxles;
    }

    public long getTotalWeight() {
        return totalWeight;
    }

    public abstract void displayVehicleDetails();
}

// Truck implementation
final class Truck extends Vehicle {

    private static final long AXLE_RATE = 5;
    private static final long WEIGHT_RATE = 10;
    private static final long WEIGHT_UNIT = 500;

    public Truck(String vehicleId, String make,
                 int numberOfAxles, long totalWeight) {

        super(vehicleId, make, numberOfAxles, totalWeight);
    }

    @Override
    public long calculateToll() {

        long axleCharge = Math.multiplyExact(
                getNumberOfAxles(), AXLE_RATE);

        long weightUnits = getTotalWeight() / WEIGHT_UNIT;

        long weightCharge = Math.multiplyExact(
                weightUnits, WEIGHT_RATE);

        return Math.addExact(axleCharge, weightCharge);
    }

    @Override
    public void displayVehicleDetails() {

        System.out.println("========================================");
        System.out.println("             TRUCK ARRIVAL");
        System.out.println("========================================");

        System.out.println("Truck ID       : " + getVehicleId());
        System.out.println("Truck Make     : " + getMake());
        System.out.println("Number of Axles: " + getNumberOfAxles());
        System.out.println("Total Weight   : "
                + getTotalWeight() + " kg");

        System.out.printf("Toll Due       : $%.2f%n",
                (double) calculateToll());

        System.out.println("========================================");
    }
}

// Toll booth management
class TollBooth {

    private int totalTrucks;
    private long totalReceipts;

    private final List<Truck> truckHistory;

    public TollBooth() {
        totalTrucks = 0;
        totalReceipts = 0;
        truckHistory = new ArrayList<>();
    }

    // Process truck arrival
    public void processTruck(Truck truck) {

        if (truck == null) {
            throw new IllegalArgumentException(
                    "Truck cannot be null");
        }

        long toll = truck.calculateToll();

        int updatedCount = Math.addExact(totalTrucks, 1);

        long updatedReceipts = Math.addExact(
                totalReceipts, toll);

        truckHistory.add(truck);

        totalTrucks = updatedCount;
        totalReceipts = updatedReceipts;

        truck.displayVehicleDetails();

        System.out.println("Truck processed successfully.");
    }

    // Display current totals
    public void displayTotals() {

        System.out.println("========================================");
        System.out.println("     TOTALS SINCE LAST COLLECTION");
        System.out.println("========================================");

        System.out.println("Total Trucks   : " + totalTrucks);

        System.out.printf("Total Receipts : $%.2f%n",
                (double) totalReceipts);

        System.out.println("========================================");
    }

    // Display truck history
    public void displayTruckHistory() {

        if (truckHistory.isEmpty()) {
            System.out.println("No trucks processed yet.");
            return;
        }

        System.out.println("========================================");
        System.out.println("             TRUCK HISTORY");
        System.out.println("========================================");

        for (Truck truck : truckHistory) {

            System.out.println("Truck ID : "
                    + truck.getVehicleId());

            System.out.println("Make     : "
                    + truck.getMake());

            System.out.println("Axles    : "
                    + truck.getNumberOfAxles());

            System.out.println("Weight   : "
                    + truck.getTotalWeight() + " kg");

            System.out.printf("Toll     : $%.2f%n",
                    (double) truck.calculateToll());

            System.out.println("----------------------------------------");
        }
    }

    // Collect receipts and reset totals
    public void collectReceipts() {

        System.out.println("========================================");
        System.out.println("          COLLECTING RECEIPTS");
        System.out.println("========================================");

        System.out.println("Total Trucks   : " + totalTrucks);

        System.out.printf("Total Receipts : $%.2f%n",
                (double) totalReceipts);

        System.out.println("========================================");

        totalTrucks = 0;
        totalReceipts = 0;
        truckHistory.clear();

        System.out.println("Totals have been reset.");
    }




    static void displayMenu() {

        System.out.println();
        System.out.println("========================================");
        System.out.println("       TOLL BOOTH MANAGEMENT SYSTEM");
        System.out.println("========================================");

        System.out.println("1. Add Truck");
        System.out.println("2. Display Total Collection");
        System.out.println("3. Display Truck History");
        System.out.println("4. Collect Receipts");
        System.out.println("5. Exit");

        System.out.println("========================================");
    }

    public static void addTruck(TollBooth tollBooth) {
    	Scanner scanner =
  	            new Scanner(System.in);
        System.out.print("Enter Truck ID: ");
        String vehicleId = scanner.nextLine();

        System.out.print("Enter Truck Make: ");
        String make = scanner.nextLine();

        int axles = readInt("Enter Number of Axles: ");

        long weight = readLong("Enter Total Weight in KG: ");

        Truck truck = new Truck(
                vehicleId, make, axles, weight);

        tollBooth.processTruck(truck);
    }

    private static int readInt(String message) {
 Scanner scanner =
  	            new Scanner(System.in);
        while (true) {

            System.out.print(message);

            try {

                return Integer.parseInt(
                        scanner.nextLine().trim());

            } catch (NumberFormatException e) {

                System.out.println(
                        "Invalid input. Please enter a valid integer.");
            }
        }
    }

    private static long readLong(String message) {
     Scanner scanner =
  	            new Scanner(System.in);
        while (true) {

            System.out.print(message);

            try {

                return Long.parseLong(
                        scanner.nextLine().trim());

            } catch (NumberFormatException e) {

                System.out.println(
                        "Invalid input. Please enter a valid whole number.");
            }
        }
    }
}
