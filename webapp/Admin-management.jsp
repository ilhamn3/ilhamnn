<%@ page import="com.opp.project.util.AdminFileUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Add New Admin Profile</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin-managment.css">
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
    <!-- Add New Admin Section -->
    <div class="admin-profile-card animate-card">
      <h2>Add New Admin</h2>
      <form class="admin-profile-form fcss" id="addAdminForm" action="AddAdminServlet" method="POST">
        <div class="form-group">
          <label for="newAdminName">Name</label>
          <div class="input-wrapper">
            <i class="fas fa-user"></i>
            <input type="text" id="newAdminName" name="newAdminName" placeholder="Enter admin name" required>
          </div>
        </div>
        <div class="form-group">
          <label for="newAdminUsername">Username</label>
          <div class="input-wrapper">
            <i class="fas fa-user"></i>
            <input type="text" id="newAdminUsername" name="newAdminUsername" placeholder="Enter username" required>
          </div>
        </div>
        <div class="form-group">
          <label for="newAdminPassword">Password</label>
          <div class="input-wrapper">
            <i class="fas fa-lock"></i>
            <input type="password" id="newAdminPassword" name="newAdminPassword" placeholder="Enter password" required>
          </div>
        </div>
        <div class="form-group">
          <label for="newAdminEmail">Email</label>
          <div class="input-wrapper">
            <i class="fas fa-envelope"></i>
            <input type="email" id="newAdminEmail" name="newAdminEmail" placeholder="Enter admin email" required>
          </div>
        </div>
        <button type="submit" class="update-profile-btn">Add Admin</button>
      </form>
    </div>

    <!-- Admin List Section -->
    <div class="admin-profile-card animate-card">
      <h2>Admin List</h2>
      <div class="table-container">
        <table>
          <thead>
          <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Username</th>
            <th>Email</th>
            <th>Actions</th>
          </tr>
          </thead>
          <tbody id="adminList">
          <%
            java.util.List<String[]> admins = AdminFileUtil.readAdmins();
            if (admins.isEmpty()) {
          %>
          <tr>
            <td colspan="5">No admins found in admin.txt.</td>
          </tr>
          <%
          } else {
            String editId = request.getParameter("editId");
            for (int i = 0; i < admins.size(); i++) {
              String[] admin = admins.get(i);
              if (editId != null && editId.equals(admin[0])) {
          %>
          <tr>
            <td><%= admin[0] %></td>
            <td><input type="text" id="editName" value="<%= admin[1] %>" required></td>
            <td><input type="text" id="editUsername" value="<%= admin[2] %>" required></td>
            <td><input type="email" id="editEmail" value="<%= admin[3] %>" required></td>
            <td class="actions">
              <button class="save-btn" onclick="saveEdit('<%= admin[0] %>')">Save</button>
              <button class="cancel-btn" onclick="cancelEdit()">Cancel</button>
            </td>
          </tr>
          <% } else { %>
          <tr>
            <td><%= admin[0] %></td>
            <td><%= admin[1] %></td>
            <td><%= admin[2] %></td>
            <td><%= admin[3] %></td>
            <td class="actions">
              <% if (admin[0].equals("1")) { %>
              <button class="edit-btn" disabled>Edit</button>
              <button class="delete-btn" disabled>Delete</button>
              <% } else { %>
              <button class="edit-btn" onclick="editAdmin('<%= admin[0] %>')">Edit</button>
              <button class="delete-btn" onclick="deleteAdmin('<%= admin[0] %>')">Delete</button>
              <% } %>
            </td>
          </tr>
          <% } %>
          <% } %>
          <% } %>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</main>

<footer>
  <div class="footer-content">
    <p>©️ 2025 Admin Panel. All rights reserved.</p>
    <p><a href="#">Privacy Policy</a> | <a href="#">Terms of Service</a> | <a href="#">Contact Us</a></p>
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

<script src="js/admin.js"></script>
<script>
  function logout() {
    if (confirm('Are you sure you want to logout?')) {
      alert('Logout functionality to be implemented.');
    }
  }

  const hamburger = document.querySelector('.hamburger');
  const navUl = document.querySelector('nav ul');

  hamburger.addEventListener('click', () => {
    navUl.classList.toggle('active');
  });

  function editAdmin(id) {
    window.location.href = "Admin-management.jsp?editId=" + id;
  }

  function saveEdit(id) {
    const name = document.getElementById('editName').value;
    const username = document.getElementById('editUsername').value;
    const email = document.getElementById('editEmail').value;
    const password = prompt("Enter new password (leave blank to keep current):");
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = 'EditAdminServlet';
    form.style.display = 'none';

    const idInput = document.createElement('input');
    idInput.type = 'hidden';
    idInput.name = 'id';
    idInput.value = id;
    form.appendChild(idInput);

    const nameInput = document.createElement('input');
    nameInput.type = 'hidden';
    nameInput.name = 'name';
    nameInput.value = name;
    form.appendChild(nameInput);

    const usernameInput = document.createElement('input');
    usernameInput.type = 'hidden';
    usernameInput.name = 'username';
    usernameInput.value = username;
    form.appendChild(usernameInput);

    const emailInput = document.createElement('input');
    emailInput.type = 'hidden';
    emailInput.name = 'email';
    emailInput.value = email;
    form.appendChild(emailInput);

    if (password && password.trim() !== "") {
      const passwordInput = document.createElement('input');
      passwordInput.type = 'hidden';
      passwordInput.name = 'password';
      passwordInput.value = password;
      form.appendChild(passwordInput);
    }

    document.body.appendChild(form);
    form.submit();
  }

  function cancelEdit() {
    window.location.href = "Admin-management.jsp";
  }

  function deleteAdmin(id) {
    if (confirm('Are you sure you want to delete this admin?')) {
      const form = document.createElement('form');
      form.method = 'POST';
      form.action = 'DeleteAdminServlet';
      form.style.display = 'none';

      const idInput = document.createElement('input');
      idInput.type = 'hidden';
      idInput.name = 'id';
      idInput.value = id;
      form.appendChild(idInput);

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