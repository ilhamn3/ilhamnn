package com.opp.project.servlets;

import com.opp.project.model.Student;
import com.opp.project.service.SortManager;
import com.opp.project.util.FileUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userIdentifier = (String) session.getAttribute("userIdentifier");

        if (userIdentifier == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        // Retrieve form data
        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String dob = request.getParameter("dob");
        String gender = request.getParameter("gender");

        // Validate inputs
        if (fullName == null || fullName.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty() ||
                dob == null || dob.trim().isEmpty() ||
                gender == null || gender.trim().isEmpty()) {
            request.setAttribute("errorMessage", "All fields are required.");
            request.getRequestDispatcher("Profile.jsp?editMode=true").forward(request, response);
            return;
        }

        // Check if email is unique (excluding current user)
        if (isEmailTaken(email, userIdentifier)) {
            request.setAttribute("errorMessage", "Email is already taken.");
            request.getRequestDispatcher("Profile.jsp?editMode=true").forward(request, response);
            return;
        }

        // Load all students
        List<Student> students = FileUtil.readStudents();
        Student currentUser = null;
        int userIndex = -1;

        // Find the current user
        for (int i = 0; i < students.size(); i++) {
            Student student = students.get(i);
            if (student.getUsername().equals(userIdentifier) || student.getEmail().equals(userIdentifier)) {
                currentUser = student;
                userIndex = i;
                break;
            }
        }

        if (currentUser == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        // Create updated student object (preserve studentId, password, and registrationTime)
        Student updatedStudent = new Student(
                currentUser.getStudentId(),
                fullName,
                username,
                phone,
                email,
                dob,
                gender,
                currentUser.getPassword(),
                currentUser.getRegistrationTime()
        );

        // Update the student list
        students.set(userIndex, updatedStudent);

        // Sort students by registration time
        SortManager.insertionSortByRegistrationTime(students);

        // Save the updated list to students.txt
        FileUtil.saveSortedStudents(students);

        // Update session attributes if email or username changed
        if (!userIdentifier.equals(email) && !userIdentifier.equals(username)) {
            session.setAttribute("userIdentifier", email);
            session.setAttribute("username", username);
        }

        // Redirect to Profile.jsp with success message
        request.setAttribute("successMessage", "Profile updated successfully.");
        request.getRequestDispatcher("Profile.jsp").forward(request, response);
    }

    private boolean isEmailTaken(String email, String userIdentifier) {
        List<Student> students = FileUtil.readStudents();
        for (Student student : students) {
            if (student.getEmail().equals(email) &&
                    !student.getUsername().equals(userIdentifier) &&
                    !student.getEmail().equals(userIdentifier)) {
                return true;
            }
        }
        return false;
    }
}