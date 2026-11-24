package com.library.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Utility class for date formatting and parsing
 */
public class DateUtil {
    private static final String DATE_FORMAT = "yyyy-MM-dd";
    private static final String DATETIME_FORMAT = "yyyy-MM-dd HH:mm:ss";
    private static final String DISPLAY_DATE_FORMAT = "dd MMM yyyy";

    /**
     * Format date to string (yyyy-MM-dd)
     * @param date Date to format
     * @return Formatted date string
     */
    public static String formatDate(Date date) {
        if (date == null) return "";
        SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT);
        return sdf.format(date);
    }

    /**
     * Format date to display string (dd MMM yyyy)
     * @param date Date to format
     * @return Formatted date string for display
     */
    public static String formatDisplayDate(Date date) {
        if (date == null) return "";
        SimpleDateFormat sdf = new SimpleDateFormat(DISPLAY_DATE_FORMAT);
        return sdf.format(date);
    }

    /**
     * Format datetime to string (yyyy-MM-dd HH:mm:ss)
     * @param date Date to format
     * @return Formatted datetime string
     */
    public static String formatDateTime(Date date) {
        if (date == null) return "";
        SimpleDateFormat sdf = new SimpleDateFormat(DATETIME_FORMAT);
        return sdf.format(date);
    }

    /**
     * Parse string to date (yyyy-MM-dd)
     * @param dateString String to parse
     * @return Parsed Date object
     * @throws ParseException if parsing fails
     */
    public static Date parseDate(String dateString) throws ParseException {
        if (dateString == null || dateString.trim().isEmpty()) return null;
        SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT);
        return sdf.parse(dateString);
    }

    /**
     * Parse string to date with datetime format (yyyy-MM-dd HH:mm:ss)
     * @param dateTimeString String to parse
     * @return Parsed Date object
     * @throws ParseException if parsing fails
     */
    public static Date parseDateTime(String dateTimeString) throws ParseException {
        if (dateTimeString == null || dateTimeString.trim().isEmpty()) return null;
        SimpleDateFormat sdf = new SimpleDateFormat(DATETIME_FORMAT);
        return sdf.parse(dateTimeString);
    }

    /**
     * Convert java.util.Date to java.sql.Date
     * @param date util Date
     * @return sql Date
     */
    public static java.sql.Date toSqlDate(Date date) {
        if (date == null) return null;
        return new java.sql.Date(date.getTime());
    }

    /**
     * Get current date as sql.Date
     * @return Current date
     */
    public static java.sql.Date getCurrentSqlDate() {
        return new java.sql.Date(System.currentTimeMillis());
    }
}
