<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Course Web - Add Course</title>
  <!-- Bootstrap Icons CDN -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="<%=request.getContextPath()%>css/admin-navbar.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>css/admin-addcourse.css">
</head>
<body>
<%@ include file="Admin-navbar.jsp"%>
<main>
  <%
    String errorMessage = (String) request.getAttribute("errorMessage");
    String success = request.getParameter("success");
  %>
  <% if (errorMessage != null) { %>
  <div class="alert alert-danger" role="alert">
    <%= errorMessage %>
  </div>
  <% } %>
  <% if ("true".equals(success)) { %>
  <div class="alert alert-success" role="alert">
    Course added successfully!
  </div>
  <% } %>
  <div class="container">
    <div class="add-course-card">
      <h2>Add Course</h2>
      <form class="add-course-form" action="<%=request.getContextPath()%>/AddCourseServlet" method="post" enctype="multipart/form-data">
        <div class="upload-area" id="uploadArea">
          <div class="upload-content">
            <i class="bi bi-file-earmark-arrow-down upload-icon"></i>
            <p class="upload-text">Drag and drop an image here or click to upload</p>
            <p class="upload-hint">(Only .jpg, .jpeg, .png files allowed)</p>
          </div>
          <input type="file" id="fileInput" name="fileInput" accept=".jpg,.jpeg,.png" style="display: none;" required>
        </div>
        <div class="upload-success" id="uploadSuccess" style="display: none;">
          <i class="bi bi-check-circle-fill success-icon"></i>
          <span class="success-text">File selected successfully!</span>
        </div>
        <div class="form-row">
          <div class="form-group col-md-6">
            <label for="courseId">Course ID</label>
            <input type="text" id="courseId" name="courseId" placeholder="Enter course ID" required>
          </div>
          <div class="form-group col-md-6">
            <label for="courseCategory">Course Category</label>
            <select id="courseCategory" name="courseCategory" class="form-control" required>
              <option value="">Select Category</option>
              <option value="Programming">Programming</option>
              <option value="Design">Design</option>
              <option value="Business">Business</option>
              <option value="Marketing">Marketing</option>
              <option value="Law">Law</option>
              <option value="Science">Science</option>
              <option value="Social">Social</option>
              <option value="Technology">Technology</option>
              <option value="Other">Other</option>
            </select>
          </div>
        </div>
        <div class="form-group">
          <label for="courseName">Course Name</label>
          <input type="text" id="courseName" name="courseName" placeholder="Enter course name" required>
        </div>
        <div class="form-group">
          <label for="instructor">Instructor</label>
          <input type="text" id="instructor" name="instructor" placeholder="Enter instructor name" required>
        </div>
        <div class="form-group">
          <label for="introduction">Introduction</label>
          <textarea id="introduction" name="introduction" rows="4" placeholder="Enter course introduction" required></textarea>
        </div>
        <button type="submit" class="add-course-btn">Add Course</button>
      </form>
    </div>
  </div>
</main>
<footer>
  <div class="footer-content">
    <p>© 2025 Admin Panel. All rights reserved.</p>
    <p><a href="#">Privacy Policy</a> | <a href="#">Terms of Service</a> | <a href="#">Contact Us</a></p>
  </div>
</footer>
<script>
  document.addEventListener('DOMContentLoaded', function() {
    const uploadArea = document.getElementById('uploadArea');
    const fileInput = document.getElementById('fileInput');
    const uploadSuccess = document.getElementById('uploadSuccess');

    // Handle click on upload area
    uploadArea.addEventListener('click', function() {
      fileInput.click();
    });

    // Handle file selection
    fileInput.addEventListener('change', function(e) {
      if (e.target.files.length > 0) {
        const file = e.target.files[0];
        handleFileUpload(file);
      }
    });

    // Handle drag and drop
    uploadArea.addEventListener('dragover', function(e) {
      e.preventDefault();
      uploadArea.classList.add('dragover');
    });

    uploadArea.addEventListener('dragleave', function() {
      uploadArea.classList.remove('dragover');
    });

    uploadArea.addEventListener('drop', function(e) {
      e.preventDefault();
      uploadArea.classList.remove('dragover');
      if (e.dataTransfer.files.length > 0) {
        const file = e.dataTransfer.files[0];
        fileInput.files = e.dataTransfer.files; // Sync file input with dropped file
        handleFileUpload(file);
      }
    });

    function handleFileUpload(file) {
      // Check file type
      const validTypes = ['image/jpeg', 'image/png', 'image/jpg'];
      if (!validTypes.includes(file.type)) {
        alert('Please upload only JPEG, JPG, or PNG files.');
        fileInput.value = ''; // Clear file input
        uploadArea.style.display = 'flex';
        uploadSuccess.style.display = 'none';
        return;
      }

      // Display success message
      uploadArea.style.display = 'none';
      uploadSuccess.style.display = 'flex';
      console.log('File selected: ' + file.name); // Debug log
    }
  });
</script>
</body>
</html>