package com.opp.project.servlets;

import com.opp.project.service.QueueManager;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/RequestServlet")
public class RequestServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String studentId = (String) session.getAttribute("studentId");
        String courseId = request.getParameter("courseId");

        if (studentId == null) {
            System.err.println("Failed: No student logged in for courseId: " + courseId);
            response.sendRedirect("Courses.jsp?errorMessage=Please log in to enroll in the course");
            return;
        }
        if (courseId == null || courseId.trim().isEmpty()) {
            System.err.println("Failed: Invalid courseId for studentId: " + studentId);
            response.sendRedirect("Courses.jsp?errorMessage=Invalid course ID. Please try again");
            return;
        }

        try {
            for (String[] req : QueueManager.getQueueState()) {
                if (req[1].equals(studentId) && req[2].equals(courseId) && req[4].equals("pending")) {
                    System.err.println("Failed: Duplicate request for studentId: " + studentId + ", courseId: " + courseId);
                    response.sendRedirect("Courses.jsp?errorMessage=You already have a pending request for course " + courseId);
                    return;
                }
            }

            QueueManager.saveRequest(studentId, courseId, "pending");
            System.err.println("Success: Request submitted for studentId: " + studentId + ", courseId: " + courseId);
            response.sendRedirect("Courses.jsp?successMessage=Successfully submitted request for course " + courseId + ". Awaiting approval");
        } catch (Exception e) {
            System.err.println("Failed: Error submitting request for studentId: " + studentId + ", courseId: " + courseId + ": " + e.getMessage());
            response.sendRedirect("Courses.jsp?errorMessage=Failed to submit request for course " + courseId + ": " + e.getMessage());
        }
    }
}