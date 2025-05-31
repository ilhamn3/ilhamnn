package com.opp.project.util;

import com.opp.project.model.Admin;
import com.opp.project.model.Student;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class FileUtil {
    public static final String USER_HOME = System.getProperty("user.home");
    public static final String APP_DATA_DIR =  USER_HOME + File.separator +
            "Desktop" + File.separator + "Project" + File.separator +
            "OPP-Project_P-153" + File.separator + "src" + File.separator +
            "main" + File.separator + "resources" + File.separator + "data";
    public static final String DATA_FILE_PATH;
    public static final String ADMIN_FILE_PATH;

    static {
        File dir = new File(APP_DATA_DIR);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        DATA_FILE_PATH = APP_DATA_DIR + File.separator + "students.txt";
        ADMIN_FILE_PATH = APP_DATA_DIR + File.separator + "admin.txt";
    }

    // Save a single student to the file
    public static void saveStudent(String studentData) {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(DATA_FILE_PATH, true))) {
            bw.write(studentData);
            bw.newLine();
        } catch (IOException e) {
            System.err.println("Error saving student: " + e.getMessage());
        }
    }

    // Save a single admin to the file
    public static void saveAdmin(Admin admin) {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(ADMIN_FILE_PATH, true))) {
            bw.write(admin.toString());
            bw.newLine();
        } catch (IOException e) {
            System.err.println("Error saving admin: " + e.getMessage());
        }
    }

    // Read all students from the file
    public static List<Student> readStudents() {
        List<Student> students = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(DATA_FILE_PATH))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    Student student = Student.fromString(line);
                    students.add(student);
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading students.txt: " + e.getMessage());
        }
        return students;
    }

    // Read all admins from the file
    public static List<Admin> readAdmins() {
        List<Admin> admins = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(ADMIN_FILE_PATH))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    Admin admin = Admin.fromString(line);
                    admins.add(admin);
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading admin.txt: " + e.getMessage());
        }
        return admins;
    }

    // Delete a student by studentId from the file
    public static boolean deleteStudent(long studentId) {
        List<Student> students = readStudents();
        boolean found = false;
        List<Student> updatedStudents = new ArrayList<>();
        for (Student student : students) {
            if (student.getStudentId() == studentId) {
                found = true; // Mark as found but skip adding to updated list
            } else {
                updatedStudents.add(student); // Keep other students
            }
        }
        if (found) {
            // Overwrite students.txt with the updated list
            try (BufferedWriter bw = new BufferedWriter(new FileWriter(DATA_FILE_PATH))) {
                for (Student student : updatedStudents) {
                    bw.write(student.toString());
                    bw.newLine();
                }
            } catch (IOException e) {
                System.err.println("Error writing to students.txt: " + e.getMessage());
                return false;
            }
        }
        return found;
    }

    // Save the sorted list of students to the file (overwrite the file)
    public static void saveSortedStudents(List<Student> students) {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(DATA_FILE_PATH))) {
            for (Student student : students) {
                bw.write(student.toString());
                bw.newLine();
            }
        } catch (IOException e) {
            System.err.println("Error saving sorted students: " + e.getMessage());
        }
    }
}