<!-- Login.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Course Web - Login</title>
    <link rel="icon" type="image/x-icon" href="img/logo.ico">
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
            <img src="img/Login_form.png" alt="Main Image" class="main-image">
        </div>
        <!-- Right Side with Login Form -->
        <div class="col-md-6 right-section">
            <div class="login-form">
                <h2>Welcome to Course Web</h2>
                <p>Sign in to continue</p>
                <!-- Avatar Image -->
                <img src="img/Login_avatar.avif" alt="Avatar" class="avatar">
                <!-- Display error message if present -->
                <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
                <% if (errorMessage != null) { %>
                <div class="error-message"><%= errorMessage %></div>
                <% } %>
                <!-- Login Form -->
                <form id="loginForm" action="<%=request.getContextPath()%>/LoginServlet" method="POST">
                    <div class="mb-3">
                        <input type="text" class="form-control" name="loginId" id="loginId" placeholder="Username/Email" required>
                    </div>
                    <div class="mb-3">
                        <div class="input-group">
                            <input type="password" class="form-control" name="password" id="password" placeholder="Password" required>
                            <i class="fas fa-eye password-toggle" id="togglePassword"></i>
                        </div>
                    </div>
                    <a href="#" class="forgot-password">Forgot Password?</a>
                    <button type="submit" class="btn btn-primary w-100 sign-in-btn">Sign In</button>
                </form>
                <p class="create-account">New to Course Web? <a href="<%=request.getContextPath()%>/Registration.jsp">Create an account</a></p>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS and Popper.js -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>
<!-- JavaScript for Password Toggle -->
<script>
    // Password toggle for Password field
    const togglePassword = document.getElementById('togglePassword');
    const password = document.getElementById('password');
    togglePassword.addEventListener('click', function () {
        const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
        password.setAttribute('type', type);
        this.classList.toggle('fa-eye');
        this.classList.toggle('fa-eye-slash');
    });
</script>
</body>
</html>