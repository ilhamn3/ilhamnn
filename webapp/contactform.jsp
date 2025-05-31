<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Course Web - Contact Us</title>
    <link rel="icon" type="image/x-icon" href="<%=request.getContextPath()%>/img/logo.ico">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/navbarandfooter.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/contactform.css">
</head>
<body>
<main>
    <%@ include file="navbar.jsp" %>

    <%
        // Check if the user is logged in
        String userIdentifier = (String) session.getAttribute("userIdentifier");
        if (userIdentifier == null) {
            request.setAttribute("errorMessage", "Please log in to submit a contact form.");
            response.sendRedirect("Login.jsp");
            return;
        }
    %>
    <div class="container">
        <div class="login-card">
            <div class="row">
                <!-- Left Side with Image -->
                <div class="col-md-6 d-none d-md-block left-section">
                    <div class="logo">
                        <div class="logo-img-container">
                            <img src="<%=request.getContextPath()%>/img/logo.png" alt="Course Web Logo" class="logo-img">
                        </div>
                        <span class="logo-text">Course Web</span>
                    </div>
                    <img src="<%=request.getContextPath()%>/img/contact.png" alt="Contact Us Image" class="main-image">
                </div>
                <!-- Right Side with Contact Form -->
                <div class="col-md-6 right-section">
                    <div class="register-form">
                        <h2>Contact Us</h2>
                        <p>We'd love to hear from you!</p>
                        <!-- Display success or error message if present -->
                        <% String successMessage = (String) request.getAttribute("successMessage"); %>
                        <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
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
                        <!-- Contact Form -->
                        <form id="contactForm" action="<%=request.getContextPath()%>/ContactServlet" method="POST">
                            <div class="mb-3">
                                <input type="text" class="form-control" name="name" id="name" placeholder="Your Name" required>
                            </div>
                            <div class="mb-3">
                                <input type="email" class="form-control" name="email" id="email" placeholder="Your Email" required>
                            </div>
                            <div class="mb-3">
                                <input type="text" class="form-control" name="subject" id="subject" placeholder="Subject" required>
                            </div>
                            <div class="mb-3">
                                <textarea class="form-control" name="message" id="message" rows="5" placeholder="Your Message" required></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary w-100 register-btn">Send Message</button>
                        </form>
                        <p class="login-link">Back to <a href="<%=request.getContextPath()%>/Dashboard.jsp">Home</a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="footer.jsp" %>

<!-- Bootstrap JS and Popper.js -->
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