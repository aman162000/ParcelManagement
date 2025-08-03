package com.parcel.utils;
import java.util.Random;

public class NumericUniqueIDGenerator {
    public static String generateUniqueId(String prefix) {
        Random random = new Random();
        
        // Generate a 12-digit number (ensure it's in the range of 12 digits)
        long id = 100000000000L + (long) (random.nextDouble() * 900000000000L);
        
        return prefix.toUpperCase()+String.valueOf(id);
    }
}
