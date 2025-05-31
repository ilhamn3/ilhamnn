<!-- Dashboard.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.opp.project.model.Student" %>
<%@ page import="com.opp.project.util.FileUtil" %>
<%@ page import="com.opp.project.util.CourseFileUtil" %>
<%@ page import="com.opp.project.util.AnnouncementFileUtil" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Course Web - Dashboard</title>
  <link rel="icon" type="image/x-icon" href="img/logo.ico">
  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Bootstrap Icons CDN -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
  <!-- Custom CSS Files -->
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/navbarandfooter.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/styles.css">



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

  // Retrieve the logged-in user's data
  Student currentUser = null;
  List<Student> students = FileUtil.readStudents();
  for (Student student : students) {
    if (student.getUsername().equals(loginId) || student.getEmail().equals(loginId)) {
      currentUser = student;
      break;
    }
  }

  // If user not found, redirect to login
  if (currentUser == null) {
    response.sendRedirect("Login.jsp");
    return;
  }
%>
  <div class="container-fluid con">
    <div class="welcommsg">
      <p><strong>Welcome, </strong><%= currentUser.getFullName() %></p>
    </div>
  </div>

  <div class="grid-container">
    <div class="grid-item course_grid" >
      <span class="title my_courses_title">My Courses</span>
      <hr>
      <div class="my_courses">
        <%
          // Get enrolled course IDs
          long studentId = currentUser.getStudentId();
          List<String> enrolledCourseIds = CourseFileUtil.getEnrolledCourseIds(studentId);
          List<String[]> courses = CourseFileUtil.readCourses();
          List<String[]> enrolledCourses = new ArrayList<>();

          // Match enrolled course IDs with course details
          for (String courseId : enrolledCourseIds) {
            for (String[] course : courses) {
              if (course[2].equals(courseId)) {
                enrolledCourses.add(course);
              }
            }
          }

          // Display enrolled courses or a message if none
          if (enrolledCourses.isEmpty()) {
        %>
        <div class="alert alert-info">You are not enrolled in any courses yet. <a href="Courses.jsp">Browse Courses</a></div>
        <%
        } else {
          for (String[] course : enrolledCourses) {
            String imgPath = course[5];
            String courseName = course[1];
            String courseId = course[2];
            String instructor = course[3];
        %>
        <div class="card">
          <img src="<%= imgPath %>" alt="course_img">
          <h3><%= courseName %></h3>
          <p>Instructor: <%= instructor %><br>
            <strong>Course ID:</strong> <%= courseId %></p>
          <a href="#" class="btn btn-primary">Continue course</a>
        </div>
        <%
            }
          }
        %>
      </div>
    </div>
    <div class="grid-item calander">

      <a href="./contactform.jsp" class="support-grid">
        <div class="helpcard">
            <i class="bi bi-headset"></i><span class="ntitle">Need Support??</span>
            <div class="support-text">
              <span class="link">Click here to contact us</span>
            </div>
        </div>
      </a>
      <div class="cal-card">
        <span class="title calander_title">Calander</span>
        <iframe
                src="https://calendar.google.com/calendar/embed?height=600&wkst=2&ctz=Asia%2FColombo&showPrint=0&showTitle=0&showNav=0&showTz=0&showTabs=0&src=ZW4ubGsjaG9saWRheUBncm91cC52LmNhbGVuZGFyLmdvb2dsZS5jb20&color=%230B8043"
                frameborder="0"
                scrolling="no">
        </iframe>
      </div>
    </div>
    <div class="grid-item announcement_grid">
      <span class="title announcement"><img src="./img/communication.png" alt="icon" width="40px" height="40px">  Announcement</span>
      <hr>
      <%
        java.util.List<String[]> announcements = AnnouncementFileUtil.readAnnouncements();
        for (String[] announcement : announcements) {
      %>
      <div class="announcement-important">
        <div class="card-body">
          <h5 class="card-title"><%= announcement[0] %></h5>
          <p class="card-text"><%= announcement[1] %></p>
          <p class="card-text"><small class="text-muted">Date: <%= announcement[2] %></small></p>
        </div>
      </div>
      <% } %>
    </div>
  </div>
</main>

<%@ include file="footer.jsp" %>

<!-- Bootstrap JS and Popper.js -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>

<script src="js/dropdown-position.js"></script>
</body>
</html>