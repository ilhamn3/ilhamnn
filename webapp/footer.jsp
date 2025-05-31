<!-- Footer.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<footer class="loaded">
    <div class="container">
        <div class="row">
            <!-- About Section -->
            <div class="col-md-4">
                <h5>About Course Web</h5>
                <p>
                    Course Web is your one-stop platform for managing courses, requests, and academic resources. Stay connected and organized with ease.
                </p>
            </div>

            <!-- Quick Links Section -->
            <div class="col-md-4">
                <h5>Quick Links</h5>
                <ul>
                    <li><a href="<%=request.getContextPath()%>/Dashboard.jsp">Dashboard</a></li>
                    <li><a href="#">Courses</a></li>
                    <li><a href="#">Contact Us</a></li>
                    <li><a href="#">My Requests</a></li>
                </ul>
            </div>

            <!-- Contact Section -->
            <div class="col-md-4">
                <h5>Contact Us</h5>
                <p class="contact-info"><i class="bi bi-envelope"></i><a href="mailto:support@courseweb.com">support@courseweb.com</a></p>
                <p class="contact-info"><i class="bi bi-telephone"></i><a href="tel:+15551234567">+1 (555) 123-4567</a></p>
                <p class="contact-info"><i class="bi bi-geo-alt"></i>123 Academic Lane, Education City</p>
            </div>
        </div>

        <!-- Bottom Section -->

        <div class="border-top pt-2 mt-3 text-center">
            <div class="social-icons mb-2">
                <a href="#" aria-label="Facebook"><i class="bi bi-facebook"></i></a>
                <a href="#" aria-label="Twitter"><i class="bi bi-twitter"></i></a>
                <a href="#" aria-label="Instagram"><i class="bi bi-instagram"></i></a>
            </div>
            <p>© 2025 Course Web. All rights reserved.</p>
        </div>
    </div>
</footer>