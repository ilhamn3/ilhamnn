package com.opp.project.servlets;

import com.opp.project.util.CourseFileUtil;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.util.List;

@WebServlet("/EditCourseServlet")
public class EditCourseServlet extends HttpServlet {
    private static final int MEMORY_THRESHOLD = 1024 * 1024 * 3; // 3MB
    private static final int MAX_FILE_SIZE = 1024 * 1024 * 40; // 40MB
    private static final int MAX_REQUEST_SIZE = 1024 * 1024 * 50; // 50MB

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if the request is multipart content
        if (!ServletFileUpload.isMultipartContent(request)) {
            response.sendRedirect("Admin-courselist.jsp?errorMessage=Form must have enctype=multipart/form-data");
            return;
        }

        // Configure upload settings
        DiskFileItemFactory factory = new DiskFileItemFactory();
        factory.setSizeThreshold(MEMORY_THRESHOLD);
        factory.setRepository(new File(System.getProperty("java.io.tmpdir")));

        ServletFileUpload upload = new ServletFileUpload(factory);
        upload.setFileSizeMax(MAX_FILE_SIZE);
        upload.setSizeMax(MAX_REQUEST_SIZE);

        String courseId = null;
        String[] newValues = new String[5];
        String imagePath = null;

        try {
            // Parse the multipart form data
            List<FileItem> formItems = upload.parseRequest(request);
            for (FileItem item : formItems) {
                if (item.isFormField()) {
                    // Handle regular form fields
                    String fieldName = item.getFieldName();
                    String fieldValue = item.getString();
                    if ("courseId".equals(fieldName)) {
                        courseId = fieldValue;
                    } else if (fieldName.startsWith("field")) {
                        int index = Integer.parseInt(fieldName.replace("field", ""));
                        newValues[index] = fieldValue;
                    }
                } else {
                    // Handle file upload
                    if ("image".equals(item.getFieldName()) && item.getSize() > 0 && courseId != null) {
                        // Save and rename the image using CourseFileUtil
                        imagePath = CourseFileUtil.saveImageWithFileItem(courseId, item);
                    }
                }
            }

            // Validate required fields
            if (courseId == null || newValues[0] == null) {
                response.sendRedirect("Admin-courselist.jsp?errorMessage=Course ID is required");
                return;
            }

            // Read current courses
            List<String[]> courses = CourseFileUtil.readCourses();
            boolean courseFound = false;
            for (int i = 0; i < courses.size(); i++) {
                if (courses.get(i)[0].equals(courseId)) {
                    String[] updatedCourse = new String[6];
                    System.arraycopy(newValues, 0, updatedCourse, 0, 5);
                    // Use new image path if uploaded, otherwise keep the existing one
                    updatedCourse[5] = (imagePath != null) ? imagePath : courses.get(i)[5];
                    courses.set(i, updatedCourse);
                    courseFound = true;
                    break;
                }
            }

            if (!courseFound) {
                response.sendRedirect("Admin-courselist.jsp?errorMessage=Course not found");
                return;
            }

            // Save updated courses
            CourseFileUtil.writeCourses(courses);
            response.sendRedirect("Admin-courselist.jsp?successMessage=Course updated successfully");
        } catch (Exception e) {
            response.sendRedirect("Admin-courselist.jsp?errorMessage=Error updating course: " + e.getMessage());
            e.printStackTrace(); // Debug output for exceptions
        }
    }
}