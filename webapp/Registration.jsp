<!-- Registration.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Course Web - Registration</title>
  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Font Awesome for Icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
  <!-- Custom CSS -->
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/form.css">
</head>
<body>
<div class="login-card">
  <div class="row">
    <!-- Left Side with Image -->
    <div class="col-md-6 d-none d-md-block left-section">
      <div class="logo">
        <div class="logo-img-container">
          <img src="img/logo.png" alt="Course Web Logo" class="logo-img">
        </div>
        <span class="logo-text">Course Web</span>
      </div>
      <img src="img/Registration_form.png" alt="Registration Image" class="main-image">
    </div>
    <!-- Right Side with Registration Form -->
    <div class="col-md-6 right-section">
      <div class="register-form">
        <h2>Create an Account</h2>
        <p>Sign up to get started</p>
        <!-- Display error message if present -->
        <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
        <% if (errorMessage != null) { %>
        <div class="error-message"><%= errorMessage %></div>
        <% } %>
        <!-- Registration Form -->
        <form id="registerForm" action="<%=request.getContextPath()%>/RegistrationServlet" method="POST">
          <div class="mb-3">
            <input type="text" class="form-control" name="fullname" id="fullname" placeholder="Full Name" required>
          </div>
          <div class="row g-3 mb-3">
            <div class="col-6">
              <input type="text" class="form-control" name="username" id="username" placeholder="Username" required>
            </div>
            <div class="col-6">
              <input type="tel" class="form-control" name="phone" id="phone" placeholder="Phone Number" required>
            </div>
          </div>
          <div class="mb-3">
            <input type="email" class="form-control" name="email" id="email" placeholder="Email" required>
          </div>
          <div class="row g-3 mb-3">
            <div class="col-6">
              <input type="date" class="form-control" name="dob" id="dob" required>
            </div>
            <div class="col-6">
              <select class="form-select" name="gender" id="gender" required>
                <option value="" disabled selected>Select your gender</option>
                <option value="Male">Male</option>
                <option value="Female">Female</option>
                <option value="Other">Other</option>
              </select>
            </div>
          </div>
          <div class="row g-3 mb-3">
            <div class="col-6">
              <div class="input-group">
                <input type="password" class="form-control" name="password" id="password" placeholder="Password" required>
                <i class="fas fa-eye password-toggle" id="togglePassword"></i>
              </div>
            </div>
            <div class="col-6">
              <div class="input-group">
                <input type="password" class="form-control" name="confirmPassword" id="confirmPassword" placeholder="Confirm Password" required>
                <i class="fas fa-eye password-toggle" id="toggleConfirmPassword"></i>
              </div>
            </div>
          </div>
          <button type="submit" class="btn btn-primary w-100 register-btn">Register</button>
        </form>
        <p class="login-link">Already have an account? <a href="<%=request.getContextPath()%>/Login.jsp">Sign in</a></p>
      </div>
    </div>
  </div>
</div>

<!-- Bootstrap JS and Popper.js -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>
<!-- Custom JavaScript -->
<script src="<%=request.getContextPath()%>/js/form.js"></script>
</body>
</html>