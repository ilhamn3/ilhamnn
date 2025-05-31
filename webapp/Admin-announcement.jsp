<%@ page import="com.opp.project.util.AnnouncementFileUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Add Announcement</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin-announcment.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>css/admin-navbar.css">
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
  <div class="container">
    <h2 style="margin-bottom: 30px"><strong>Add Announcement</strong></h2>
    <div class="form-card">
      <form id="announcementForm" action="AddAnnouncementServlet" method="POST">
        <label for="announcement-title">Title</label>
        <input type="text" id="announcement-title" name="title" placeholder="Enter announcement title" required>
        <label for="announcement-content">Content</label>
        <textarea id="announcement-content" name="content" placeholder="Enter announcement content" rows="4" required></textarea>
        <label for="announcement-date">Date</label>
        <input type="date" id="announcement-date" name="date" required>
        <button type="submit">Add Announcement</button>
      </form>
    </div>
    <div class="table-container">
      <table>
        <thead>
        <tr>
          <th>Title</th>
          <th>Content</th>
          <th>Date</th>
          <th>Action</th>
        </tr>
        </thead>
        <tbody id="announcementTableBody">
        <%
          java.util.List<String[]> announcements = AnnouncementFileUtil.readAnnouncements();
          for (int i = 0; i < announcements.size(); i++) {
            String[] announcement = announcements.get(i);
        %>
        <tr>
          <td><%= announcement[0] %></td>
          <td><%= announcement[1] %></td>
          <td><%= announcement[2] %></td>
          <td class="actions">
            <button class="delete-btn" onclick="deleteAnnouncement(<%= i %>)">Delete</button>
          </td>
        </tr>
        <% } %>
        </tbody>
      </table>
    </div>
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

<div class="toast">
  <% if (request.getParameter("successMessage") != null) { %>
  <script>
    const toast = document.querySelector('.toast');
    toast.textContent = '<%= request.getParameter("successMessage") %>';
    toast.classList.add('show');
    setTimeout(() => toast.classList.remove('show'), 3000);
  </script>
  <% } else if (request.getParameter("errorMessage") != null) { %>
  <script>
    const toast = document.querySelector('.toast');
    toast.textContent = '<%= request.getParameter("errorMessage") %>';
    toast.classList.add('show');
    setTimeout(() => toast.classList.remove('show'), 3000);
  </script>
  <% } %>
</div>

<script src="js/admin.js"></script>
<script src="js/dropdown-position.js"></script>
<script>
  function deleteAnnouncement(index) {
    if (confirm('Are you sure you want to delete this announcement?')) {
      const form = document.createElement('form');
      form.method = 'POST';
      form.action = 'DeleteAnnouncementServlet';
      form.style.display = 'none';

      const indexInput = document.createElement('input');
      indexInput.type = 'hidden';
      indexInput.name = 'index';
      indexInput.value = index;
      form.appendChild(indexInput);

      document.body.appendChild(form);
      form.submit();
    }
  }

</script>
</body>
</html>