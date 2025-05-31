package com.opp.project.servlets;

import com.opp.project.util.AnnouncementFileUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/AddAnnouncementServlet")
public class AddAnnouncementServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String date = request.getParameter("date");

        if (title == null || title.trim().isEmpty() || content == null || content.trim().isEmpty() || date == null || date.trim().isEmpty()) {
            response.sendRedirect("Admin-announcement.jsp?errorMessage=All fields are required");
            return;
        }

        try {
            // Save the new announcement
            AnnouncementFileUtil.saveAnnouncement(title.trim(), content.trim(), date.trim());
            response.sendRedirect("Admin-announcement.jsp?successMessage=Announcement added successfully");
        } catch (Exception e) {
            response.sendRedirect("Admin-announcement.jsp?errorMessage=Error adding announcement: " + e.getMessage());
            e.printStackTrace();
        }
    }
}