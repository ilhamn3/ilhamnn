package com.opp.project.util;

import org.apache.commons.fileupload.FileItem;
import javax.servlet.http.Part;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class CourseFileUtil {
    public static final String USER_HOME = System.getProperty("user.home");
    public static final String APP_DATA_DIR = USER_HOME + File.separator + "Desktop/Project/OPP-Project_P-153/src/main/resources/data";
    public static final String COURSES_FILE_PATH;
    public static final String ENROLLMENTS_FILE_PATH;
    public static final String COURSE_IMG_PATH = USER_HOME + File.separator + "Desktop/Project/OPP-Project_P-153/src/main/webapp/Course_img";

    static {
        File dir = new File(APP_DATA_DIR);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        COURSES_FILE_PATH = APP_DATA_DIR + File.separator + "courses.txt";
        ENROLLMENTS_FILE_PATH = APP_DATA_DIR + File.separator + "enrollments.txt";
    }

    // Read all courses from the file
    public static List<String[]> readCourses() {
        List<String[]> courses = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(COURSES_FILE_PATH))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    String[] courseData = line.split(",");
                    if (courseData.length >= 4) {
                        courses.add(courseData);
                    }
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading courses.txt: " + e.getMessage());
        }
        return courses;
    }

    // Save a single course to the file (append mode)
    public static void saveCourse(String courseId, String courseName, String instructor, String courseCategory,
                                  String introduction, String imagePath) {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(COURSES_FILE_PATH, true))) {
            String courseData = String.format("%s,%s,%s,%s,%s,%s%n",
                    courseId, courseName, instructor, courseCategory, introduction, imagePath);
            bw.write(courseData);
        } catch (IOException e) {
            System.err.println("Error saving course: " + e.getMessage());
        }
    }

    // Write the entire list of courses to the file (overwrite mode)
    public static void writeCourses(List<String[]> courses) {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(COURSES_FILE_PATH))) {
            for (String[] course : courses) {
                if (course.length >= 6) { // Ensure course has all required fields
                    String courseData = String.format("%s,%s,%s,%s,%s,%s%n",
                            course[0], course[1], course[2], course[3], course[4], course[5]);
                    bw.write(courseData);
                }
            }
        } catch (IOException e) {
            System.err.println("Error writing courses to file: " + e.getMessage());
        }
    }

    // Save an image to the images directory (for Part)
    public static String saveImage(String courseId, Part filePart) throws IOException {
        File uploadDir = new File(COURSE_IMG_PATH);
        if (!uploadDir.exists()) {
            if (!uploadDir.mkdirs()) {
                throw new IOException("Failed to create images directory: " + COURSE_IMG_PATH);
            }
        }

        if (!uploadDir.canWrite()) {
            throw new IOException("No write permissions for images directory: " + COURSE_IMG_PATH);
        }

        String fileExtension = getFileExtension(filePart);
        String fileName = courseId + fileExtension;
        String filePath = "/course_img/" + fileName;
        File file = new File(COURSE_IMG_PATH, fileName);

        try (InputStream input = filePart.getInputStream();
             OutputStream output = new FileOutputStream(file)) {
            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = input.read(buffer)) != -1) {
                output.write(buffer, 0, bytesRead);
            }
        } catch (IOException e) {
            throw new IOException("Error saving image: " + e.getMessage());
        }

        return filePath;
    }

    // Save an image to the images directory (for FileItem)
    public static String saveImageWithFileItem(String courseId, FileItem fileItem) throws IOException {
        File uploadDir = new File(COURSE_IMG_PATH);
        if (!uploadDir.exists()) {
            if (!uploadDir.mkdirs()) {
                throw new IOException("Failed to create images directory: " + COURSE_IMG_PATH);
            }
        }

        if (!uploadDir.canWrite()) {
            throw new IOException("No write permissions for images directory: " + COURSE_IMG_PATH);
        }

        String fileExtension = getFileExtensionFromFileItem(fileItem);
        String fileName = courseId + fileExtension;
        String filePath = "/course_img/" + fileName;
        File file = new File(COURSE_IMG_PATH, fileName);

        try (InputStream input = fileItem.getInputStream();
             OutputStream output = new FileOutputStream(file)) {
            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = input.read(buffer)) != -1) {
                output.write(buffer, 0, bytesRead);
            }
        } catch (IOException e) {
            throw new IOException("Error saving image: " + e.getMessage());
        }

        return filePath;
    }

    // Helper method to get file extension from Part
    private static String getFileExtension(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] tokens = contentDisposition.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                String fileName = token.substring(token.indexOf("=") + 2, token.length() - 1);
                return fileName.substring(fileName.lastIndexOf("."));
            }
        }
        return ".png"; // Default to .png if extension not found
    }

    // Helper method to get file extension from FileItem
    private static String getFileExtensionFromFileItem(FileItem fileItem) {
        String fileName = fileItem.getName();
        if (fileName != null && fileName.contains(".")) {
            return fileName.substring(fileName.lastIndexOf("."));
        }
        return ".png"; // Default to .png if extension not found
    }

    // Save a single enrollment to the file
    public static void saveEnrollment(long studentId, String courseId) {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(ENROLLMENTS_FILE_PATH, true))) {
            bw.write(studentId + "," + courseId);
            bw.newLine();
        } catch (IOException e) {
            System.err.println("Error saving enrollment: " + e.getMessage());
        }
    }

    // Read all enrollments from the file
    public static List<String[]> readEnrollments() {
        List<String[]> enrollments = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(ENROLLMENTS_FILE_PATH))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    String[] enrollmentData = line.split(",");
                    if (enrollmentData.length >= 2) {
                        enrollments.add(enrollmentData);
                    }
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading enrollments.txt: " + e.getMessage());
        }
        return enrollments;
    }

    // Check if a student is enrolled in a specific course
    public static boolean isStudentEnrolled(long studentId, String courseId) {
        List<String[]> enrollments = readEnrollments();
        for (String[] enrollment : enrollments) {
            if (enrollment[0].equals(String.valueOf(studentId)) && enrollment[1].equals(courseId)) {
                return true;
            }
        }
        return false;
    }

    // Get all course IDs for a specific student
    public static List<String> getEnrolledCourseIds(long studentId) {
        List<String> courseIds = new ArrayList<>();
        List<String[]> enrollments = readEnrollments();
        for (int i = 0; i < enrollments.size(); i++) {
            String[] enrollment = enrollments.get(i);
            if (enrollment[0].equals(String.valueOf(studentId))) {
                courseIds.add(enrollment[1]);
            }
        }
        return courseIds;
    }
}