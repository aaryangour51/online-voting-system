package com.voting.model;
public class User {
    private int id;
    private String fullName;
    private String email;
    private String password;
    private String voterId;
    private String role;
    private boolean hasVoted;

    public User() {}

    public User(int id, String fullName, String email, String password,
                String voterId, String role, boolean hasVoted) {
        this.id = id;
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.voterId = voterId;
        this.role = role;
        this.hasVoted = hasVoted;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getVoterId() { return voterId; }
    public void setVoterId(String voterId) { this.voterId = voterId; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public boolean isHasVoted() { return hasVoted; }
    public void setHasVoted(boolean hasVoted) { this.hasVoted = hasVoted; }
}