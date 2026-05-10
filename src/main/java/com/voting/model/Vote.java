package com.voting.model;

import java.sql.Timestamp;

public class Vote {
    private int id;
    private int userId;
    private int candidateId;
    private Timestamp votedAt;

    public Vote() {}

    public Vote(int id, int userId, int candidateId, Timestamp votedAt) {
        this.id = id;
        this.userId = userId;
        this.candidateId = candidateId;
        this.votedAt = votedAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getCandidateId() { return candidateId; }
    public void setCandidateId(int candidateId) { this.candidateId = candidateId; }

    public Timestamp getVotedAt() { return votedAt; }
    public void setVotedAt(Timestamp votedAt) { this.votedAt = votedAt; }
}