package com.voting.servlet;

import com.voting.dao.VoteDAO;
import com.voting.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/vote")
public class VoteServlet extends HttpServlet {
    private final VoteDAO voteDAO = new VoteDAO();
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("user");
        if (user.isHasVoted()) {
            resp.sendRedirect(req.getContextPath() + "/result.jsp?error=alreadyvoted");
            return;
        }
        String candidateIdStr = req.getParameter("candidateId");
        if (candidateIdStr == null || candidateIdStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/vote.jsp?error=nocandidate");
            return;
        }
        int candidateId = Integer.parseInt(candidateIdStr);
        boolean success = voteDAO.castVote(user.getId(), candidateId);
        if (success) {
            user.setHasVoted(true);
            session.setAttribute("user", user);
            resp.sendRedirect(req.getContextPath() + "/result.jsp?success=voted");
        } else {
            resp.sendRedirect(req.getContextPath() + "/vote.jsp?error=failed");
        }
    }
}