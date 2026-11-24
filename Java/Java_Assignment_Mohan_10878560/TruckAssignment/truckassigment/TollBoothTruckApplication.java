package truckassigment;

import java.util.Scanner;

/**
* @user:  10878560
*  @time:  10:13:58 am
*  @date:  24 Nov 2026
*  @todo:  TODO
*
*
**/
public class TollBoothTruckApplication {

	    private static final Scanner scanner =
	            new Scanner(System.in);

	    public static void main(String[] args) {

	        TollBooth tollBooth = new TollBooth();

	        boolean running = true;

	        while (running) {

	            TollBooth.displayMenu();

	            int choice = readInt("Enter your choice: ");

	            try {

	                switch (choice) {

	                    case 1:
	                        addTruck(tollBooth);
	                        break;

	                    case 2:
	                        tollBooth.displayTotals();
	                        break;

	                    case 3:
	                        tollBooth.displayTruckHistory();
	                        break;

	                    case 4:
	                        tollBooth.collectReceipts();
	                        break;

	                    case 5:
	                        running = false;

	                        System.out.println(
	                                "Thank you for using Toll Booth System.");
	                        break;

	                    default:
	                        System.out.println(
	                                "Invalid choice. Please select 1 to 5.");
	                }

	            } catch (IllegalArgumentException e) {

	                System.out.println(
	                        "Validation Error: " + e.getMessage());

	            } catch (ArithmeticException e) {

	                System.out.println(
	                        "Calculation Error: Numeric value is too large.");

	            } catch (Exception e) {

	                System.out.println(
	                        "Unexpected Error: " + e.getMessage());
	            }
	        }

	        scanner.close();
	    }

	    // Add truck details
	    public static void addTruck(TollBooth tollBooth) {

	        System.out.print("Enter Truck ID: ");
	        String vehicleId = scanner.nextLine();

	        System.out.print("Enter Truck Make: ");
	        String make = scanner.nextLine();

	        int axles = readPositiveInt(
	                "Enter Number of Axles: ");

	        long weight = readPositiveLong(
	                "Enter Total Weight in KG: ");

	        Truck truck = new Truck(
	                vehicleId, make, axles, weight);

	        tollBooth.processTruck(truck);
	    }

	    // Read integer input
	    private static int readInt(String message) {

	        while (true) {

	            System.out.print(message);

	            try {

	                return Integer.parseInt(
	                        scanner.nextLine().trim());

	            } catch (NumberFormatException e) {

	                System.out.println(
	                        "Invalid input. Please enter a valid integer.");
	            }
	        }
	    }

	    // Read positive integer
	    private static int readPositiveInt(String message) {

	        while (true) {

	            int value = readInt(message);

	            if (value > 0) {
	                return value;
	            }

	            System.out.println(
	                    "Value must be greater than zero.");
	        }
	    }

	    // Read long input
	    private static long readLong(String message) {

	        while (true) {

	            System.out.print(message);

	            try {

	                return Long.parseLong(
	                        scanner.nextLine().trim());

	            } catch (NumberFormatException e) {

	                System.out.println(
	                        "Invalid input. Please enter a valid whole number.");
	            }
	        }
	    }

	    // Read positive long
	    private static long readPositiveLong(String message) {

	        while (true) {

	            long value = readLong(message);

	            if (value > 0) {
	                return value;
	            }

	            System.out.println(
	                    "Value must be greater than zero.");
	        }
	    }
	}