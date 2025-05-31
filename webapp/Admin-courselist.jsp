<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.opp.project.util.CourseFileUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Course List</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin-courselist.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>css/admin-navbar.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<%@ include file="Admin-navbar.jsp"%>
<main>
  <div class="container">
    <h2>Course List</h2>
    <div class="search-container">
      <div class="search-bar">
        <i class="fas fa-search"></i>
        <input type="text" id="courseSearchInput" placeholder="Search courses...">
      </div>
    </div>
    <table>
      <thead>
      <tr>
        <th>Course ID</th>
        <th>Course Name</th>
        <th>Instructor</th>
        <th>Category</th>
        <th>Introduction</th>
        <th class="image-column">Image</th>
        <th>Actions</th>
      </tr>
      </thead>
      <tbody>
      <%
        java.util.List<String[]> courses = CourseFileUtil.readCourses();
        for (String[] course : courses) {
      %>
      <tr data-course-id="<%= course[0] %>" class="course-row">
        <td><span class="view-mode"><%= course[0] %></span><input type="text" class="edit-mode form-control" value="<%= course[0] %>" style="display:none;"></td>
        <td><span class="view-mode"><%= course[1] %></span><input type="text" class="edit-mode form-control" value="<%= course[1] %>" style="display:none;"></td>
        <td><span class="view-mode"><%= course[2] %></span><input type="text" class="edit-mode form-control" value="<%= course[2] %>" style="display:none;"></td>
        <td><span class="view-mode"><%= course[3] %></span><input type="text" class="edit-mode form-control" value="<%= course[3] %>" style="display:none;"></td>
        <td><span class="view-mode"><%= truncateIntroduction(course[4]) %></span><input type="text" class="edit-mode form-control" value="<%= course[4] %>" style="display:none;"></td>
        <td class="image-column">
          <span class="view-mode" style="display:none;"><%= course[5] %></span>
          <input type="file" name="image" class="edit-mode image-upload" accept="image/*" style="display:none;">
        </td>
        <td class="actions">
          <button class="edit-btn" onclick="toggleEdit(this)">Edit</button>
          <button class="save-btn" style="display:none;" onclick="saveCourse(this)">Save</button>
          <button class="delete-btn" onclick="deleteCourse(this)">Delete</button>
        </td>
      </tr>
      <% } %>
      </tbody>
    </table>
  </div>
</main>
<footer>
  <div class="footer-content">
    <p>© 2025 Admin Panel. All rights reserved.</p>
    <p>
      <a href="#"><i class="fas fa-shield-alt"></i> Privacy Policy</a> |
      <a href="#"><i class="fas fa-file-contract"></i> Terms of Service</a> |
      <a href="#"><i class="fas fa-envelope"></i> Contact Us</a>
    </p>
  </div>
</footer>

<%!
  private String truncateIntroduction(String text) {
    if (text == null || text.trim().isEmpty()) {
      return "";
    }
    String[] words = text.split("\\s+");
    int wordCount = Math.min(6, words.length);
    StringBuilder truncated = new StringBuilder();
    for (int i = 0; i < wordCount; i++) {
      truncated.append(words[i]);
      if (i < wordCount - 1) {
        truncated.append(" ");
      }
    }
    if (words.length > 6) {
      truncated.append("...");
    }
    return truncated.toString();
  }
%>

<script>
  function logout() {
    alert('Logout functionality to be implemented.');
  }

  const searchInput = document.getElementById('courseSearchInput');
  const tableRows = document.querySelectorAll('tbody tr');

  searchInput.addEventListener('input', function() {
    const searchTerm = this.value.toLowerCase().trim();
    tableRows.forEach(row => {
      const text = row.textContent.toLowerCase();
      row.style.display = text.includes(searchTerm) ? '' : 'none';
    });
  });

  function toggleEdit(button) {
    const row = button.closest('tr');
    const editModeElements = row.querySelectorAll('.edit-mode');
    const viewModeElements = row.querySelectorAll('.view-mode');
    const saveBtn = row.querySelector('.save-btn');
    const editBtn = row.querySelector('.edit-btn');
    const imageColumns = document.querySelectorAll('.image-column');

    if (editBtn.textContent === 'Edit') {
      editModeElements.forEach(input => input.style.display = 'inline-block');
      viewModeElements.forEach(span => span.style.display = 'none');
      saveBtn.style.display = 'inline-block';
      editBtn.textContent = 'Cancel';
      // Show the Image column
      imageColumns.forEach(col => col.style.display = 'table-cell');
    } else {
      editModeElements.forEach(input => input.style.display = 'none');
      viewModeElements.forEach(span => span.style.display = 'inline-block');
      saveBtn.style.display = 'none';
      editBtn.textContent = 'Edit';
      // Hide the Image column
      imageColumns.forEach(col => col.style.display = 'none');
    }
  }

  function saveCourse(button) {
    const row = button.closest('tr');
    const courseId = row.getAttribute('data-course-id');
    const newValues = [];
    row.querySelectorAll('.edit-mode:not(.image-upload)').forEach(input => newValues.push(input.value));

    // Create form with enctype="multipart/form-data" to handle file upload
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = 'EditCourseServlet';
    form.enctype = 'multipart/form-data';

    const courseIdInput = document.createElement('input');
    courseIdInput.type = 'hidden';
    courseIdInput.name = 'courseId';
    courseIdInput.value = courseId;
    form.appendChild(courseIdInput);

    newValues.forEach((value, index) => {
      const input = document.createElement('input');
      input.type = 'hidden';
      input.name = 'field' + index;
      input.value = value;
      form.appendChild(input);
    });

    // Append the file input to the form
    const fileInput = row.querySelector('.image-upload');
    if (fileInput.files.length > 0) {
      const fileInputClone = document.createElement('input');
      fileInputClone.type = 'file';
      fileInputClone.name = 'image';
      fileInputClone.files = fileInput.files;
      form.appendChild(fileInputClone);
    }

    document.body.appendChild(form);
    form.submit();
  }

  function deleteCourse(button) {
    if (confirm('Are you sure you want to delete this course?')) {
      const row = button.closest('tr');
      const courseId = row.getAttribute('data-course-id');
      const imagePath = row.querySelector('.view-mode').textContent.trim(); // Get the image path

      // Create form for delete request
      const form = document.createElement('form');
      form.method = 'POST';
      form.action = 'DeleteCourseServlet';
      form.style.display = 'none';

      const courseIdInput = document.createElement('input');
      courseIdInput.type = 'hidden';
      courseIdInput.name = 'courseId';
      courseIdInput.value = courseId;
      form.appendChild(courseIdInput);

      const imagePathInput = document.createElement('input');
      imagePathInput.type = 'hidden';
      imagePathInput.name = 'imagePath';
      imagePathInput.value = imagePath;
      form.appendChild(imagePathInput);

      document.body.appendChild(form);
      form.submit();
    }
  }
</script>
<script src="js/admin.js"></script>
</body>
</html>