package TollBooth;

public class Truck {
	 private final String make;
	   private final int axles;
	   private final int totalWeightKg;
	   public Truck(String make, int axles, int totalWeightKg) {
	       this.make = make;
	       this.axles = axles;
	       this.totalWeightKg = totalWeightKg;
	   }
	   public String getMake() {
	       return make;
	   }
	   public int getAxles() {
	       return axles;
	   }
	   public int getTotalWeightKg() {
	       return totalWeightKg;
	   }
}
