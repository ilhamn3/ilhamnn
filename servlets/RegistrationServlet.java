package com.opp.project.servlets;

import com.opp.project.model.Student;
import com.opp.project.service.SortManager;
import com.opp.project.util.FileUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/RegistrationServlet")
public class RegistrationServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve form data from Registration.jsp
        String fullName = request.getParameter("fullname");
        String username = request.getParameter("username");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String dob = request.getParameter("dob");
        String gender = request.getParameter("gender");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Basic validation: Check if passwords match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match.");
            request.getRequestDispatcher("Registration.jsp").forward(request, response);
            return;
        }

        // Check if username is unique
        if (isUsernameTaken(username)) {
            request.setAttribute("errorMessage", "Username already taken.");
            request.getRequestDispatcher("Registration.jsp").forward(request, response);
            return;
        }

        // Check if email is unique
        if (isEmailTaken(email)) {
            request.setAttribute("errorMessage", "Email already taken.");
            request.getRequestDispatcher("Registration.jsp").forward(request, response);
            return;
        }

        // Hash the password
        password = BCrypt.hashpw(password, BCrypt.gensalt());

        // Capture registration time
        LocalDateTime registrationTime = LocalDateTime.now();

        // Generate a unique student ID
        long studentId = generateStudentId();

        // Create a new Student object with the studentId
        Student newStudent = new Student(studentId, fullName, username, phone, email, dob, gender, password, registrationTime);

        // Load existing students from the file
        List<Student> students = FileUtil.readStudents();

        // Add the new student to the list
        students.add(newStudent);

        // Sort students by registration time using Insertion Sort
        SortManager.insertionSortByRegistrationTime(students);

        // Save the sorted list back to the file
        FileUtil.saveSortedStudents(students);

        // Redirect to login page after successful registration
        response.sendRedirect("Login.jsp");
    }

    private boolean isUsernameTaken(String username) {
        try (BufferedReader br = new BufferedReader(new FileReader(FileUtil.DATA_FILE_PATH))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length > 2 && parts[2].equals(username)) {
                    return true; // Username found
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading students.txt: " + e.getMessage());
        }
        return false; // Username not found
    }

    private boolean isEmailTaken(String email) {
        List<Student> students = FileUtil.readStudents();
        for (Student student : students) {
            if (student.getEmail().equals(email)) {
                return true;
            }
        }
        return false;
    }

    private long generateStudentId() {
        List<Student> students = FileUtil.readStudents();
        if (students.isEmpty()) {
            return 1; // Start with ID 1 if no students exist
        }

        long maxId = 0;
        for (Student student : students) {
            if (student.getStudentId() > maxId) {
                maxId = student.getStudentId();
            }
        }
        return maxId + 1;
    }
}