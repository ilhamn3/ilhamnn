<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.opp.project.model.Admin" %>
<%@ page import="com.opp.project.util.CourseFileUtil" %>
<%@ page import="com.opp.project.util.AnnouncementFileUtil" %>
<%@ page import="com.opp.project.util.FileUtil" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.opp.project.model.Student" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Course Web - Admin Dashboard</title>
    <link rel="icon" type="image/x-icon" href="img/logo.ico">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Combined CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>css/admin-dashboard.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>css/admin-navbar.css">
</head>
<body>
<%@ include file="Admin-navbar.jsp"%>
<main>
    <%
        // Check if the user is logged in and is an admin
        String loginId = (String) session.getAttribute("username");
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (loginId == null || isAdmin == null || !isAdmin) {
            response.sendRedirect("Login.jsp");
            return;
        }

        // Retrieve the logged-in admin's data
        Admin currentUser = null;
        List<Admin> admins = FileUtil.readAdmins();
        for (Admin admin : admins) {
            if (admin.getUsername().equals(loginId) || admin.getEmail().equals(loginId)) {
                currentUser = admin;
                break;
            }
        }

        // If admin not found, redirect to login
        if (currentUser == null) {
            response.sendRedirect("Login.jsp");
            return;
        }
    %>
    <div class="container">
        <h2>Welcome to the Admin Dashboard</h2>
        <div class="admin-dashboard">
            <div class="management-section animate-section">
                <h3>Admin Stats</h3>
                <hr>
                <div class="management-cards single-row">
                    <div class="management-card stat-card stat1">
<%--                        <i class="fas fa-users"></i>--%>
                            <%
                                List<Student> students = FileUtil.readStudents();
                                int usercount = students.size();
                            %>
                        <div class="stat-value"><%=usercount%></div>
                        <p>Total Users</p>
                    </div>
                    <div class="management-card stat-card stat2">
<%--                        <i class="fas fa-book"></i>--%>
                        <%
                            List<String[]> courses = CourseFileUtil.readCourses();
                            int count = courses.size();
                        %>
                        <div class="stat-value"><%=count%></div>
                        <p>Total Courses</p>
                    </div>
                    <div class="management-card stat-card stat3">
<%--                        <i class="fas fa-file-alt"></i>--%>
                        <div class="stat-value">5</div>
                        <p>Pending Requests</p>
                    </div>
                </div>
                <h3>Management Overview</h3>
                <hr>
                <div class="management-cards single-row">
                    <div class="management-card">
                        <i class="fas fa-users"></i>
                        <h4>Manage Users</h4>
                        <p>View and manage all registered users.</p>
                        <a href="<%=request.getContextPath()%>/Admin-useredit.jsp" class="btn">View Users</a>
                    </div>
                    <div class="management-card">
                        <i class="fas fa-file-alt"></i>
                        <h4>Manage Requests</h4>
                        <p>Review and approve user requests.</p>
                        <a href="<%=request.getContextPath()%>/Admin-requestlist.jsp" class="btn">View Requests</a>
                    </div>
                    <div class="management-card">
                        <i class="fas fa-book"></i>
                        <h4>Manage Courses</h4>
                        <p>Add or edit courses in the system.</p>
                        <a href="<%=request.getContextPath()%>/Admin-courselist.jsp" class="btn">View Courses</a>
                    </div>
                    <div class="management-card">
                        <i class="fa-solid fa-user-tie"></i>
                        <h4>Manage Admins</h4>
                        <p>View and manage <br>all Admin.</p>
                        <a href="<%=request.getContextPath()%>/Admin-management.jsp" class="btn">View Admins</a>
                    </div>
                    <div class="management-card">
                        <i class="fas fa-bullhorn"></i>
                        <h4>Add Announcement</h4>
                        <p>Create a new announcement for users.</p>
                        <a href="<%=request.getContextPath()%>/Admin-announcement.jsp" class="btn">Add Announcement</a>
                    </div>
                    <div class="management-card">
                        <i class="fa-solid fa-book-medical"></i>
                        <h4>Add Courses</h4>
                        <p>Create a new Course.<br>.</p>
                        <a href="<%=request.getContextPath()%>/Admin-addcourse.jsp" class="btn">Add Course</a>
                    </div>
                </div>
                <div class="announcements-section">
                    <h3><img src="./img/communication.png" alt="icon" width="40px" height="40px"> Announcements</h3>
                    <hr>
                    <div class="announcement-carousel">
                        <%
                            java.util.List<String[]> announcements = AnnouncementFileUtil.readAnnouncements();
                            for (String[] announcement : announcements) {
                        %>
                        <div class="announcement">
                            <h5 class="card-title"><%= announcement[0] %></h5>
                            <p class="card-text"><%= announcement[1] %></p>
                            <p class="card-text"><small class="text-muted">Date: <%= announcement[2] %></small></p>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
            <div class="sidebar-section animate-section">
                <div class="calendar-card">
                    <h3>Calendar</h3>
                    <div class="google-calendar">
                        <iframe
                                src="https://calendar.google.com/calendar/embed?height=600&wkst=2&ctz=Asia%2FColombo&showPrint=0&showTitle=0&showNav=0&showTz=0&showTabs=0&src=ZW4ubGsjaG9saWRheUBncm91cC52LmNhbGVuZGFyLmdvb2dsZS5jb20&color=%230B8043"
                                frameborder="0"
                                scrolling="no">
                        </iframe>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>
<footer>
    <div class="footer-content">
        <p>© 2025 Admin Panel. All rights reserved.</p>
        <p><a href="#">Privacy Policy</a> | <a href="#">Terms of Service</a> | <a href="#">Contact Us</a></p>
    </div>
</footer>
<!-- Bootstrap JS and Popper.js -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>
<!-- Font Awesome for icons -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/js/all.min.js"></script>
<script src="js/admin.js"></script>
<script src="js/dropdown-position.js"></script>

</body>
</html>