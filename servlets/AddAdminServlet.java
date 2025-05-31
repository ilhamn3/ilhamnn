package com.opp.project.servlets;

import com.opp.project.util.AdminFileUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/AddAdminServlet")
public class AddAdminServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("newAdminName");
        String username = request.getParameter("newAdminUsername");
        String email = request.getParameter("newAdminEmail");
        String password = request.getParameter("newAdminPassword");

        if (name == null || name.trim().isEmpty() ||
                username == null || username.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
            response.sendRedirect("Admin-management.jsp?errorMessage=All fields are required");
            return;
        }

        try {
            // Check if username already exists
            for (String[] admin : AdminFileUtil.readAdmins()) {
                if (admin[2].equals(username)) {
                    response.sendRedirect("Admin-management.jsp?errorMessage=Username already exists");
                    return;
                }
            }

            // Save the new admin with auto-generated ID and hashed password
            AdminFileUtil.saveAdmin(name.trim(), username.trim(), email.trim(), password.trim());
            response.sendRedirect("Admin-management.jsp?successMessage=Admin added successfully with ID " + AdminFileUtil.getNextAdminId());
        } catch (Exception e) {
            response.sendRedirect("Admin-management.jsp?errorMessage=Error adding admin: " + e.getMessage());
            e.printStackTrace();
        }
    }
}