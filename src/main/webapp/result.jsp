<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.voting.model.User" %>
<%@ page import="com.voting.model.Candidate" %>
<%@ page import="com.voting.dao.CandidateDAO" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    CandidateDAO dao = new CandidateDAO();
    List<Candidate> candidates = dao.getCandidatesWithResults();
    int totalVotes = dao.getTotalVotes();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Results - VoteSystem</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            min-height: 100vh;
            color: #ffffff;
        }

        /* ===== NAVBAR ===== */
        nav {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .nav-brand {
            color: #e94560;
            font-size: 1.4rem;
            font-weight: 800;
            text-decoration: none;
        }

        .nav-brand span {
            color: #ffffff;
        }

        .nav-right {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .nav-link {
            color: rgba(255,255,255,0.7);
            text-decoration: none;
            font-size: 0.9rem;
            transition: color 0.3s;
        }

        .nav-link:hover {
            color: #e94560;
        }

        .btn-logout {
            background: rgba(233, 69, 96, 0.2);
            color: #e94560;
            border: 1px solid rgba(233, 69, 96, 0.4);
            padding: 0.45rem 1.1rem;
            border-radius: 25px;
            font-size: 0.85rem;
            font-weight: 700;
            text-decoration: none;
            transition: all 0.3s;
        }

        .btn-logout:hover {
            background: #e94560;
            color: white;
        }

        /* ===== CONTAINER ===== */
        .container {
            max-width: 900px;
            margin: 0 auto;
            padding: 2.5rem 1.5rem;
        }

        /* ===== PAGE HEADER ===== */
        .page-header {
            text-align: center;
            margin-bottom: 2.5rem;
            animation: fadeIn 0.5s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .page-header .header-icon {
            font-size: 4rem;
            display: block;
            margin-bottom: 0.8rem;
        }

        .page-header h1 {
            font-size: 2.2rem;
            font-weight: 900;
            margin-bottom: 0.5rem;
        }

        .page-header h1 span {
            color: #e94560;
        }

        .page-header p {
            color: rgba(255,255,255,0.55);
            font-size: 1rem;
        }

        /* ===== ALERTS ===== */
        .alert {
            padding: 1rem 1.3rem;
            border-radius: 12px;
            margin-bottom: 1.5rem;
            font-weight: 600;
            font-size: 0.95rem;
            display: flex;
            align-items: center;
            gap: 0.6rem;
            animation: fadeIn 0.5s ease;
        }

        .alert-success {
            background: rgba(22, 163, 74, 0.15);
            border: 1px solid rgba(22, 163, 74, 0.35);
            color: #4ade80;
        }

        .alert-warning {
            background: rgba(234, 179, 8, 0.15);
            border: 1px solid rgba(234, 179, 8, 0.35);
            color: #facc15;
        }

        /* ===== STATS ROW ===== */
        .stats-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 1.2rem;
            margin-bottom: 2.5rem;
        }

        .stat-box {
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 16px;
            padding: 1.5rem;
            text-align: center;
            transition: all 0.3s;
        }

        .stat-box:hover {
            background: rgba(255,255,255,0.08);
            transform: translateY(-3px);
        }

        .stat-box .stat-icon {
            font-size: 2rem;
            display: block;
            margin-bottom: 0.5rem;
        }

        .stat-box h3 {
            color: rgba(255,255,255,0.5);
            font-size: 0.78rem;
            font-weight: 600;
            letter-spacing: 1px;
            text-transform: uppercase;
            margin-bottom: 0.4rem;
        }

        .stat-box .stat-value {
            font-size: 1.6rem;
            font-weight: 900;
            color: #e94560;
        }

        .stat-box .stat-value.green  { color: #4ade80; }
        .stat-box .stat-value.blue   { color: #60a5fa; }
        .stat-box .stat-value.yellow { color: #facc15; }

        /* ===== WINNER CARD ===== */
        .winner-card {
            background: linear-gradient(135deg,
                rgba(234, 179, 8, 0.15),
                rgba(15, 52, 96, 0.4));
            border: 1px solid rgba(234, 179, 8, 0.4);
            border-radius: 20px;
            padding: 2rem;
            text-align: center;
            margin-bottom: 2rem;
            animation: fadeIn 0.6s ease;
        }

        .winner-card .crown {
            font-size: 3rem;
            display: block;
            margin-bottom: 0.5rem;
        }

        .winner-card h2 {
            color: #facc15;
            font-size: 1rem;
            font-weight: 700;
            letter-spacing: 2px;
            text-transform: uppercase;
            margin-bottom: 0.5rem;
        }

        .winner-card .winner-name {
            font-size: 2rem;
            font-weight: 900;
            color: #ffffff;
            margin-bottom: 0.3rem;
        }

        .winner-card .winner-party {
            display: inline-block;
            background: rgba(234, 179, 8, 0.2);
            color: #facc15;
            border: 1px solid rgba(234, 179, 8, 0.4);
            padding: 0.3rem 1rem;
            border-radius: 999px;
            font-size: 0.85rem;
            font-weight: 700;
            margin-bottom: 0.8rem;
        }

        .winner-card .winner-votes {
            color: rgba(255,255,255,0.6);
            font-size: 0.95rem;
        }

        .winner-card .winner-votes strong {
            color: #facc15;
        }

        /* ===== RESULTS LIST ===== */
        .section-title {
            font-size: 1.1rem;
            font-weight: 700;
            color: rgba(255,255,255,0.7);
            margin-bottom: 1.2rem;
            padding-bottom: 0.5rem;
            border-bottom: 1px solid rgba(255,255,255,0.08);
        }

        .results-list {
            display: flex;
            flex-direction: column;
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .result-item {
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 16px;
            padding: 1.3rem 1.5rem;
            display: flex;
            align-items: center;
            gap: 1.2rem;
            transition: all 0.3s;
            animation: fadeIn 0.5s ease;
        }

        .result-item:hover {
            background: rgba(255,255,255,0.08);
            transform: translateX(5px);
        }

        .result-item.first-place {
            background: linear-gradient(135deg,
                rgba(234, 179, 8, 0.12),
                rgba(15, 52, 96, 0.3));
            border-color: rgba(234, 179, 8, 0.35);
        }

        .result-item.second-place {
            border-color: rgba(148, 163, 184, 0.3);
        }

        .result-item.third-place {
            border-color: rgba(180, 120, 60, 0.3);
        }

        /* Rank Badge */
        .rank-badge {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            font-weight: 900;
            flex-shrink: 0;
            background: rgba(255,255,255,0.08);
            color: rgba(255,255,255,0.5);
        }

        .rank-badge.gold   { background: rgba(234,179,8,0.2);  color: #facc15; }
        .rank-badge.silver { background: rgba(148,163,184,0.2); color: #94a3b8; }
        .rank-badge.bronze { background: rgba(180,120,60,0.2);  color: #b47c3c; }

        /* Avatar */
        .result-avatar {
            width: 52px;
            height: 52px;
            border-radius: 50%;
            background: linear-gradient(135deg, #e94560, #c0392b);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.4rem;
            font-weight: 900;
            flex-shrink: 0;
            color: white;
        }

        .result-avatar.gold-av   { background: linear-gradient(135deg, #facc15, #d97706); }
        .result-avatar.silver-av { background: linear-gradient(135deg, #94a3b8, #64748b); }
        .result-avatar.bronze-av { background: linear-gradient(135deg, #b47c3c, #92400e); }

        /* Info */
        .result-info {
            flex: 1;
            min-width: 0;
        }

        .result-name {
            font-size: 1.05rem;
            font-weight: 800;
            margin-bottom: 0.2rem;
            color: #ffffff;
        }

        .result-party {
            display: inline-block;
            background: rgba(233,69,96,0.12);
            color: #e94560;
            border: 1px solid rgba(233,69,96,0.25);
            padding: 0.15rem 0.65rem;
            border-radius: 999px;
            font-size: 0.75rem;
            font-weight: 700;
            margin-bottom: 0.6rem;
        }

        /* Progress Bar */
        .progress-wrap {
            display: flex;
            align-items: center;
            gap: 0.8rem;
        }

        .progress-bar {
            flex: 1;
            height: 10px;
            background: rgba(255,255,255,0.08);
            border-radius: 999px;
            overflow: hidden;
        }

        .progress-fill {
            height: 100%;
            border-radius: 999px;
            background: linear-gradient(90deg, #e94560, #c0392b);
            transition: width 1s ease;
        }

        .progress-fill.gold-fill   { background: linear-gradient(90deg, #facc15, #d97706); }
        .progress-fill.silver-fill { background: linear-gradient(90deg, #94a3b8, #64748b); }
        .progress-fill.bronze-fill { background: linear-gradient(90deg, #b47c3c, #92400e); }

        .progress-pct {
            font-size: 0.85rem;
            font-weight: 700;
            color: rgba(255,255,255,0.6);
            min-width: 42px;
            text-align: right;
        }

        /* Vote Count */
        .vote-count {
            text-align: right;
            flex-shrink: 0;
        }

        .vote-count .count {
            font-size: 1.5rem;
            font-weight: 900;
            color: #e94560;
            display: block;
        }

        .vote-count .label {
            font-size: 0.72rem;
            color: rgba(255,255,255,0.4);
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* ===== NO VOTES ===== */
        .no-votes {
            text-align: center;
            padding: 3rem;
            color: rgba(255,255,255,0.4);
        }

        .no-votes span {
            font-size: 3.5rem;
            display: block;
            margin-bottom: 1rem;
        }

        /* ===== ACTION BUTTONS ===== */
        .bottom-actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
            margin-top: 1rem;
        }

        .btn {
            padding: 0.85rem 2rem;
            border-radius: 50px;
            font-size: 0.95rem;
            font-weight: 700;
            text-decoration: none;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary {
            background: linear-gradient(135deg, #e94560, #c0392b);
            color: white;
            box-shadow: 0 6px 20px rgba(233,69,96,0.35);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 28px rgba(233,69,96,0.5);
        }

        .btn-outline {
            background: rgba(255,255,255,0.07);
            color: rgba(255,255,255,0.8);
            border: 1px solid rgba(255,255,255,0.2);
        }

        .btn-outline:hover {
            background: rgba(255,255,255,0.12);
            color: white;
            transform: translateY(-2px);
        }

        /* ===== FOOTER ===== */
        .page-footer {
            text-align: center;
            color: rgba(255,255,255,0.25);
            font-size: 0.8rem;
            padding: 2rem 0 1rem;
        }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 600px) {
            .page-header h1 { font-size: 1.6rem; }
            .result-item { flex-wrap: wrap; }
            .vote-count { width: 100%; text-align: left; }
            nav { flex-direction: column; gap: 0.8rem; }
        }
    </style>
</head>
<body>

    <!-- NAVBAR -->
    <nav>
        <a href="${pageContext.request.contextPath}/index.jsp" class="nav-brand">
            🗳️ Vote<span>System</span>
        </a>
        <div class="nav-right">
            <a href="${pageContext.request.contextPath}/dashboard.jsp"
               class="nav-link">← Dashboard</a>
            <a href="${pageContext.request.contextPath}/logout"
               class="btn-logout">🚪 Logout</a>
        </div>
    </nav>

    <!-- CONTAINER -->
    <div class="container">

        <!-- PAGE HEADER -->
        <div class="page-header">
            <span class="header-icon">📊</span>
            <h1>Live <span>Results</span></h1>
            <p>Real-time voting results — updated as votes are cast</p>
        </div>

        <!-- SUCCESS ALERT -->
        <% if ("voted".equals(request.getParameter("success"))) { %>
            <div class="alert alert-success">
                🎉 Your vote has been successfully recorded! Thank you for participating.
            </div>
        <% } %>

        <!-- ALREADY VOTED ALERT -->
        <% if ("alreadyvoted".equals(request.getParameter("error"))) { %>
            <div class="alert alert-warning">
                ⚠️ You have already cast your vote.
            </div>
        <% } %>

        <!-- STATS ROW -->
        <div class="stats-row">
            <div class="stat-box">
                <span class="stat-icon">🗳️</span>
                <h3>Total Votes</h3>
                <div class="stat-value"><%= totalVotes %></div>
            </div>
            <div class="stat-box">
                <span class="stat-icon">👥</span>
                <h3>Candidates</h3>
                <div class="stat-value blue"><%= candidates.size() %></div>
            </div>
            <div class="stat-box">
                <span class="stat-icon">✅</span>
                <h3>Your Status</h3>
                <div class="stat-value <%= user.isHasVoted() ? "green" : "" %>">
                    <%= user.isHasVoted() ? "Voted" : "Pending" %>
                </div>
            </div>
            <div class="stat-box">
                <span class="stat-icon">🏆</span>
                <h3>Leading</h3>
                <div class="stat-value yellow" style="font-size:1rem;">
                    <% if (!candidates.isEmpty() && totalVotes > 0) { %>
                        <%= candidates.get(0).getName().split(" ")[0] %>
                    <% } else { %>
                        N/A
                    <% } %>
                </div>
            </div>
        </div>

        <!-- WINNER CARD -->
        <% if (!candidates.isEmpty() && totalVotes > 0) {
            Candidate leader = candidates.get(0);
            double leaderPct = (leader.getVoteCount() * 100.0 / totalVotes);
        %>
            <div class="winner-card">
                <span class="crown">👑</span>
                <h2>🏆 Currently Leading</h2>
                <div class="winner-name"><%= leader.getName() %></div>
                <div class="winner-party"><%= leader.getParty() %></div>
                <div class="winner-votes">
                    <strong><%= leader.getVoteCount() %> votes</strong>
                    &nbsp;·&nbsp;
                    <strong><%= String.format("%.1f", leaderPct) %>%</strong>
                    of total votes
                </div>
            </div>
        <% } %>

        <!-- RESULTS LIST -->
        <div class="section-title">📋 All Candidates — Ranked by Votes</div>

        <% if (candidates.isEmpty()) { %>
            <div class="no-votes">
                <span>🚫</span>
                <p>No candidates or votes yet.</p>
            </div>
        <% } else { %>
            <div class="results-list">
            <%
                int rank = 1;
                for (Candidate c : candidates) {
                    double pct = (totalVotes > 0) ? (c.getVoteCount() * 100.0 / totalVotes) : 0;
                    String rankClass  = rank == 1 ? "first-place"  : rank == 2 ? "second-place" : rank == 3 ? "third-place" : "";
                    String badgeClass = rank == 1 ? "gold"   : rank == 2 ? "silver" : rank == 3 ? "bronze" : "";
                 // CORRECT - rank == 3 is a proper boolean condition
                    String avatarClass = rank == 1 ? "gold-av" : rank == 2 ? "silver-av" : rank == 3 ? "bronze-av" : "";                    String fillClass  = rank == 1 ? "gold-fill":rank == 2 ? "silver-fill":rank == 3 ? "bronze-fill":"";
                    String rankEmoji  = rank == 1 ? "🥇" : rank == 2 ? "🥈" : rank == 3 ? "🥉" : String.valueOf(rank);
            %>
                <div class="result-item <%= rankClass %>">

                    <!-- Rank -->
                    <div class="rank-badge <%= badgeClass %>">
                        <%= rankEmoji %>
                    </div>

                    <!-- Avatar -->
                    <div class="result-avatar <%= avatarClass %>">
                        <%= c.getName().charAt(0) %>
                    </div>

                    <!-- Info -->
                    <div class="result-info">
                        <div class="result-name"><%= c.getName() %></div>
                        <span class="result-party"><%= c.getParty() %></span>
                        <div class="progress-wrap">
                            <div class="progress-bar">
                                <div class="progress-fill <%= fillClass %>"
                                     style="width: <%= String.format("%.1f", pct) %>%">
                                </div>
                            </div>
                            <span class="progress-pct">
                                <%= String.format("%.1f", pct) %>%
                            </span>
                        </div>
                    </div>

                    <!-- Vote Count -->
                    <div class="vote-count">
                        <span class="count"><%= c.getVoteCount() %></span>
                        <span class="label">votes</span>
                    </div>

                </div>
            <% rank++; } %>
            </div>
        <% } %>

        <!-- BOTTOM ACTIONS -->
        <div class="bottom-actions">
            <% if (!user.isHasVoted()) { %>
                <a href="${pageContext.request.contextPath}/vote.jsp"
                   class="btn btn-primary">
                    🗳️ Cast Your Vote
                </a>
            <% } %>
            <a href="${pageContext.request.contextPath}/dashboard.jsp"
               class="btn btn-outline">
                ← Back to Dashboard
            </a>
        </div>

        <!-- FOOTER -->
        <div class="page-footer">
            🔒 Results are live and updated in real-time &nbsp;|&nbsp;
            &copy; 2025 VoteSystem
        </div>

    </div>
<!-- a href="${pageContext.request.contextPath}/dashboard.jsp">
    Back to Dashboard -->

</body>
</html>