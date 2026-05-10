package com.voting.servlet;

import com.voting.dao.UserDAO;
import com.voting.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private static final long serialVersionUID = 1L;
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        User user = userDAO.login(email, password);

        if (user != null) {
            HttpSession session = req.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("role", user.getRole());
            if ("admin".equals(user.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/admin.jsp");
            } else {
                resp.sendRedirect(req.getContextPath() + "/dashboard.jsp");
            }
        } else {
            req.setAttribute("error", "Invalid email or password!");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }
}