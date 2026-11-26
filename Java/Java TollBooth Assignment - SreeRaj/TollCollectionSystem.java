package assignment;

/**
 * @author 10858636
 * @date 18-11-2026 18:27
 *
 * Every truck must pay toll based on
 * -> no of axles
 * -> total weight of the truck
 * Toll =( $5 * num of axles )+ ($10 * total weight/500)
 * For eg- if a truck has 5 axles and 12500kg, then
 * toll = $5*5 + $10* 12,500/500 = $25+ $250 = $275
 * <p>
 * Toll must also maintain
 * - total number of trucks that have passed since the last collection
 * - total toll receipts collected since the last collection.
 * When the toll collector performs a receipt collection, the current totals should
 * be displayed and then reset to zero.
 * <p>
 * Trucks barcode provides - truck identification, truck made, num of axles
 * when truck arrives, the system displays:
 * ***truck arrival*** , truck made: , number of axles: , total weight: ,total due:
 * <p>
 * Then updates its internal totals. for eg after two trucks,
 * total since last collection *** total trucks : 2, total receipts :
 * when toll collector press collect receipts button
 * collecting receipts ***  total trucks:2, total receipts : $
 * total have been rest. after collection the internal counters become
 * total trucks =0, total receipts = $0.0
 * the toll booth is now ready to process a new collection cycle
 *
 *
 */
public class TollCollectionSystem {
    public static void main(String[] args) {
        Truck truck1 = new Truck("A123", "Ford", 4, 1200.0);
        Tollable calculator = new TollCalculator();
        TollBooth booth = new TollBooth(calculator);
        booth.processTruck(truck1);
        booth.displayTotal();
        Truck truck2 = new Truck("B223", "Toyota", 4, 2000.0);
        Truck truck3 = new Truck("B121", "Hyundai", 6, 2900.0);
        booth.processTruck(truck2);
        booth.processTruck(truck3);
        booth.displayTotal();
        booth.collectReceipt();
    }
}
