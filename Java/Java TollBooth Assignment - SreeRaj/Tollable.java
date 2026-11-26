package assignment;

/**
 * @author 10858636
 * @date 18-11-2026 19:22
 */
public interface Tollable {
    <T extends Truck> double calculateToll(T truck);
}
