package com.voting.servlet;

import com.voting.dao.CandidateDAO;
import com.voting.model.Candidate;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/candidate")
public class CandidateServlet extends HttpServlet {
    private final CandidateDAO candidateDAO = new CandidateDAO();
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        String action = req.getParameter("action");
        if ("add".equals(action)) {
            Candidate c = new Candidate();
            c.setName(req.getParameter("name"));
            c.setParty(req.getParameter("party"));
            c.setDescription(req.getParameter("description"));
            c.setImageUrl(req.getParameter("imageUrl"));
            candidateDAO.addCandidate(c);
            resp.sendRedirect(req.getContextPath() + "/admin.jsp?success=added");
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            candidateDAO.deleteCandidate(id);
            resp.sendRedirect(req.getContextPath() + "/admin.jsp?success=deleted");
        }
    }
}