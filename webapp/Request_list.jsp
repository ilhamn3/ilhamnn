<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.opp.project.service.QueueManager" %>
<%@ page import="com.opp.project.util.CourseFileUtil" %>
<%@ page import="com.opp.project.util.FileUtil" %>
<%@ page import="com.opp.project.model.Student" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Course Web - My Requests</title>
    <link rel="icon" type="image/x-icon" href="<%=request.getContextPath()%>/img/logo.ico">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/navbarandfooter.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/requesttable.css">
</head>
<body>
<main>
    <%@ include file="navbar.jsp" %>

    <%
        // Check if the user is logged in
        String loginId = (String) session.getAttribute("username");
        if (loginId == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        // Map loginId (username) to studentId using students.txt
        String studentId = null;
        List<Student> students = FileUtil.readStudents();
        for (Student student : students) {
            if (student.getUsername().equals(loginId)) {
                studentId = String.valueOf(student.getStudentId());
                break;
            }
        }
        if (studentId == null) {
            studentId = loginId; // Fallback if no mapping found
        }

        // Fetch course details to map courseId to course name and instructor
        Map<String, String[]> courseDetails = new HashMap<>();
        try {
            List<String[]> courses = CourseFileUtil.readCourses();
            for (String[] course : courses) {
                courseDetails.put(course[0], new String[]{course[1], course[2]});
            }
        } catch (Exception e) {
            // Error handling without logging
        }
    %>
    <div class="card custom-card">
        <div class="card-body">
            <table class="custom-table">
                <thead>
                <tr>
                    <th>Course ID</th>
                    <th>Course Name</th>
                    <th>Instructor Name</th>
                    <th>Requested Date</th>
                    <th>Status</th>
                </tr>
                </thead>
                <tbody>
                <%
                    List<String[]> requests = QueueManager.getQueueState();
                    boolean hasRequests = false;
                    for (String[] req : requests) {
                        try {
                            String reqStudentId = req[1];
                            String status = req[4];
                            if (studentId != null && reqStudentId != null && reqStudentId.equals(studentId) && status.equals("pending")) {
                                hasRequests = true;
                                String courseId = req[2];
                                String timestamp = req[3];
                                String[] courseInfo = courseDetails.getOrDefault(courseId, new String[]{"Unknown Course", "Unknown Instructor"});
                                String courseName = courseInfo[0];
                                String instructorName = courseInfo[1];
                %>
                <tr>
                    <td><%= courseId %></td>
                    <td><%= courseName %></td>
                    <td><%= instructorName %></td>
                    <td><%= timestamp %></td>
                    <td>
                        <span class="badge bg-warning-subtle text-warning">Pending</span>
                    </td>
                </tr>
                <%
                            }
                        } catch (Exception e) {
                            // Error handling without logging
                        }
                    }
                    if (!hasRequests) {
                %>
                <tr>
                    <td colspan="5" class="text-center">No pending requests found.</td>
                </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
</main>
<%@ include file="footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>
<script src="<%=request.getContextPath()%>/js/dropdown-position.js"></script>
</body>
</html>