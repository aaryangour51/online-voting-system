package com.voting.dao;

import com.voting.connection.DBConnection;
import java.sql.*;

public class VoteDAO {

    public boolean castVote(int userId, int candidateId) {
        Connection conn = null;

        
            // your code
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Insert vote record
            String insertVote = "INSERT INTO votes (user_id, candidate_id) VALUES (?, ?)";
            PreparedStatement ps1 = conn.prepareStatement(insertVote);
            ps1.setInt(1, userId);
            ps1.setInt(2, candidateId);
            ps1.executeUpdate();

            // Increment candidate vote count
            String updateCandidate = "UPDATE candidates SET vote_count = vote_count + 1 WHERE id = ?";
            PreparedStatement ps2 = conn.prepareStatement(updateCandidate);
            ps2.setInt(1, candidateId);
            ps2.executeUpdate();

            // Mark user as voted
            String updateUser = "UPDATE users SET has_voted = TRUE WHERE id = ?";
            PreparedStatement ps3 = conn.prepareStatement(updateUser);
            ps3.setInt(1, userId);
            ps3.executeUpdate();

            conn.commit();
            return true;

        } catch (SQLException e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
        } finally {
            DBConnection.closeConnection(conn);
        }
        return false;
    }

    public boolean hasVoted(int userId) {
        String sql = "SELECT id FROM votes WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}