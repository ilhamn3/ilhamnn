package com.opp.project.servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the current session, if it exists
        HttpSession session = request.getSession(false);

        // Invalidate the session to log the user out
        if (session != null) {
            session.invalidate();
        }

        // Redirect to the login page
        response.sendRedirect("Login.jsp");
    }
}