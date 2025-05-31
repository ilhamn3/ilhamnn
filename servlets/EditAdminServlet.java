package com.opp.project.servlets;

import com.opp.project.util.AdminFileUtil;
import org.mindrot.jbcrypt.BCrypt;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/EditAdminServlet")
public class EditAdminServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String username = request.getParameter("username");
        String email = request.getParameter("email");

        if (id == null || id.trim().isEmpty() ||
                name == null || name.trim().isEmpty() ||
                username == null || username.trim().isEmpty() ||
                email == null || email.trim().isEmpty()) {
            response.sendRedirect("Admin-management.jsp?errorMessage=All fields are required");
            return;
        }

        try {
            if (id.equals("1")) {
                response.sendRedirect("Admin-management.jsp?errorMessage=Admin with ID 1 cannot be edited");
                return;
            }

            List<String[]> admins = AdminFileUtil.readAdmins();
            boolean updated = false;
            for (int i = 0; i < admins.size(); i++) {
                if (admins.get(i)[0].equals(id)) {
                    // Keep the original password or prompt for a new one (for simplicity, we'll keep it unchanged here)
                    String password = admins.get(i)[4];
                    admins.set(i, new String[]{id, name.trim(), username.trim(), email.trim(), password});
                    updated = true;
                    break;
                }
            }

            if (!updated) {
                response.sendRedirect("Admin-management.jsp?errorMessage=Admin not found");
                return;
            }

            AdminFileUtil.writeAdmins(admins);
            response.sendRedirect("Admin-management.jsp?successMessage=Admin with ID " + id + " updated successfully");
        } catch (Exception e) {
            response.sendRedirect("Admin-management.jsp?errorMessage=Error editing admin: " + e.getMessage());
            e.printStackTrace();
        }
    }
}