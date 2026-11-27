package com.tollbooth;

public class Main {

    public static void main(String[] args) {

        TollBooth booth = new TollBoothImpl();

        try {

            Truck truck1 = new Truck("Ford", 5, 12500);

            booth.calculateToll(truck1);

            booth.displayData();

            booth.collectReceipts();

            booth.displayData();

        } catch (InvalidTruckException e) {

            System.out.println(
                    "Invalid truck data: " + e.getMessage()
            );
        }
    }
}