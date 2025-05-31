package com.opp.project.servlets;

import com.opp.project.model.Student;
import com.opp.project.service.SortManager;
import com.opp.project.util.FileUtil;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/UpdateStudentServlet")
public class UpdateStudentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if admin is logged in
        String loginId = (String) request.getSession().getAttribute("username");
        Boolean isAdmin = (Boolean) request.getSession().getAttribute("isAdmin");
        if (loginId == null || isAdmin == null || !isAdmin) {
            response.sendRedirect("Login.jsp");
            return;
        }

        // Retrieve form data
        String studentIdStr = request.getParameter("studentId");
        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String dob = request.getParameter("dob");
        String gender = request.getParameter("gender");
        String newPassword = request.getParameter("password");

        // Validate inputs
        if (studentIdStr == null || fullName == null || fullName.trim().isEmpty() ||
                email == null || email.trim().isEmpty() || phone == null || phone.trim().isEmpty() ||
                dob == null || dob.trim().isEmpty() || gender == null || gender.trim().isEmpty()) {
            request.setAttribute("errorMessage", "All required fields must be filled.");
            request.getRequestDispatcher("Admin-useredit.jsp?studentId=" + studentIdStr).forward(request, response);
            return;
        }

        long studentId;
        try {
            studentId = Long.parseLong(studentIdStr);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid Student ID.");
            request.getRequestDispatcher("Admin-useredit.jsp?studentId=" + studentIdStr).forward(request, response);
            return;
        }

        // Check if email is unique (excluding current student)
        if (isEmailTaken(email, studentId)) {
            request.setAttribute("errorMessage", "Email is already taken by another user.");
            request.getRequestDispatcher("Admin-useredit.jsp?studentId=" + studentIdStr).forward(request, response);
            return;
        }

        // Load all students
        List<Student> students = FileUtil.readStudents();
        Student currentStudent = null;
        int userIndex = -1;
        for (int i = 0; i < students.size(); i++) {
            Student student = students.get(i);
            if (student.getStudentId() == studentId) {
                currentStudent = student;
                userIndex = i;
                break;
            }
        }

        if (currentStudent == null) {
            request.setAttribute("errorMessage", "Student not found.");
            response.sendRedirect("Admin-studentlist.jsp");
            return;
        }

        // Handle password (use existing if newPassword is empty)
        String password = currentStudent.getPassword();
        if (newPassword != null && !newPassword.trim().isEmpty()) {
            password = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        }

        // Create updated student object
        Student updatedStudent = new Student(
                studentId,
                fullName,
                username,
                phone,
                email,
                dob,
                gender,
                password,
                currentStudent.getRegistrationTime()
        );

        // Update the student list
        students.set(userIndex, updatedStudent);

        // Sort students by registration time
        SortManager.insertionSortByRegistrationTime(students);

        // Save the updated list to students.txt
        FileUtil.saveSortedStudents(students);

        // Redirect to student list with success message
        request.setAttribute("successMessage", "Student updated successfully.");
        response.sendRedirect("Admin-studentlist.jsp");
    }

    private boolean isEmailTaken(String email, long studentId) {
        List<Student> students = FileUtil.readStudents();
        for (Student student : students) {
            if (student.getEmail().equals(email) && student.getStudentId() != studentId) {
                return true;
            }
        }
        return false;
    }
}