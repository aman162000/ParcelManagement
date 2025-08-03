package com.parcel.servlet;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public LogoutServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the current session (if exists)
        HttpSession session = request.getSession(false);  // Don't create a new session if one doesn't exist

        if (session != null) {
            // Invalidate the session to clear all attributes
            session.invalidate();
        }
        // Redirect to the login page after logout
        response.sendRedirect("index.jsp");  // Or any other page you want to redirect to
    }
}
