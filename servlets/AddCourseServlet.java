package com.opp.project.servlets;

import com.opp.project.util.CourseFileUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.IOException;

@WebServlet("/AddCourseServlet")
// Configure multipart form data handling
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 15)    // 15MB
public class AddCourseServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is admin
        Boolean isAdmin = (Boolean) request.getSession().getAttribute("isAdmin");
        if (isAdmin == null || !isAdmin) {
            response.sendRedirect("Login.jsp");
            return;
        }

        // Get form parameters
        String courseId = request.getParameter("courseId");
        String courseName = request.getParameter("courseName");
        String instructor = request.getParameter("instructor");
        String courseCategory = request.getParameter("courseCategory");
        String introduction = request.getParameter("introduction");

        // Validate required fields
        if (courseId == null || courseId.trim().isEmpty() ||
                courseName == null || courseName.trim().isEmpty() ||
                instructor == null || instructor.trim().isEmpty() ||
                courseCategory == null || courseCategory.trim().isEmpty() ||
                introduction == null || introduction.trim().isEmpty()) {
            request.setAttribute("errorMessage", "All fields are required.");
            request.getRequestDispatcher("Admin-addcourse.jsp").forward(request, response);
            return;
        }

        // Get uploaded file
        Part filePart = request.getPart("fileInput");
        if (filePart == null || filePart.getSize() == 0) {
            request.setAttribute("errorMessage", "Please upload an image. Ensure the file is selected and form is submitted correctly.");
            request.getRequestDispatcher("Admin-addcourse.jsp").forward(request, response);
            return;
        }

        // Validate file type
        String contentType = filePart.getContentType();
        if (!contentType.startsWith("image/") ||
                !contentType.equals("image/jpeg") && !contentType.equals("image/png") && !contentType.equals("image/jpg")) {
            request.setAttribute("errorMessage", "Please upload only JPEG, JPG, or PNG files.");
            request.getRequestDispatcher("Admin-addcourse.jsp").forward(request, response);
            return;
        }

        // Check for duplicate Course ID
        if (CourseFileUtil.readCourses().stream().anyMatch(course -> course.length > 0 && course[0].trim().equals(courseId))) {
            request.setAttribute("errorMessage", "Course ID '" + courseId + "' already exists. Please use a unique ID.");
            request.getRequestDispatcher("Admin-addcourse.jsp").forward(request, response);
            return;
        }

        // Save image using CourseFileUtil
        String imagePath;
        try {
            imagePath = CourseFileUtil.saveImage(courseId, filePart);
        } catch (IOException e) {
            request.setAttribute("errorMessage", "Error saving image: " + e.getMessage());
            request.getRequestDispatcher("Admin-addcourse.jsp").forward(request, response);
            return;
        }

        // Save course data using CourseFileUtil
        try {
            CourseFileUtil.saveCourse(courseId, courseName, instructor, courseCategory, introduction, imagePath);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error saving course data: " + e.getMessage());
            request.getRequestDispatcher("Admin-addcourse.jsp").forward(request, response);
            return;
        }

        // Redirect to success page
        response.sendRedirect("Admin-addcourse.jsp?success=true");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("Admin-addcourse.jsp");
    }
}