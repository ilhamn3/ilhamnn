package com.opp.project.servlets;

import com.opp.project.util.AdminFileUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/DeleteAdminServlet")
public class DeleteAdminServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");

        if (id == null || id.trim().isEmpty()) {
            response.sendRedirect("Admin-management.jsp?errorMessage=Invalid admin ID");
            return;
        }

        try {
            if (id.equals("1")) {
                response.sendRedirect("Admin-management.jsp?errorMessage=Admin with ID 1 cannot be deleted");
                return;
            }

            List<String[]> admins = AdminFileUtil.readAdmins();
            boolean removed = false;
            for (int i = 0; i < admins.size(); i++) {
                if (admins.get(i)[0].equals(id)) {
                    admins.remove(i);
                    removed = true;
                    break;
                }
            }

            if (!removed) {
                response.sendRedirect("Admin-management.jsp?errorMessage=Admin not found");
                return;
            }

            AdminFileUtil.writeAdmins(admins);
            response.sendRedirect("Admin-management.jsp?successMessage=Admin with ID " + id + " deleted successfully");
        } catch (Exception e) {
            response.sendRedirect("Admin-management.jsp?errorMessage=Error deleting admin: " + e.getMessage());
            e.printStackTrace();
        }
    }
}