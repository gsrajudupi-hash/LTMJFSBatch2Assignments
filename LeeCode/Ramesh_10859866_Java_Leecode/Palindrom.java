package com.example.assesements.Palindrom;

public class Palindrom {
    public static boolean isPalindrome(String s) {

        String finalString = s.toLowerCase()
                .replaceAll("[^a-z0-9]", "");

        // Reverse the cleaned string
        String reverseString = new StringBuilder(finalString)
                .reverse()
                .toString();

        // Compare original and reversed strings
        return finalString.equals(reverseString);
    }

    public static void main(String[] args) {

        //String input = "A man, a plan, a canal: Panama";
        String input = "ramesh";

        System.out.println(isPalindrome(input));
    }

}