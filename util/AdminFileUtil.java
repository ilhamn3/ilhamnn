package com.opp.project.util;

import org.mindrot.jbcrypt.BCrypt;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class AdminFileUtil {
    public static final String USER_HOME = System.getProperty("user.home");
    public static final String APP_DATA_DIR = USER_HOME + File.separator + "Desktop" + File.separator +
            "Project" + File.separator + "OPP-Project_P-153" +
            File.separator + "src" + File.separator + "main" +
            File.separator + "resources" + File.separator + "data";
    public static final String ADMINS_FILE_PATH = APP_DATA_DIR + File.separator + "admin.txt";

    static {
        File dir = new File(APP_DATA_DIR);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        // Create admin.txt if it doesn't exist
        File file = new File(ADMINS_FILE_PATH);
        if (!file.exists()) {
            try {
                file.createNewFile();
            } catch (IOException e) {
                System.err.println("Error creating admin.txt: " + e.getMessage());
            }
        }
    }

    // Read all admins from the file, protecting ID 1
    public static List<String[]> readAdmins() {
        List<String[]> admins = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(ADMINS_FILE_PATH))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    String[] adminData = line.split(",");
                    if (adminData.length == 5) {
                        if (adminData[0].equals("1")) {
                            admins.add(0, adminData); // Ensure ID 1 is first
                        } else {
                            admins.add(adminData);
                        }
                    }
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading admin.txt: " + e.getMessage());
        }
        return admins;
    }

    // Get the next available admin ID, starting from 2 if ID 1 exists
    public static int getNextAdminId() {
        List<String[]> admins = readAdmins();
        int maxId = 1; // Reserve 1 for the primary admin
        for (String[] admin : admins) {
            try {
                int id = Integer.parseInt(admin[0]);
                if (id != 1) {
                    maxId = Math.max(maxId, id);
                }
            } catch (NumberFormatException e) {
                System.err.println("Invalid admin ID format: " + admin[0]);
            }
        }
        return maxId + 1;
    }

    // Save a single admin to the file (append mode)
    public static void saveAdmin(String name, String username, String email, String password) {
        int adminId = getNextAdminId();
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(ADMINS_FILE_PATH, true))) {
            String adminData = String.format("%d,%s,%s,%s,%s%n", adminId, name, username, email, hashedPassword);
            bw.write(adminData);
        } catch (IOException e) {
            System.err.println("Error saving admin: " + e.getMessage());
        }
    }

    // Update an existing admin's data
    public static void updateAdmin(String id, String name, String username, String email, String password) {
        List<String[]> admins = readAdmins();
        boolean updated = false;
        for (int i = 0; i < admins.size(); i++) {
            if (admins.get(i)[0].equals(id) && !id.equals("1")) {
                String hashedPassword = password != null && !password.isEmpty() ? BCrypt.hashpw(password, BCrypt.gensalt()) : admins.get(i)[4];
                admins.set(i, new String[]{id, name, username, email, hashedPassword});
                updated = true;
                break;
            }
        }
        if (updated) {
            writeAdmins(admins);
        }
    }

    // Write the entire list of admins to the file (overwrite mode)
    public static void writeAdmins(List<String[]> admins) {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(ADMINS_FILE_PATH))) {
            for (String[] admin : admins) {
                if (admin.length == 5) {
                    String adminData = String.format("%s,%s,%s,%s,%s%n",
                            admin[0], admin[1], admin[2], admin[3], admin[4]);
                    bw.write(adminData);
                }
            }
        } catch (IOException e) {
            System.err.println("Error writing admins to file: " + e.getMessage());
        }
    }
}