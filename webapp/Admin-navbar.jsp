<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.opp.project.model.Admin" %>
<%@ page import="com.opp.project.util.FileUtil" %>
<%@ page import="java.util.List" %>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <!-- Logo and Name -->
        <a class="navbar-brand" href="<%=request.getContextPath()%>/Admin-dashboard.jsp">
            <img src="img/logo.png" alt="Course Web Logo" class="me-2" width="30" height="30">
            <span>Course Web Admin</span>
        </a>

        <!-- Toggle button for mobile view -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- Navigation Links -->
        <div class="collapse navbar-collapse justify-content-center" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link active" href="<%=request.getContextPath()%>/Admin-dashboard.jsp">Dashboard</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%=request.getContextPath()%>/Admin-studentlist.jsp">Users</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%=request.getContextPath()%>/Admin-requestlist.jsp">Requests</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%=request.getContextPath()%>/Admin-addcourse.jsp">Add Course</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%=request.getContextPath()%>/Admin-courselist.jsp">Course List</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%=request.getContextPath()%>/Admin-announcement.jsp">Add Announcement</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%=request.getContextPath()%>/Admin-management.jsp">Add New Admin</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%=request.getContextPath()%>/Admin-contactus.jsp">Contact US</a>
                </li>
            </ul>
        </div>

        <!-- User Avatar and Name with Dropdown -->
        <%
            // Initialize defaults
            String fullName = "Admin";
            String role = "Admin";

            try {
                // Check if the user is logged in
                String userIdentifier = (String) session.getAttribute("userIdentifier");
                String username = (String) session.getAttribute("username");
                String loginId = userIdentifier != null ? userIdentifier : username;


                if (loginId != null) {
                    // Retrieve the logged-in user's data
                    List<Admin> Admin = FileUtil.readAdmins();
                    for (Admin admin : Admin) {
                        if (admin.getUsername().equals(loginId) || admin.getEmail().equals(loginId)) {
                            fullName = admin.getName();
                        }
                    }
                }
            } catch (Exception e) {
                System.err.println("Error in Admin-navbar.jsp: " + e.getMessage());
                e.printStackTrace();
                // Fallback to default avatar and name
                fullName = "Admin";
            }
        %>
        <!-- User Avatar and Name with Dropdown -->
        <div class="dropdown">
            <a class="dropdown-toggle d-flex align-items-center text-decoration-none" href="#" role="button" id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                <div class="text-white me-2">
                    <span class="username-truncate"><%=fullName%></span>
                    <small class="d-block"><%=role%></small>
                </div>
                <img src="<%=request.getContextPath()%>/img/admin.png" alt="User Avatar" class="rounded-circle" width="40" height="40">
            </a>
            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                <li><a class="dropdown-item" href="<%=request.getContextPath()%>/LogoutServlet"><i class="bi bi-box-arrow-right"></i> Logout</a></li>
            </ul>
        </div>
    </div>
</nav>