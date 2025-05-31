<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Request List</title>
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
    <h2>Request List</h2>
    <div class="search-container">
      <div class="search-bar">
        <i class="fas fa-search"></i>
        <input type="text" placeholder="Search requests...">
        <i class="bi bi-search"></i>
      </div>
    </div>
    <div class="table-container">
      <table>
        <thead>
        <tr>
          <th>Student Name</th>
          <th>Course</th>
          <th>Date</th>
          <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <tr>
          <td>Jane Doe</td>
          <td>Python</td>
          <td>2025/5/10</td>
          <td class="actions">
            <button class="edit-btn">Approve</button>
            <button class="delete-btn">Reject</button>
          </td>
        </tr>
        <tr>
          <td>John Smith</td>
          <td>Java</td>
          <td>2025/5/09</td>
          <td class="actions">
            <button class="edit-btn">Approve</button>
            <button class="delete-btn">Reject</button>
          </td>
        </tr>
        <tr>
          <td>Alice Johnson</td>
          <td>JavaScript</td>
          <td>2025/5/08</td>
          <td class="actions">
            <button class="edit-btn">Approve</button>
            <button class="delete-btn">Reject</button>
          </td>
        </tr>
        <tr>
          <td>Bob Brown</td>
          <td>C++</td>
          <td>2025/5/07</td>
          <td class="actions">
            <button class="edit-btn">Approve</button>
            <button class="delete-btn">Reject</button>
          </td>
        </tr>
        <tr>
          <td>Charlie Green</td>
          <td>Ruby</td>
          <td>2025/5/06</td>
          <td class="actions">
            <button class="edit-btn">Approve</button>
            <button class="delete-btn">Reject</button>
          </td>
        </tr>
        <tr>
          <td>Emily White</td>
          <td>Go</td>
          <td>2025/5/05</td>
          <td class="actions">
            <button class="edit-btn">Approve</button>
            <button class="delete-btn">Reject</button>
          </td>
        </tr>

        <!-- Add more rows as needed -->
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

<script>
  function logout() {
    alert('Logout functionality to be implemented.');
  }

  const hamburger = document.querySelector('.hamburger');
  const navUl = document.querySelector('nav ul');

  hamburger.addEventListener('click', () => {
    navUl.classList.toggle('active');
  });
</script>
</body>
</html>
