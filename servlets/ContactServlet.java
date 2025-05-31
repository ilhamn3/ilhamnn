package com.opp.project.servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet("/ContactServlet")
public class ContactServlet extends HttpServlet {
    private static final String USER_HOME = System.getProperty("user.home");
    private static final String APP_DATA_DIR = USER_HOME + File.separator + "Desktop/Project/OPP-Project_P-153/src/main/resources/data";
    private static final String CONTACTS_FILE_PATH = APP_DATA_DIR + File.separator + "contacts.txt";

    static {
        // Ensure the data directory exists
        File dir = new File(APP_DATA_DIR);
        if (!dir.exists()) {
            dir.mkdirs();
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userIdentifier = (String) session.getAttribute("userIdentifier");

        // Check if the user is logged in
        if (userIdentifier == null) {
            request.setAttribute("errorMessage", "Please log in to submit a contact form.");
            response.sendRedirect("Login.jsp");
            return;
        }

        // Retrieve form data
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        // Validate inputs
        if (name == null || name.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                subject == null || subject.trim().isEmpty() ||
                message == null || message.trim().isEmpty()) {
            request.setAttribute("errorMessage", "All fields are required.");
            request.getRequestDispatcher("contactform.jsp").forward(request, response);
            return;
        }

        // Format the current date (without time)
        LocalDateTime now = LocalDateTime.now();
        String date = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")); // Changed to only date

        // Prepare the data to save (comma-separated, escaping commas in message)
        String sanitizedMessage = message.replace(",", "\\,");
        String dataLine = String.format("%s,%s,%s,%s,%s", name, email, subject, sanitizedMessage, date);

        // Save to contacts.txt
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(CONTACTS_FILE_PATH, true))) {
            bw.write(dataLine);
            bw.newLine();
        } catch (IOException e) {
            System.err.println("Error saving to contacts.txt: " + e.getMessage());
            request.setAttribute("errorMessage", "Error saving your message. Please try again.");
            request.getRequestDispatcher("contactform.jsp").forward(request, response);
            return;
        }

        // Redirect with success message
        request.setAttribute("successMessage", "Your message has been sent successfully!");
        request.getRequestDispatcher("contactform.jsp").forward(request, response);
    }
}