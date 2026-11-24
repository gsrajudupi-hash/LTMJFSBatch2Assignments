package com.example.assesements;

public class BasicTruck implements  Truck{
    private final String truckId;
    private final String make;
    private final int axles;
    private final double weight;

    public BasicTruck(String truckId, String make, int axles, double weight)
            throws InvalidTruckException {

        if (truckId == null || truckId.isBlank()) {
            throw new InvalidTruckException("Truck ID cannot be empty.");
        }

        if (make == null || make.isBlank()) {
            throw new InvalidTruckException("Truck make cannot be empty.");
        }

        if (axles <= 0) {
            throw new InvalidTruckException(
                    "Number of axles must be greater than zero."
            );
        }

        if (weight <= 0) {
            throw new InvalidTruckException(
                    "Truck weight must be greater than zero."
            );
        }

        this.truckId = truckId;
        this.make = make;
        this.axles = axles;
        this.weight = weight;
    }

    @Override
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

}
