package com.voting.servlet;

import com.voting.dao.CandidateDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/results")
public class ResultServlet extends HttpServlet {
    private final CandidateDAO candidateDAO = new CandidateDAO();
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("candidates", candidateDAO.getCandidatesWithResults());
        req.setAttribute("totalVotes", candidateDAO.getTotalVotes());
        req.getRequestDispatcher("/result.jsp").forward(req, resp);
    }
}