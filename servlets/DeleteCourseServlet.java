package com.opp.project.servlets;

import com.opp.project.util.CourseFileUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;

@WebServlet("/DeleteCourseServlet")
public class DeleteCourseServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String courseId = request.getParameter("courseId");
        String imagePath = request.getParameter("imagePath");

        if (courseId == null) {
            response.sendRedirect("Admin-courselist.jsp?errorMessage=Course ID is required");
            return;
        }

        try {
            // Read current courses
            java.util.List<String[]> courses = CourseFileUtil.readCourses();
            boolean courseFound = false;

            for (int i = 0; i < courses.size(); i++) {
                if (courses.get(i)[0].equals(courseId)) {
                    courses.remove(i);
                    courseFound = true;
                    break;
                }
            }

            if (!courseFound) {
                response.sendRedirect("Admin-courselist.jsp?errorMessage=Course not found");
                return;
            }

            // Delete the associated image file if it exists
            if (imagePath != null && !imagePath.isEmpty()) {
                String fullImagePath = CourseFileUtil.COURSE_IMG_PATH + File.separator + imagePath.replace("/course_img/", "");
                File imageFile = new File(fullImagePath);
                if (imageFile.exists()) {
                    imageFile.delete();
                }
            }

            // Save updated courses
            CourseFileUtil.writeCourses(courses);
            response.sendRedirect("Admin-courselist.jsp?successMessage=Course deleted successfully");
        } catch (Exception e) {
            response.sendRedirect("Admin-courselist.jsp?errorMessage=Error deleting course: " + e.getMessage());
            e.printStackTrace();
        }
    }
}