<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.opp.project.model.Student" %>
<%@ page import="com.opp.project.util.FileUtil" %>
<%@ page import="java.util.List" %>
<%@ page import="java.io.IOException" %>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <div class="container-fluid">
    <!-- Logo and Name -->
    <a class="navbar-brand" href="<%=request.getContextPath()%>/Dashboard.jsp">
      <img src="<%=request.getContextPath()%>/img/logo.png" alt="Course Web Logo" class="me-2">
      <span>Course Web</span>
    </a>

    <!-- Toggle button for mobile view -->
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>

    <!-- Navigation Links -->
    <div class="collapse navbar-collapse justify-content-center" id="navbarNav">
      <ul class="navbar-nav">
        <li class="nav-item">
          <a class="nav-link active" href="<%=request.getContextPath()%>/Dashboard.jsp">Dashboard</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="<%=request.getContextPath()%>/Courses.jsp">Courses</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="<%=request.getContextPath()%>/contactform.jsp">Contact Us</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="<%=request.getContextPath()%>/Request_list.jsp">My Requests</a>
        </li>
      </ul>
    </div>

    <!-- User Avatar and Name with Dropdown -->
    <%
      // Initialize defaults
      String avatarImage = request.getContextPath() + "/img/other.png"; // Default avatar
      String fullName = "Guest";
      String role = "Student";

      try {
        // Check if the user is logged in
        String userIdentifier = (String) session.getAttribute("userIdentifier");
        String username = (String) session.getAttribute("username");
        String loginId = userIdentifier != null ? userIdentifier : username;


        if (loginId != null) {
          // Retrieve the logged-in user's data
          List<Student> students = FileUtil.readStudents();
          for (Student student : students) {
            if (student.getUsername().equals(loginId) || student.getEmail().equals(loginId)) {
              fullName = student.getFullName();
              String gender = student.getGender();
              if ("Male".equalsIgnoreCase(gender)) {
                avatarImage = request.getContextPath() + "/img/male.png";
              } else if ("Female".equalsIgnoreCase(gender)) {
                avatarImage = request.getContextPath() + "/img/female.png";
              } else {
                avatarImage = request.getContextPath() + "/img/other.png";
              }
              break;
            }
          }
        }
      } catch (Exception e) {
        System.err.println("Error in navbar.jsp: " + e.getMessage());
        e.printStackTrace();
        // Fallback to default avatar and name
        avatarImage = request.getContextPath() + "/img/other.png";
        fullName = "Guest";
      }
    %>
    <div class="dropdown">
      <a class="dropdown-toggle d-flex align-items-center" href="#" role="button" id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
        <div class="text-white me-2">
          <span class="username-truncate"><%= fullName %></span>
          <small class="d-block"><%= role %></small>
        </div>
        <img src="<%= avatarImage %>" alt="User Avatar" class="rounded-circle" width="40" height="40">
      </a>
      <ul class="dropdown-menu" aria-labelledby="userDropdown">
        <li><a class="dropdown-item" href="<%=request.getContextPath()%>/Profile.jsp"><i class="bi bi-person"></i> Edit Profile</a></li>
        <li><a class="dropdown-item" href="<%=request.getContextPath()%>/Request_list.jsp"><i class="bi bi-card-checklist"></i> My Request</a></li>
        <li><a class="dropdown-item" href="<%=request.getContextPath()%>/contactform.jsp"><i class="bi bi-headset"></i> Help&Support</a></li>
        <hr>
        <li><a class="dropdown-item" href="<%=request.getContextPath()%>/LogoutServlet"><i class="bi bi-box-arrow-right"></i> Logout</a></li>
      </ul>
    </div>
  </div>
</nav>