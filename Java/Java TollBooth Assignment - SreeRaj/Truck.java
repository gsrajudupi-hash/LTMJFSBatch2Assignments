package assignment;

/**
 * @author 10858636
 * @date 18-11-2026 18:46
 */
public class Truck {
    private final String truckId;
    private final String truckBrand;
    private final int numOfAxles;
    private final double weight;

    /**
     * Constructor
     *
     * @param truckId    truck identification number
     * @param truckBrand the brand of which the truck is made of. Eg - Ford
     * @param numOfAxles number of axles
     * @param weight     weight of the truck
     */
    public Truck(String truckId, String truckBrand, int numOfAxles, double weight) {
        this.truckId = truckId;
        this.truckBrand = truckBrand;
        this.numOfAxles = numOfAxles;
        this.weight = weight;
    }

    public void displayDetails() {
        System.out.println("==================================");
        System.out.println("\t\t\t TRUCK ARRIVAL \t\t\t");
        System.out.println("==================================");
        System.out.println("Truck made  : " + this.truckBrand);
        System.out.println("Number of axles : " + numOfAxles);
    }

    public int getNumOfAxles() {
        return numOfAxles;
    }

    public String getTruckBrand() {
        return truckBrand;
    }

    public String getTruckId() {
        return truckId;
    }

    public double getWeight() {
        return weight;
    }
}
