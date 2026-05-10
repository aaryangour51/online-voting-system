package com.voting.model;
public class Candidate {
    private int id;
    private String name;
    private String party;
    private String description;
    private String imageUrl;
    private int voteCount;

    public Candidate() {}

    public Candidate(int id, String name, String party, String description,
                     String imageUrl, int voteCount) {
        this.id = id;
        this.name = name;
        this.party = party;
        this.description = description;
        this.imageUrl = imageUrl;
        this.voteCount = voteCount;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getParty() { return party; }
    public void setParty(String party) { this.party = party; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public int getVoteCount() { return voteCount; }
    public void setVoteCount(int voteCount) { this.voteCount = voteCount; }
}