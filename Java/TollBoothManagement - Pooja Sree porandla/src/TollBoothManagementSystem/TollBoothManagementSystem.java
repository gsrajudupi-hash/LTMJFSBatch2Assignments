package TollBoothManagementSystem;

import java.util.ArrayList;
import java.util.List;

// Custom Exception
class InvalidTruckDataException extends Exception {

    public InvalidTruckDataException(String message) {
        super(message);
    }
}


// Interface demonstrating abstraction
interface Vehicle {

    String getMake();

    int getAxles();

    double getWeight();

    double calculateToll();
}


// Truck class
class Truck implements Vehicle {

    private final String truckId;
    private final String make;
    private final int axles;
    private final double weight;

    // Toll rates cannot be changed
    private static final double AXLE_RATE = 5.0;
    private static final double WEIGHT_UNIT_RATE = 10.0;
    private static final double WEIGHT_UNIT = 500.0;

    public Truck(String truckId,
                 String make,
                 int axles,
                 double weight) throws InvalidTruckDataException {

        if (truckId == null || truckId.isBlank()) {
            throw new InvalidTruckDataException(
                    "Truck ID cannot be empty."
            );
        }

        if (make == null || make.isBlank()) {
            throw new InvalidTruckDataException(
                    "Truck make cannot be empty."
            );
        }

        if (axles <= 0) {
            throw new InvalidTruckDataException(
                    "Number of axles must be greater than 0."
            );
        }

        if (weight <= 0) {
            throw new InvalidTruckDataException(
                    "Truck weight must be greater than 0."
            );
        }

        this.truckId = truckId;
        this.make = make;
        this.axles = axles;
        this.weight = weight;
    }

    public String getTruckId() {
        return truckId;
    }

    @Override
    public String getMake() {
        return make;
    }

    @Override
    public int getAxles() {
        return axles;
    }

    @Override
    public double getWeight() {
        return weight;
    }

    @Override
    public double calculateToll() {

        double axleCharge = axles * AXLE_RATE;

        // Number of complete 500 kg units
        double weightUnits = weight / WEIGHT_UNIT;

        double weightCharge =
                weightUnits * WEIGHT_UNIT_RATE;

        return axleCharge + weightCharge;
    }
}


// Toll booth interface
interface TollBooth {

    void calculateToll(Vehicle vehicle);

    void displayTotals();

    void collectReceipts();
}


// Toll booth implementation
class HighwayTollBooth implements TollBooth {

    private int totalTrucks;
    private double totalReceipts;

    private final List<Vehicle> processedVehicles;

    public HighwayTollBooth() {
        totalTrucks = 0;
        totalReceipts = 0.0;
        processedVehicles = new ArrayList<>();
    }

    @Override
    public void calculateToll(Vehicle vehicle) {

        double toll = vehicle.calculateToll();

        totalTrucks++;
        totalReceipts += toll;

        processedVehicles.add(vehicle);

        System.out.println(
                "========================================"
        );
        System.out.println("TRUCK ARRIVAL");
        System.out.println(
                "========================================"
        );

        System.out.println(
                "Truck Make     : " + vehicle.getMake()
        );

        System.out.println(
                "Number of Axles: " + vehicle.getAxles()
        );

        System.out.printf(
                "Total Weight   : %.0f kg%n",
                vehicle.getWeight()
        );

        System.out.printf(
                "Toll Due       : $%.2f%n",
                toll
        );

        System.out.println(
                "========================================"
        );
    }

    @Override
    public void displayTotals() {

        System.out.println(
                "\n========================================"
        );

        System.out.println(
                "TOTALS SINCE LAST COLLECTION"
        );

        System.out.println(
                "========================================"
        );

        System.out.println(
                "Total Trucks   : " + totalTrucks
        );

        System.out.printf(
                "Total Receipts : $%.2f%n",
                totalReceipts
        );

        System.out.println(
                "========================================"
        );
    }

    @Override
    public void collectReceipts() {

        System.out.println(
                "\n========================================"
        );

        System.out.println(
                "COLLECTING RECEIPTS"
        );

        System.out.println(
                "========================================"
        );

        System.out.println(
                "Total Trucks   : " + totalTrucks
        );

        System.out.printf(
                "Total Receipts : $%.2f%n",
                totalReceipts
        );

        System.out.println(
                "========================================"
        );

        // Reset counters
        totalTrucks = 0;
        totalReceipts = 0.0;

        // Start a new collection cycle
        processedVehicles.clear();

        System.out.println("Totals have been reset.");
    }
}


// Main class
public class TollBoothManagementSystem {

    public static void main(String[] args) {

        TollBooth tollBooth = new HighwayTollBooth();

        try {

            Vehicle truck1 =
                    new Truck(
                            "TRK101",
                            "Ford",
                            5,
                            12500
                    );

            Vehicle truck2 =
                    new Truck(
                            "TRK102",
                            "Volvo",
                            4,
                            11500
                    );

            // Process trucks
            tollBooth.calculateToll(truck1);
            tollBooth.calculateToll(truck2);

            // Display current totals
            tollBooth.displayTotals();

            // Collect receipts and reset totals
            tollBooth.collectReceipts();

            // Verify reset
            tollBooth.displayTotals();

        } catch (InvalidTruckDataException e) {

            System.out.println(
                    "Error: " + e.getMessage()
            );
        }
    }
}