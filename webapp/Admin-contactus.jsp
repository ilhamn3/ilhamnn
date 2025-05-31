<%@ page import="com.opp.project.util.ContactFileUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Manage Contacts</title>
  <!-- custom css file   -->
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin-requestlist.css">
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
    <h2 style="margin-bottom: 50px"><strong>Contact Us Form Submissions</strong></h2>
    <div class="table-container">
      <table>
        <thead>
        <tr>
          <th>Name</th>
          <th>Email</th>
          <th>Subject</th>
          <th>Message</th>
          <th>Date</th>
          <th>Action</th>
        </tr>
        </thead>
        <tbody>
        <%
          java.util.List<String[]> contacts = ContactFileUtil.readContacts();
          for (int i = 0; i < contacts.size(); i++) {
            String[] contact = contacts.get(i);
        %>
        <tr>
          <td><%= contact[0] %></td>
          <td><%= contact[1] %></td>
          <td><%= contact[2] %></td>
          <td><%= contact[3] %></td>
          <td><%= contact[4] %></td>
          <td class="actions">
            <button class="delete-btn" onclick="deleteContact(<%= i %>)">Delete</button>
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
    <div class="footer-section">
      <a href="#">Privacy Policy</a>
      <a href="#">Terms of Service</a>
      <a href="#">Contact Us</a>
    </div>
  </div>
</footer>

<div class="toast">
  <% if (request.getParameter("successMessage") != null) { %>
  <script>
    const toast = document.querySelector('.toast');
    toast.textContent = '<%= request.getParameter("successMessage") %>';
    toast.classList.add('show');
  </script>
  <% } else if (request.getParameter("errorMessage") != null) { %>
  <script>
    const toast = document.querySelector('.toast');
    toast.textContent = '<%= request.getParameter("errorMessage") %>';
    toast.classList.add('show', 'error');
  </script>
  <% } %>
</div>

<script>
  function logout() {
    alert('Logout functionality to be implemented.');
  }

  const hamburger = document.querySelector('.hamburger');
  const navUl = document.querySelector('nav ul');

  hamburger.addEventListener('click', () => {
    navUl.classList.toggle('active');
  });

  function deleteContact(index) {
    if (confirm('Are you sure you want to delete this contact?')) {
      const form = document.createElement('form');
      form.method = 'POST';
      form.action = 'DeleteContactServlet';
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

  // Add close button to toast
  document.addEventListener('DOMContentLoaded', () => {
    const toast = document.querySelector('.toast');
    if (toast) {
      const closeBtn = document.createElement('button');
      closeBtn.className = 'close-btn';
      closeBtn.innerHTML = '×';
      closeBtn.addEventListener('click', () => {
        toast.classList.remove('show');
      });
      toast.appendChild(closeBtn);

      // Auto-hide after 3 seconds if shown
      setTimeout(() => {
        if (toast.classList.contains('show')) {
          toast.classList.remove('show');
        }
      }, 3000);
    }
  });
</script>
</body>
</html>