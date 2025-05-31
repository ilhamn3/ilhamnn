package com.opp.project.servlets;

import com.opp.project.service.QueueManager;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/ProcessRequestServlet")
public class ProcessRequestServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect("Admin-requestlist.jsp?errorMessage=Invalid action");
            return;
        }

        try {
            switch (action) {
                case "approve":
                    QueueManager.approveFrontRequest();
                    response.sendRedirect("Admin-requestlist.jsp?successMessage=Front request approved successfully");
                    break;
                case "reject":
                    QueueManager.rejectFrontRequest();
                    response.sendRedirect("Admin-requestlist.jsp?successMessage=Front request rejected successfully");
                    break;
                case "delete":
                    QueueManager.deleteFrontRequest();
                    response.sendRedirect("Admin-requestlist.jsp?successMessage=Front request deleted successfully");
                    break;
                default:
                    response.sendRedirect("Admin-requestlist.jsp?errorMessage=Invalid action");
            }
        } catch (Exception e) {
            response.sendRedirect("Admin-requestlist.jsp?errorMessage=Error processing front request: " + e.getMessage());
        }
    }
}