<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.opp.project.model.Student" %>
<%@ page import="com.opp.project.model.Admin" %>
<%@ page import="com.opp.project.util.FileUtil" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Course Web - Edit User</title>
  <link rel="icon" type="image/x-icon" href="img/logo.ico">
  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Bootstrap Icons CDN -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
  <!-- Custom CSS -->
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin-navbar.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/profile.css">
</head>
<body>
<main>
  <%@ include file="Admin-navbar.jsp" %>
  <%
    // Check if the user is logged in and is an admin
    String loginId = (String) session.getAttribute("username");
    Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
    if (loginId == null || isAdmin == null || !isAdmin) {
      response.sendRedirect("Login.jsp");
      return;
    }

    // Retrieve the logged-in admin's data
    Admin currentAdmin = null;
    List<Admin> admins = FileUtil.readAdmins();
    for (Admin admin : admins) {
      if (admin.getUsername().equals(loginId) || admin.getEmail().equals(loginId)) {
        currentAdmin = admin;
        break;
      }
    }

    // If admin not found, redirect to login
    if (currentAdmin == null) {
      response.sendRedirect("Login.jsp");
      return;
    }

    // Get studentId from query parameter
    String studentIdStr = request.getParameter("studentId");
    Student currentStudent = null;
    if (studentIdStr != null) {
      try {
        long studentId = Long.parseLong(studentIdStr);
        List<Student> students = FileUtil.readStudents();
        for (Student student : students) {
          if (student.getStudentId() == studentId) {
            currentStudent = student;
            break;
          }
        }
      } catch (NumberFormatException e) {
        request.setAttribute("errorMessage", "Invalid Student ID.");
      }
    }

    // If student not found or no studentId, redirect to student list
    if (currentStudent == null) {
      request.setAttribute("errorMessage", "Student not found or invalid Student ID.");
      response.sendRedirect("Admin-studentlist.jsp");
      return;
    }

    // Get success or error message
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");

    // Determine avatar image based on gender
    String gender = currentStudent.getGender();
    String avatarImage;
    if ("Male".equalsIgnoreCase(gender)) {
      avatarImage = "./img/male.png";
    } else if ("Female".equalsIgnoreCase(gender)) {
      avatarImage = "./img/female.png";
    } else {
      avatarImage = "./img/other.png";
    }
  %>

  <!-- Edit User Content -->
  <div class="container">
    <div class="profile-card">
      <div class="avatar">
        <img src="<%= avatarImage %>" alt="Student Avatar">
      </div>
      <div class="name"><%= currentStudent.getFullName() %></div>
      <div class="role">Student</div>

      <div class="details">
        <h3>Edit User Details</h3>
        <hr>
        <% if (successMessage != null) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
          <%= successMessage %>
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <% } %>
        <% if (errorMessage != null) { %>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
          <%= errorMessage %>
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <% } %>
        <form action="<%=request.getContextPath()%>/UpdateStudentServlet" method="post">
          <input type="hidden" name="studentId" value="<%= currentStudent.getStudentId() %>">
          <p>
            <strong>Name:</strong>
            <input type="text" name="fullName" value="<%= currentStudent.getFullName() %>" required>
          </p>
          <p>
            <strong>Username:</strong>
            <input type="text" name="username" value="<%= currentStudent.getUsername() %>" readonly>
          </p>
          <p>
            <strong>Email:</strong>
            <input type="email" name="email" value="<%= currentStudent.getEmail() %>" required>
          </p>
          <p>
            <strong>Phone:</strong>
            <input type="text" name="phone" value="<%= currentStudent.getPhone() %>" required>
          </p>
          <p>
            <strong>Date of Birth:</strong>
            <input type="date" name="dob" value="<%= currentStudent.getDob() %>" required>
          </p>
          <p>
            <strong>Gender:</strong>
            <select name="gender" required>
              <option value="Male" <%= "Male".equals(currentStudent.getGender()) ? "selected" : "" %>>Male</option>
              <option value="Female" <%= "Female".equals(currentStudent.getGender()) ? "selected" : "" %>>Female</option>
              <option value="Other" <%= "Other".equals(currentStudent.getGender()) ? "selected" : "" %>>Other</option>
            </select>
          </p>
          <p>
            <strong>New Password (optional):</strong>
            <input type="password" name="password" placeholder="Enter new password">
          </p>
          <div class="buttons">
            <button type="submit" class="button edit"><i class="bi bi-save"></i> Save</button>
            <a href="<%=request.getContextPath()%>/Admin-studentlist.jsp" class="button delete"><i class="bi bi-x-square"></i> Cancel</a>
          </div>
        </form>
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

<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>
<script src="js/dropdown-position.js"></script>
<script>
  // Automatically hide alerts after 5 seconds
  document.addEventListener('DOMContentLoaded', function () {
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
      setTimeout(() => {
        alert.classList.remove('show');
        alert.classList.add('fade');
        setTimeout(() => {
          alert.remove();
        }, 150);
      }, 5000);
    });
  });
</script>
</body>
</html>