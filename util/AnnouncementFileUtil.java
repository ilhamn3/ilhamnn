package com.opp.project.util;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class AnnouncementFileUtil {
    public static final String USER_HOME = System.getProperty("user.home");
    public static final String APP_DATA_DIR = USER_HOME + File.separator + "Desktop/Project/OPP-Project_P-153/src/main/resources/data";
    public static final String ANNOUNCEMENTS_FILE_PATH = APP_DATA_DIR + File.separator + "announcements.txt";

    static {
        File dir = new File(APP_DATA_DIR);
        if (!dir.exists()) {
            dir.mkdirs();
        }
    }

    // Read all announcements from the file
    public static List<String[]> readAnnouncements() {
        List<String[]> announcements = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(ANNOUNCEMENTS_FILE_PATH))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    String[] announcementData = line.split(",", 3); // Split into 3 parts: title,content,date
                    if (announcementData.length == 3) {
                        announcements.add(announcementData);
                    }
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading announcements.txt: " + e.getMessage());
        }
        return announcements;
    }

    // Save a single announcement to the file (append mode)
    public static void saveAnnouncement(String title, String content, String date) {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(ANNOUNCEMENTS_FILE_PATH, true))) {
            String announcementData = String.format("%s,%s,%s%n", title, content, date);
            bw.write(announcementData);
        } catch (IOException e) {
            System.err.println("Error saving announcement: " + e.getMessage());
        }
    }

    // Write the entire list of announcements to the file (overwrite mode)
    public static void writeAnnouncements(List<String[]> announcements) {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(ANNOUNCEMENTS_FILE_PATH))) {
            for (String[] announcement : announcements) {
                if (announcement.length == 3) { // Ensure announcement has all required fields
                    String announcementData = String.format("%s,%s,%s%n",
                            announcement[0], announcement[1], announcement[2]);
                    bw.write(announcementData);
                }
            }
        } catch (IOException e) {
            System.err.println("Error writing announcements to file: " + e.getMessage());
        }
    }
}