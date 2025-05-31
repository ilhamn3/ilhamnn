package com.opp.project.util;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class ContactFileUtil {
    public static final String USER_HOME = System.getProperty("user.home");
    public static final String APP_DATA_DIR = USER_HOME + File.separator + "Desktop/Project/OPP-Project_P-153/src/main/resources/data";
    public static final String CONTACTS_FILE_PATH = APP_DATA_DIR + File.separator + "contacts.txt";

    static {
        File dir = new File(APP_DATA_DIR);
        if (!dir.exists()) {
            dir.mkdirs();
        }
    }

    // Read all contacts from the file
    public static List<String[]> readContacts() {
        List<String[]> contacts = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(CONTACTS_FILE_PATH))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    // Split the line into parts, respecting escaped commas
                    List<String> fields = new ArrayList<>();
                    StringBuilder field = new StringBuilder();
                    boolean escape = false;
                    for (char c : line.toCharArray()) {
                        if (escape) {
                            field.append(c);
                            escape = false;
                        } else if (c == '\\') {
                            escape = true;
                        } else if (c == ',') {
                            fields.add(field.toString());
                            field = new StringBuilder();
                        } else {
                            field.append(c);
                        }
                    }
                    fields.add(field.toString()); // Add the last field
                    String[] contactData = fields.toArray(new String[0]);
                    if (contactData.length == 5) { // Ensure all fields are present: name, email, subject, message, timestamp
                        // Unescape commas in the message
                        contactData[3] = contactData[3].replace("\\,", ",");
                        contacts.add(contactData);
                    }
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading contacts.txt: " + e.getMessage());
        }
        return contacts;
    }

    // Write the entire list of contacts to the file (overwrite mode)
    public static void writeContacts(List<String[]> contacts) {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(CONTACTS_FILE_PATH))) {
            for (String[] contact : contacts) {
                if (contact.length == 5) { // Ensure contact has all required fields
                    // Escape commas in the message
                    String sanitizedMessage = contact[3].replace(",", "\\,");
                    String contactData = String.format("%s,%s,%s,%s,%s%n",
                            contact[0], contact[1], contact[2], sanitizedMessage, contact[4]);
                    bw.write(contactData);
                }
            }
        } catch (IOException e) {
            System.err.println("Error writing contacts to file: " + e.getMessage());
        }
    }
}