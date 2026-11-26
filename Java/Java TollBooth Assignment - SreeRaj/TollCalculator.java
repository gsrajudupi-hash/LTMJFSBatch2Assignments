package assignment;

/**
 * @author 10858636
 * @date 18-11-2026 18:55
 */
public class TollCalculator implements Tollable {
    public static final double AXLE_CHARGE = 5;
    public static final double WEIGHT_UNIT = 500;
    public static final double WEIGHT_CHARGE = 10;

    public double calculateToll(Truck truck) {
        int numOfAxles = truck.getNumOfAxles();
        double totalWeight = truck.getWeight();
        double weightUnits = totalWeight / WEIGHT_UNIT;
        return (AXLE_CHARGE * numOfAxles) + (WEIGHT_CHARGE * weightUnits);
    }
}
