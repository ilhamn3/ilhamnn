package com.opp.project.servlets;

import com.opp.project.util.ContactFileUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/DeleteContactServlet")
public class DeleteContactServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String indexStr = request.getParameter("index");

        if (indexStr == null || indexStr.trim().isEmpty()) {
            response.sendRedirect("Admin-contactus.jsp?errorMessage=Invalid contact index");
            return;
        }

        try {
            int index = Integer.parseInt(indexStr);
            List<String[]> contacts = ContactFileUtil.readContacts();

            if (index < 0 || index >= contacts.size()) {
                response.sendRedirect("Admin-contactus.jsp?errorMessage=Contact not found");
                return;
            }

            // Remove the contact at the specified index
            contacts.remove(index);
            ContactFileUtil.writeContacts(contacts);
            response.sendRedirect("Admin-contactus.jsp?successMessage=Contact deleted successfully");
        } catch (NumberFormatException e) {
            response.sendRedirect("Admin-contactus.jsp?errorMessage=Invalid contact index");
        } catch (Exception e) {
            response.sendRedirect("Admin-contactus.jsp?errorMessage=Error deleting contact: " + e.getMessage());
            e.printStackTrace();
        }
    }
}