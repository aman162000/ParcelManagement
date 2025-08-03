package com.parcel.exceptions;

public class AuthenticationException extends Exception {
    // Constructor accepting a message
    public AuthenticationException(String message) {
        super(message);
    }

    // Constructor accepting a message and cause
    public AuthenticationException(String message, Throwable cause) {
        super(message, cause);
    }
}