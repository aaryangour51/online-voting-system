package com.voting.dao;

import com.voting.connection.DBConnection;
import com.voting.model.Candidate;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CandidateDAO {

    public List<Candidate> getAllCandidates() {
        List<Candidate> list = new ArrayList<>();
        String sql = "SELECT * FROM candidates ORDER BY name";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                list.add(mapCandidate(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Candidate> getCandidatesWithResults() {
        List<Candidate> list = new ArrayList<>();
        String sql = "SELECT * FROM candidates ORDER BY vote_count DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                list.add(mapCandidate(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addCandidate(Candidate candidate) {
        String sql = "INSERT INTO candidates (name, party, description, image_url) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, candidate.getName());
            ps.setString(2, candidate.getParty());
            ps.setString(3, candidate.getDescription());
            ps.setString(4, candidate.getImageUrl());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteCandidate(int id) {
        String sql = "DELETE FROM candidates WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int getTotalVotes() {
        String sql = "SELECT SUM(vote_count) FROM candidates";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Candidate mapCandidate(ResultSet rs) throws SQLException {
        return new Candidate(
            rs.getInt("id"),
            rs.getString("name"),
            rs.getString("party"),
            rs.getString("description"),
            rs.getString("image_url"),
            rs.getInt("vote_count")
        );
    }
}