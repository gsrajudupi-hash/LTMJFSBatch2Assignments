package com.example.assesements.Palindrom;

public class ReverseInteger {
    public static int reverse(int x) {

        int result = 0;

        while (x != 0) {
            int digit = x % 10;
            x = x / 10;
            result = result * 10 + digit;
        }

        return result;
    }

    public static void main(String[] args) {

        int x1 = 123;
        int x2 = -123;
        int x3 = 120;

        System.out.println(reverse(x1));
        System.out.println(reverse(x2));
        System.out.println(reverse(x3));
    }

}
