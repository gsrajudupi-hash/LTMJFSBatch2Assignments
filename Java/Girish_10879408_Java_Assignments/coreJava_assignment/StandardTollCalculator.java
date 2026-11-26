package coreJava_assignment;

/**
* Author	:10879408
* Date		:Nov 23, 2026
* Time		:9:51:14 AM
* ProjectName	:CoreJava
*/

public class StandardTollCalculator implements TollCalculator {
    private static final double AXLE_RATE = 5.0;
    private static final double WEIGHT_UNIT_RATE = 10.0;
    private static final double WEIGHT_UNIT_KG = 500.0;

    @Override
    public double calculateToll(Truck truck) {
        if (truck == null) {
            throw new IllegalArgumentException("Truck cannot be null.");
        }
        double axleCharge = truck.getAxles() * AXLE_RATE;
        double weightUnits = truck.getWeight() / WEIGHT_UNIT_KG;
        double weightCharge = weightUnits * WEIGHT_UNIT_RATE;
        return axleCharge + weightCharge;
    }
}
