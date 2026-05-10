package com.voting.util;

public class ValidationUtil {

    public static boolean isValidEmail(String email) {
        return email != null && email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$");
    }

    public static boolean isValidPassword(String password) {
        return password != null && password.length() >= 6;
    }

    public static boolean isNotEmpty(String value) {
        return value != null && !value.trim().isEmpty();
    }

    public static boolean isValidVoterId(String voterId) {
        return voterId != null && voterId.matches("^[A-Z0-9]{5,15}$");
    }
}