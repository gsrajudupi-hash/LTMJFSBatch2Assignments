package com.tollbooth;

public class Truck {

    private final String make;
    private final int axles;
    private final double weight;

    public Truck(String make, int axles, double weight)
            throws InvalidTruckException {

        // Check truck make
        if (make == null || make.isBlank()) {
            throw new InvalidTruckException(
                    "Truck make cannot be empty."
            );
        }

        // Check number of axles
        if (axles <= 0) {
            throw new InvalidTruckException(
                    "Number of axles must be greater than zero."
            );
        }

        // Check truck weight
        if (weight <= 0) {
            throw new InvalidTruckException(
                    "Truck weight must be greater than zero."
            );
        }

        this.make = make;
        this.axles = axles;
        this.weight = weight;
    }

    public String getMake() {
        return make;
    }

    public int getAxles() {
        return axles;
    }

    public double getWeight() {
        return weight;
    }
}