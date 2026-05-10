package com.voting.servlet;

import com.voting.dao.UserDAO;
import com.voting.model.User;
import com.voting.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String fullName = req.getParameter("fullName");
        String email    = req.getParameter("email");
        String password = req.getParameter("password");
        String voterId  = req.getParameter("voterId");

        if (!ValidationUtil.isNotEmpty(fullName)
                || !ValidationUtil.isValidEmail(email)
                || !ValidationUtil.isValidPassword(password)
                || !ValidationUtil.isValidVoterId(voterId)) {
            req.setAttribute("error", "Please fill all fields correctly.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }
        if (userDAO.emailExists(email)) {
            req.setAttribute("error", "Email is already registered.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }
        if (userDAO.voterIdExists(voterId)) {
            req.setAttribute("error", "Voter ID is already used.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }
        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPassword(password);
        user.setVoterId(voterId.toUpperCase());

        if (userDAO.register(user)) {
            resp.sendRedirect(req.getContextPath() + "/login?success=registered");
        } else {
            req.setAttribute("error", "Registration failed. Please try again.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        }
    }
}