package com.opp.project.servlets;

import com.opp.project.util.AnnouncementFileUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/DeleteAnnouncementServlet")
public class DeleteAnnouncementServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String indexStr = request.getParameter("index");

        if (indexStr == null || indexStr.trim().isEmpty()) {
            response.sendRedirect("Admin-announcement.jsp?errorMessage=Invalid announcement index");
            return;
        }

        try {
            int index = Integer.parseInt(indexStr);
            List<String[]> announcements = AnnouncementFileUtil.readAnnouncements();

            if (index < 0 || index >= announcements.size()) {
                response.sendRedirect("Admin-announcement.jsp?errorMessage=Announcement not found");
                return;
            }

            // Remove the announcement at the specified index
            announcements.remove(index);
            AnnouncementFileUtil.writeAnnouncements(announcements);
            response.sendRedirect("Admin-announcement.jsp?successMessage=Announcement deleted successfully");
        } catch (NumberFormatException e) {
            response.sendRedirect("Admin-announcement.jsp?errorMessage=Invalid announcement index");
        } catch (Exception e) {
            response.sendRedirect("Admin-announcement.jsp?errorMessage=Error deleting announcement: " + e.getMessage());
            e.printStackTrace();
        }
    }
}