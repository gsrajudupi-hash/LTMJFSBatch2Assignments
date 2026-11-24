package com.example.assesements;

public interface TollBooth {
    double calculateToll(Truck truck);

    void calculateTollAndDisplay(Truck truck);

    void displayData();

    void collectReceipts();

}
