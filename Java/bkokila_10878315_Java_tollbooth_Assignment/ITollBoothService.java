package trucktollbooth;
/**
*Author  : 10878315
*Date    : 22 Nov 2026
*Time 	 : 3:59:06 pm
*Project : CoreJavaAssignment
*/

public interface ITollBoothService {
	void calculateToll (Truck truck);
	void displayTotals();
	void collectReceipts();

}
