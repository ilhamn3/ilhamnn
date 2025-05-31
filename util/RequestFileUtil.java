package com.opp.project.util;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class RequestFileUtil {
    private static final String USER_HOME = System.getProperty("user.home");
    private static final String APP_DATA_DIR = USER_HOME + File.separator + "Desktop/Project/OOP-Project_P-153/src/main/resources/data";
    private static final String REQUESTS_FILE_PATH = APP_DATA_DIR + File.separator + "requests.txt";
    private static final String ENROLLMENTS_FILE_PATH = APP_DATA_DIR + File.separator + "enrollments.txt";

    static {
        File dir = new File(APP_DATA_DIR);
        if (!dir.exists()) {
            boolean created = dir.mkdirs();
            System.err.println("Created directory " + APP_DATA_DIR + ": " + created);
        }
    }

    public static List<String[]> readRequests() {
        List<String[]> requests = new ArrayList<>();
        File file = new File(REQUESTS_FILE_PATH);
        if (!file.exists()) {
            System.err.println("File does not exist: " + REQUESTS_FILE_PATH + ". Creating new file.");
            try {
                file.createNewFile();
            } catch (IOException e) {
                System.err.println("Error creating file: " + e.getMessage());
            }
        }
        try (BufferedReader br = new BufferedReader(new FileReader(REQUESTS_FILE_PATH))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    String[] requestData = line.split(",");
                    if (requestData.length == 5) {
                        requests.add(requestData);
                    }
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading requests.txt: " + e.getMessage());
        }
        System.err.println("Read " + requests.size() + " requests from file");
        return requests;
    }

    public static void writeRequests(List<String[]> requests) {
        File file = new File(REQUESTS_FILE_PATH);
        if (!file.exists()) {
            System.err.println("File does not exist: " + REQUESTS_FILE_PATH + ". Creating new file.");
            try {
                file.createNewFile();
            } catch (IOException e) {
                System.err.println("Error creating file: " + e.getMessage());
            }
        }
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(REQUESTS_FILE_PATH))) {
            for (String[] request : requests) {
                if (request.length == 5) {
                    String requestData = String.format("%s,%s,%s,%s,%s%n",
                            request[0], request[1], request[2], request[3], request[4]);
                    bw.write(requestData);
                }
            }
            System.err.println("Wrote " + requests.size() + " requests to file");
        } catch (IOException e) {
            System.err.println("Error writing requests to file: " + e.getMessage());
        }
    }

    public static void saveEnrollment(String enrollmentData) {
        File file = new File(ENROLLMENTS_FILE_PATH);
        if (!file.exists()) {
            System.err.println("File does not exist: " + ENROLLMENTS_FILE_PATH + ". Creating new file.");
            try {
                file.createNewFile();
            } catch (IOException e) {
                System.err.println("Error creating file: " + e.getMessage());
            }
        }
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(ENROLLMENTS_FILE_PATH, true))) {
            bw.write(enrollmentData);
            System.err.println("Saved enrollment: " + enrollmentData.trim());
        } catch (IOException e) {
            System.err.println("Error saving enrollment: " + e.getMessage());
        }
    }
}