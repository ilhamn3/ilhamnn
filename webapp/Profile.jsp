<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.opp.project.model.Student" %>
<%@ page import="com.opp.project.util.FileUtil" %>
<%@ page import="com.opp.project.util.CourseFileUtil" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Course Web - Profile</title>
  <link rel="icon" type="image/x-icon" href="img/logo.ico">
  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Bootstrap Icons CDN -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
  <!-- Custom CSS -->
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/navbarandfooter.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/profile.css">
</head>
<body>
<main>
  <%@ include file="navbar.jsp" %>
  <%
    // Check if the user is logged in
    String userIdentifier = (String) session.getAttribute("userIdentifier");
    String username = (String) session.getAttribute("username");

    if (userIdentifier == null && username == null) {
      // Set an error message to display on Login.jsp
      request.setAttribute("errorMessage", "Session expired or not logged in. Please log in again.");
      response.sendRedirect("Login.jsp");
      return;
    }

    // Use userIdentifier if available, fallback to username
    String loginId = userIdentifier != null ? userIdentifier : username;

    // Retrieve the logged-in user's data
    Student currentUser = null;
    List<Student> students = FileUtil.readStudents();
    for (int i = 0; i < students.size(); i++) {
      Student student = students.get(i);
      if (student.getUsername().equals(loginId) || student.getEmail().equals(loginId)) {
        currentUser = student;
        break;
      }
    }

    // If user not found, redirect to login
    if (currentUser == null) {
      request.setAttribute("errorMessage", "User not found. Please log in again.");
      response.sendRedirect("Login.jsp");
      return;
    }

    // Get the number of enrolled courses
    long studentId = currentUser.getStudentId();
    int enrolledCourseCount = CourseFileUtil.getEnrolledCourseIds(studentId).size();

    // Check if the user is in edit mode
    String editMode = request.getParameter("editMode");
    boolean isEditMode = "true".equals(editMode);

    // Get success or error message
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");

    // Determine avatar image based on gender
//    String avatarImage;
    String gender = currentUser.getGender();
    if ("Male".equalsIgnoreCase(gender)) {
      avatarImage = "./img/male.png";
    } else if ("Female".equalsIgnoreCase(gender)) {
      avatarImage = "./img/female.png";
    } else {
      avatarImage = "./img/other.png";
    }
  %>

  <!-- Profile Content -->
  <div class="container">
    <div class="profile-card">
      <div class="avatar">
        <img src="<%= avatarImage %>" alt="User Avatar">
      </div>
      <div class="name"><%= currentUser.getFullName() %></div>
      <div class="role">Student</div>
      <div class="stats">
        <div class="stat">
          <span class="stat-icon"><i class="bi bi-journal-bookmark-fill"></i> <%= enrolledCourseCount %></span><br>Registered courses
        </div>
      </div>

      <div class="details">
        <h3>Student Details</h3>
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
        <% if (isEditMode) { %>
        <!-- Edit Mode: Show the form -->
        <form action="<%=request.getContextPath()%>/UpdateProfileServlet" method="post">
          <p>
            <strong>Name:</strong>
            <input type="text" name="fullName" value="<%= currentUser.getFullName() %>">
          </p>
          <p>
            <strong>Username:</strong>
            <input type="text" name="username" value="<%= currentUser.getUsername() %>" readonly>
          </p>
          <p>
            <strong>Email:</strong>
            <input type="email" name="email" value="<%= currentUser.getEmail() %>">
          </p>
          <p>
            <strong>Phone:</strong>
            <input type="text" name="phone" value="<%= currentUser.getPhone() %>">
          </p>
          <p>
            <strong>Date of Birth:</strong>
            <input type="date" name="dob" value="<%= currentUser.getDob() %>">
          </p>
          <p>
            <strong>Gender:</strong>
            <select name="gender">
              <option value="Male" <%= "Male".equals(currentUser.getGender()) ? "selected" : "" %>>Male</option>
              <option value="Female" <%= "Female".equals(currentUser.getGender()) ? "selected" : "" %>>Female</option>
              <option value="Other" <%= "Other".equals(currentUser.getGender()) ? "selected" : "" %>>Other</option>
            </select>
          </p>
          <div class="buttons">
            <button type="submit" class="button edit"><i class="bi bi-save"></i> Save</button>
            <a href="<%=request.getContextPath()%>/Profile.jsp" class="button delete"><i class="bi bi-x-square"></i> Cancel</a>
          </div>
        </form>
        <% } else { %>
        <!-- View Mode: Show the details -->
        <p><strong>Name:</strong> <%= currentUser.getFullName() %></p>
        <p><strong>Username:</strong> <%= currentUser.getUsername() %></p>
        <p><strong>Email:</strong> <%= currentUser.getEmail() %></p>
        <p><strong>Phone:</strong> <%= currentUser.getPhone() %></p>
        <p><strong>Date of Birth:</strong> <%= currentUser.getDob() %></p>
        <p><strong>Gender:</strong> <%= currentUser.getGender() %></p>
        <div class="buttons">
          <a href="<%=request.getContextPath()%>/Profile.jsp?editMode=true" class="button edit"><i class="bi bi-pencil-square"></i> Edit</a>
          <a href="#" class="button delete"><i class="bi bi-trash3"></i> Delete</a>
        </div>
        <% } %>
      </div>
    </div>
  </div>
</main>
<!-- Include the common footer -->
<%@ include file="footer.jsp" %>

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
        // Remove the alert from DOM after fade transition (0.15s)
        setTimeout(() => {
          alert.remove();
        }, 150);
      }, 5000); // 5 seconds
    });
  });
</script>
</body>
</html>