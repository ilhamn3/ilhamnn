package com.opp.project.model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

public class Student {
    private long studentId; // Added student ID (numeric)
    private String fullName;
    private String username;
    private String phone;
    private String email;
    private String dob;
    private String gender;
    private String password;
    private LocalDateTime registrationTime;

    // Constructor
    public Student(long studentId, String fullName, String username, String phone, String email, String dob, String gender, String password, LocalDateTime registrationTime) {
        this.studentId = studentId;
        this.fullName = fullName;
        this.username = username;
        this.phone = phone;
        this.email = email;
        this.dob = dob;
        this.gender = gender;
        this.password = password;
        this.registrationTime = registrationTime;
    }

    // Getters
    public long getStudentId() { return studentId; }
    public String getFullName() { return fullName; }
    public String getUsername() { return username; }
    public String getPhone() { return phone; }
    public String getEmail() { return email; }
    public String getDob() { return dob; }
    public String getGender() { return gender; }
    public String getPassword() { return password; }
    public LocalDateTime getRegistrationTime() { return registrationTime; }

    // Formatting student data as a string for file storage
    @Override
    public String toString() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        return studentId + "," + fullName + "," + username + "," + phone + "," + email + "," + dob + "," + gender + "," + password + "," + registrationTime.format(formatter);
    }

    // Parse a string from the file into a Student object
    public static Student fromString(String line) {
        String[] parts = line.split(",");
        if (parts.length < 9) {
            throw new IllegalArgumentException("Invalid student data: " + line);
        }

        // Parse studentId
        long studentId;
        try {
            studentId = Long.parseLong(parts[0]);
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid student ID format: " + parts[0], e);
        }

        // Handle the registrationTime field
        String dateTimeStr = parts[8].trim();
        LocalDateTime registrationTime;
        try {
            // First try the standard format
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            registrationTime = LocalDateTime.parse(dateTimeStr, formatter);
        } catch (DateTimeParseException e) {
            // If parsing fails, try a format with milliseconds (e.g., "2025-03-27 11:00:00.0")
            try {
                DateTimeFormatter formatterWithMillis = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.S");
                registrationTime = LocalDateTime.parse(dateTimeStr, formatterWithMillis);
            } catch (DateTimeParseException e2) {
                // If both formats fail, throw an exception with more details
                throw new IllegalArgumentException("Invalid registration time format: " + dateTimeStr, e2);
            }
        }

        return new Student(studentId, parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], registrationTime);
    }
}