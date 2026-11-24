package trucktollbooth;
/**
*Author  : 10878315
*Date    : 21 Nov 2026
*Time 	 : 1:26:07 pm
*Project : CoreJavaAssignment
*/

public class Truck {
	private String truckId;
    private String make;
    private int axles;
    private int weight;
    
	public Truck(String truckId, String make, int axles, int weight) {
		super();
		this.truckId = truckId;
		this.make = make;
		this.axles = axles;
		this.weight = weight;
	}

	public String getTruckId() {
		return truckId;
	}

	public String getMake() {
		return make;
	}

	public int getAxles() {
		return axles;
	}

	public int getWeight() {
		return weight;
	}
    
    
}
