<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.opp.project.util.CourseFileUtil" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Course web -Courses</title>
  <link rel="icon" type="image/x-icon" href="img/logo.ico">
  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Bootstrap Icons CDN -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
  <!-- Custom CSS -->
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/navbarandfooter.css">
  <!-- Tailwind CSS -->
  <link href="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.2.19/tailwind.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">

  <!-- Custom CSS -->
  <style>
    .course-card:hover {
      transform: translateY(-10px);
      box-shadow: 0px 10px 20px rgba(0, 0, 0, 0.1);
    }

    .course-card img {
      border-radius: 10px;
    }

    .btn-enroll {
      transition: background-color 0.3s;
    }

    .btn-enroll:hover {
      background-color: #2b6cb0;
    }

    #searchBar {
      height: 95%;
    }

    /* Toast Styling */
    .toast {
      position: fixed;
      bottom: 20px;
      right: 20px;
      min-width: 250px;
      background-color: #333;
      color: white;
      padding: 16px;
      border-radius: 8px;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
      opacity: 0;
      transition: opacity 0.3s ease-in-out;
      z-index: 1000;
    }

    .toast.show {
      opacity: 1;
    }

    .toast.success {
      background-color: #28a745; /* Green for success */
    }

    .toast.error {
      background-color: #dc3545; /* Red for error */
    }

    .toast .close-btn {
      position: absolute;
      top: 8px;
      right: 8px;
      background: none;
      border: none;
      color: white;
      font-size: 16px;
      cursor: pointer;
    }
  </style>
</head>
<body class="bg-gray-50 min-h-screen font-inter">
<main>
  <%@ include file="navbar.jsp" %>
  <!-- Header Section -->
  <header class="bg-gradient-to-r from-blue-600 to-indigo-600 text-white py-12">
    <div class="container mx-auto px-4">
      <h1 class="text-4xl font-bold mb-4 text-center">Explore Our Courses</h1>
      <p class="text-lg text-center mb-6">Find the perfect course to boost your skills</p>
      <div class="flex justify-center">
        <div class="relative w-full max-w-lg">
          <input
                  type="text"
                  id="searchBar"
                  placeholder="Search for courses..."
                  class="w-full p-4 pr-12 rounded-full border-none focus:outline-none focus:ring-2 focus:ring-blue-300 text-gray-800 shadow-md"
          >
          <button class="absolute right-2 top-1/2 transform -translate-y-1/2 bg-blue-500 text-white p-2 rounded-full hover:bg-blue-600 transition">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
            </svg>
          </button>
        </div>
      </div>
    </div>
  </header>

  <!-- Courses Section -->
  <section class="container mx-auto px-4 py-12">
    <div id="courseContainer" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8">
      <%
        String studentId = (String) session.getAttribute("studentId");
        List<String[]> courses = CourseFileUtil.readCourses();
        for (String[] course : courses) {
          String imgPath = course[5];
          String courseName = course[1];
          String courseId = course[0];
          String instructor = course[2];
          String introduction = course[4];
          String category = course[3];
      %>
      <!-- Course -->
      <div class="course-card bg-white p-6 rounded-xl shadow-lg">
        <img src="<%= imgPath %>" alt="Introduction to Python" class="w-full h-49 object-cover mb-4">
        <h2 class="text-2xl font-semibold text-gray-800 mb-2"><%= courseName %></h2>
        <p class="text-blue-500 font-medium"><%= category %></p>
        <p class="text-gray-600 mt-2"><%= introduction %></p>
        <p class="text-gray-500 mt-3"><span class="font-medium">Course ID:</span> <%= courseId %></p>
        <p class="text-gray-500 mt-1"><span class="font-medium">Instructor:</span> <%= instructor %></p>
        <% if (studentId == null) { %>
        <p class="text-red-500 mt-4">Please log in to enroll.</p>
        <% } else { %>
        <form action="RequestServlet" method="POST" style="display:inline;">
          <input type="hidden" name="courseId" value="<%= courseId %>">
          <button type="submit" class="btn-enroll mt-4 bg-blue-500 text-white px-4 py-2 rounded-full">Enroll Now</button>
        </form>
        <% } %>
      </div>
      <%
        }
      %>
    </div>
  </section>
</main>
<%@ include file="footer.jsp" %>

<!-- Toast Notification -->
<div class="toast">
  <% if (request.getParameter("successMessage") != null) { %>
  <script>
    const toast = document.querySelector('.toast');
    toast.textContent = '<%= request.getParameter("successMessage") %>';
    toast.classList.add('show', 'success'); // Add 'success' class for green color
  </script>
  <% } else if (request.getParameter("errorMessage") != null) { %>
  <script>
    const toast = document.querySelector('.toast');
    toast.textContent = '<%= request.getParameter("errorMessage") %>';
    toast.classList.add('show', 'error'); // Add 'error' class for red color
  </script>
  <% } %>
</div>

<!-- JavaScript for Search Functionality -->
<script>
  document.getElementById('searchBar').addEventListener('keyup', function(e) {
    const searchTerm = e.target.value.trim().toLowerCase();
    const courseContainer = document.getElementById('courseContainer');
    const courseCards = courseContainer.getElementsByClassName('course-card');

    Array.from(courseCards).forEach(card => {
      const title = card.querySelector('h2')?.textContent.toLowerCase() || '';
      const category = card.querySelector('p.text-blue-500')?.textContent.toLowerCase() || '';
      const description = card.querySelector('p.text-gray-600')?.textContent.toLowerCase() || '';
      const courseId = card.querySelector('p.text-gray-500:nth-of-type(1)')?.textContent.toLowerCase() || '';
      const instructor = card.querySelector('p.text-gray-500:nth-of-type(2)')?.textContent.toLowerCase() || '';

      const isMatch = title.includes(searchTerm) ||
              category.includes(searchTerm) ||
              description.includes(searchTerm) ||
              courseId.includes(searchTerm) ||
              instructor.includes(searchTerm);

      card.style.display = isMatch || searchTerm === '' ? 'block' : 'none';
    });
  });

  // Toast close button functionality
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

      setTimeout(() => {
        if (toast.classList.contains('show')) {
          toast.classList.remove('show');
        }
      }, 3000);
    }
  });
</script>
<!-- Bootstrap JS and Popper.js -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>

<script src="js/dropdown-position.js"></script>
</body>
</html>