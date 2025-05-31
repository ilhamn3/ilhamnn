package com.opp.project.servlets;

import com.opp.project.util.FileUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/DeleteStudentServlet")
public class DeleteStudentServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get studentId from query parameter
        String studentIdStr = request.getParameter("studentId");
        try {
            long studentId = Long.parseLong(studentIdStr);
            // Delete the student from students.txt
            boolean deleted = FileUtil.deleteStudent(studentId);
            if (deleted) {
                // Redirect back to the student list
                response.sendRedirect("Admin-studentlist.jsp");
            } else {
                // If student not found, redirect with error message
                request.setAttribute("errorMessage", "Student with ID " + studentId + " not found.");
                request.getRequestDispatcher("Admin-studentlist.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            // Handle invalid studentId format
            request.setAttribute("errorMessage", "Invalid Student ID format.");
            request.getRequestDispatcher("Admin-studentlist.jsp").forward(request, response);
        }
    }
}