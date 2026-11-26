package coreJava_assignment;

/**
* Author	:10879408
* Date		:Nov 23, 2026
* Time		:9:51:14 AM
* ProjectName	:CoreJava
*/

public class BasicTruck implements Truck {
    private final String id;
    private final String make;
    private final int axles;
    private final double weight;

    public BasicTruck(String id, String make, int axles, double weight) {
        if (id == null || id.trim().isEmpty()) {
            throw new IllegalArgumentException("Truck ID cannot be empty.");
        }
        if (make == null || make.trim().isEmpty()) {
            throw new IllegalArgumentException("Truck make cannot be empty.");
        }
        if (axles <= 0) {
            throw new IllegalArgumentException("Number of axles must be greater than zero.");
        }
        if (weight <= 0) {
            throw new IllegalArgumentException("Truck weight must be greater than zero.");
        }
        this.id = id;
        this.make = make;
        this.axles = axles;
        this.weight = weight;
    }

    @Override public String getId() { return id; }
    @Override public String getMake() { return make; }
    @Override public int getAxles() { return axles; }
    @Override public double getWeight() { return weight; }
}
