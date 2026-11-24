package com.example.assesements;

import java.util.ArrayList;
import java.util.List;

public class TollBoothManagementSystem {
    public static void main(String[] args) {


            try {
                TollBooth tollBooth = new AlleghenyTollBooth();

                List<Truck> trucks = new ArrayList<>();

                trucks.add(
                        new BasicTruck(
                                "TRK001",
                                "Ford",
                                5,
                                12500
                        )
                );

                trucks.add(
                        new BasicTruck(
                                "TRK002",
                                "Tata",
                                4,
                                11500
                        )
                );

                // Polymorphic processing
                for (Truck truck : trucks) {
                    tollBooth.calculateTollAndDisplay(truck);
                }

                tollBooth.displayData();

                tollBooth.collectReceipts();

                // Verify that values were reset
                tollBooth.displayData();

            } catch (InvalidTruckException e) {

                System.out.println(
                        "Invalid truck data: " + e.getMessage()
                );

            } catch (Exception e) {

                System.out.println(
                        "Unexpected error: " + e.getMessage()
                );
            }
        }
    }

