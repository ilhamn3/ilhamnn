<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="com.opp.project.model.Student" %>
<%@ page import="com.opp.project.model.Admin" %>
<%@ page import="com.opp.project.util.FileUtil" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Course Web - User List</title>
  <link rel="icon" type="image/x-icon" href="img/logo.ico">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin-studentlist.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin-navbar.css">
  <!-- Font Awesome CDN -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
  <!-- Bootstrap Icons CDN -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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

    // Retrieve all students
    List<Student> students = FileUtil.readStudents();
  %>
  <div class="container">
    <h2>User List</h2>
    <div class="search-container">
      <div class="search-bar">
        <i class="fas fa-search"></i>
        <input type="text" id="searchInput" placeholder="Search users...">
        <i class="bi bi-search"></i>
      </div>
    </div>
    <table id="studentTable">
      <thead>
      <tr>
        <th>Student ID</th>
        <th>Student Name</th>
        <th>Email</th>
        <th>Actions</th>
      </tr>
      </thead>
      <tbody>
      <%
        if (students.isEmpty()) {
      %>
      <tr>
        <td colspan="4">No students found.</td>
      </tr>
      <%
      } else {
        for (Student student : students) {
      %>
      <tr>
        <td><%= student.getStudentId() %></td>
        <td><%= student.getFullName() %></td>
        <td><%= student.getEmail() %></td>
        <td class="actions">
          <a href="<%=request.getContextPath()%>/Admin-useredit.jsp?studentId=<%= student.getStudentId() %>" class="edit-btn btn btn-primary btn-sm"><i class="bi bi-pencil-square"></i> Edit</a>
          <button class="delete-btn btn btn-danger btn-sm" onclick="confirmDelete(<%= student.getStudentId() %>, '<%= student.getFullName() %>')"><i class="fa-solid fa-trash-xmark"></i> Delete</button>
        </td>
      </tr>
      <%
          }
        }
      %>
      </tbody>
    </table>
  </div>
</main>

<footer>
  <div class="footer-content">
    <p>© 2025 Admin Panel. All rights reserved.</p>
    <div class="footer-links">
      <a href="#"><i class="fas fa-shield-alt"></i> Privacy Policy</a>
      <a href="#"><i class="fas fa-file-contract"></i> Terms of Service</a>
      <a href="#"><i class="fas fa-envelope"></i> Contact Us</a>
    </div>
  </div>
</footer>
<!-- Bootstrap JS and Popper.js -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>
<!-- Font Awesome for icons -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/js/all.min.js"></script>
<script src="js/admin.js"></script>
<script src="js/dropdown-position.js"></script>
<script>
  // Logout function
  function logout() {
    alert('Logout functionality to be implemented.');
  }

  // Hamburger menu toggle
  const hamburger = document.querySelector('.hamburger');
  const navUl = document.querySelector('nav ul');
  if (hamburger && navUl) {
    hamburger.addEventListener('click', () => {
      navUl.classList.toggle('active');
    });
  }

  // Search bar functionality
  const searchInput = document.getElementById('searchInput');
  const studentTable = document.getElementById('studentTable');
  const rows = studentTable.getElementsByTagName('tbody')[0].getElementsByTagName('tr');

  searchInput.addEventListener('input', function() {
    const searchTerm = this.value.toLowerCase();
    for (let i = 0; i < rows.length; i++) {
      const cells = rows[i].getElementsByTagName('td');
      // Check if row is the "No students found" message
      if (cells.length === 1) {
        rows[i].style.display = searchTerm ? 'none' : '';
        continue;
      }
      const studentId = cells[0].textContent.toLowerCase();
      const studentName = cells[1].textContent.toLowerCase();
      const email = cells[2].textContent.toLowerCase();
      // Check if the search term matches Student ID, Name, or Email
      if (studentId.includes(searchTerm) || studentName.includes(searchTerm) || email.includes(searchTerm)) {
        rows[i].style.display = '';
      } else {
        rows[i].style.display = 'none';
      }
    }
  });

  // Delete confirmation
  function confirmDelete(studentId, studentName) {
    if (confirm(`Are you sure you want to delete ${studentName} (ID: ${studentId})?`)) {
      window.location.href = `<%=request.getContextPath()%>/DeleteStudentServlet?studentId=${studentId}`;
    }
  }
</script>
</body>
</html>