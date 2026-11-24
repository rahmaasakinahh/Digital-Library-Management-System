package com.library.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utility class for password hashing and validation
 */
public class PasswordUtil {
    
    /**
     * Hash a plain text password using BCrypt
     * @param plainPassword Plain text password
     * @return Hashed password
     */
    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(10));
    }

    /**
     * Verify a plain text password against a hashed password
     * @param plainPassword Plain text password
     * @param hashedPassword Hashed password to compare against
     * @return true if passwords match
     */
    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (IllegalArgumentException e) {
            // If hashedPassword is not a valid BCrypt hash, fall back to plain text comparison
            // This is for backward compatibility with seed data
            return plainPassword.equals(hashedPassword);
        }
    }

    /**
     * Check if password is already hashed (BCrypt format)
     * @param password Password to check
     * @return true if password is hashed
     */
    public static boolean isHashed(String password) {
        return password != null && password.startsWith("$2a$");
    }
}
