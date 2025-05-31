package com.opp.project.model;

public class Admin {
    private long id;
    private String name;
    private String username;
    private String email;
    private String password;

    // Constructor
    public Admin(long id, String name, String username, String email, String password) {
        this.id = id;
        this.username = username;
        this.name = name;
        this.email = email;
        this.password = password;
    }

    // Getters
    public long getId() { return id; }
    public String getName() { return name; }
    public String getUsername() { return username; }
    public String getEmail() { return email; }
    public String getPassword() { return password; }

    // Format admin data as a string for file storage
    @Override
    public String toString() {
        return id + "," + name + "," + username + "," + email + "," + password;
    }

    // Parse a string from the file into an Admin object
    public static Admin fromString(String line) {
        String[] parts = line.split(",");
        if (parts.length < 5) {
            throw new IllegalArgumentException("Invalid admin data: " + line);
        }

        // Parse id
        long id;
        try {
            id = Long.parseLong(parts[0]);
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid admin ID format: " + parts[0], e);
        }

        return new Admin(id, parts[1], parts[2], parts[3], parts[4]);
    }
}