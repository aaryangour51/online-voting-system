<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.voting.model.User" %>
<%

User user = (User) session.getAttribute("user");

if (user == null) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}

%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - VoteSystem</title>
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
            gap: 1.2rem;
        }

        .nav-user {
            color: rgba(255,255,255,0.7);
            font-size: 0.9rem;
        }

        .nav-user strong {
            color: #ffffff;
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

        /* ===== MAIN CONTAINER ===== */
        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 2.5rem 1.5rem;
        }

        /* ===== WELCOME BANNER ===== */
        .welcome-banner {
            background: linear-gradient(135deg,
                rgba(233, 69, 96, 0.25) 0%,
                rgba(15, 52, 96, 0.4) 100%);
            border: 1px solid rgba(233, 69, 96, 0.3);
            border-radius: 20px;
            padding: 2rem 2.5rem;
            margin-bottom: 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
            animation: fadeIn 0.5s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .welcome-text h1 {
            font-size: 1.8rem;
            font-weight: 800;
            margin-bottom: 0.3rem;
        }

        .welcome-text h1 span {
            color: #e94560;
        }

        .welcome-text p {
            color: rgba(255,255,255,0.6);
            font-size: 0.95rem;
        }

        .voter-id-badge {
            background: rgba(255,255,255,0.08);
            border: 1px solid rgba(255,255,255,0.15);
            border-radius: 12px;
            padding: 0.8rem 1.4rem;
            text-align: center;
        }

        .voter-id-badge p {
            color: rgba(255,255,255,0.5);
            font-size: 0.75rem;
            letter-spacing: 1px;
            text-transform: uppercase;
            margin-bottom: 0.2rem;
        }

        .voter-id-badge strong {
            color: #e94560;
            font-size: 1.1rem;
            letter-spacing: 2px;
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

        /* ===== STATUS CARDS ===== */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.2rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 16px;
            padding: 1.5rem;
            text-align: center;
            transition: all 0.3s;
            animation: fadeIn 0.6s ease;
        }

        .stat-card:hover {
            background: rgba(255, 255, 255, 0.08);
            transform: translateY(-4px);
            border-color: rgba(233, 69, 96, 0.4);
        }

        .stat-icon {
            font-size: 2.5rem;
            display: block;
            margin-bottom: 0.8rem;
        }

        .stat-card h3 {
            color: rgba(255,255,255,0.55);
            font-size: 0.8rem;
            font-weight: 600;
            letter-spacing: 1px;
            text-transform: uppercase;
            margin-bottom: 0.4rem;
        }

        .stat-value {
            font-size: 1.1rem;
            font-weight: 800;
        }

        .stat-value.voted    { color: #4ade80; }
        .stat-value.pending  { color: #e94560; }
        .stat-value.blue     { color: #60a5fa; }
        .stat-value.yellow   { color: #facc15; }

        /* ===== ACTION SECTION ===== */
        .section-title {
            font-size: 1.2rem;
            font-weight: 700;
            color: rgba(255,255,255,0.85);
            margin-bottom: 1.2rem;
            padding-bottom: 0.5rem;
            border-bottom: 1px solid rgba(255,255,255,0.08);
        }

        .action-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 1.2rem;
            margin-bottom: 2rem;
        }

        .action-card {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 18px;
            padding: 2rem 1.5rem;
            text-align: center;
            text-decoration: none;
            transition: all 0.3s;
            display: block;
            position: relative;
            overflow: hidden;
        }

        .action-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 3px;
            background: linear-gradient(90deg, #e94560, #c0392b);
            transform: scaleX(0);
            transition: transform 0.3s;
        }

        .action-card:hover::before {
            transform: scaleX(1);
        }

        .action-card:hover {
            background: rgba(233, 69, 96, 0.1);
            border-color: rgba(233, 69, 96, 0.4);
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(233, 69, 96, 0.15);
        }

        .action-card.disabled {
            opacity: 0.5;
            cursor: not-allowed;
            pointer-events: none;
        }

        .action-card.green-card:hover {
            background: rgba(22, 163, 74, 0.1);
            border-color: rgba(22, 163, 74, 0.4);
            box-shadow: 0 15px 40px rgba(22, 163, 74, 0.15);
        }

        .action-card.green-card::before {
            background: linear-gradient(90deg, #16a34a, #15803d);
        }

        .action-card.blue-card:hover {
            background: rgba(37, 99, 235, 0.1);
            border-color: rgba(37, 99, 235, 0.4);
            box-shadow: 0 15px 40px rgba(37, 99, 235, 0.15);
        }

        .action-card.blue-card::before {
            background: linear-gradient(90deg, #2563eb, #1d4ed8);
        }

        .action-icon {
            font-size: 3rem;
            display: block;
            margin-bottom: 1rem;
        }

        .action-card h3 {
            color: #ffffff;
            font-size: 1.1rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .action-card p {
            color: rgba(255,255,255,0.5);
            font-size: 0.88rem;
            line-height: 1.5;
        }

        .action-btn {
            display: inline-block;
            margin-top: 1.2rem;
            padding: 0.55rem 1.4rem;
            border-radius: 25px;
            font-size: 0.85rem;
            font-weight: 700;
            background: rgba(233, 69, 96, 0.2);
            color: #e94560;
            border: 1px solid rgba(233, 69, 96, 0.4);
            transition: all 0.3s;
        }

        .action-card:hover .action-btn {
            background: #e94560;
            color: white;
        }

        .action-btn.green {
            background: rgba(22, 163, 74, 0.2);
            color: #4ade80;
            border-color: rgba(22, 163, 74, 0.4);
        }

        .action-card.green-card:hover .action-btn.green {
            background: #16a34a;
            color: white;
        }

        .action-btn.blue {
            background: rgba(37, 99, 235, 0.2);
            color: #60a5fa;
            border-color: rgba(37, 99, 235, 0.4);
        }

        .action-card.blue-card:hover .action-btn.blue {
            background: #2563eb;
            color: white;
        }

        /* ===== VOTED SUCCESS BOX ===== */
        .voted-box {
            background: linear-gradient(135deg,
                rgba(22, 163, 74, 0.15),
                rgba(15, 52, 96, 0.3));
            border: 1px solid rgba(22, 163, 74, 0.35);
            border-radius: 18px;
            padding: 2rem;
            text-align: center;
            margin-bottom: 2rem;
            animation: fadeIn 0.5s ease;
        }

        .voted-box .big-icon {
            font-size: 4rem;
            display: block;
            margin-bottom: 1rem;
        }

        .voted-box h3 {
            color: #4ade80;
            font-size: 1.4rem;
            font-weight: 800;
            margin-bottom: 0.5rem;
        }

        .voted-box p {
            color: rgba(255,255,255,0.6);
            font-size: 0.95rem;
        }

        /* ===== FOOTER ===== */
        .dashboard-footer {
            text-align: center;
            color: rgba(255,255,255,0.25);
            font-size: 0.8rem;
            padding: 2rem 0 1rem;
        }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 600px) {
            .welcome-banner {
                flex-direction: column;
                text-align: center;
            }
            .welcome-text h1 {
                font-size: 1.4rem;
            }
            nav {
                flex-direction: column;
                gap: 0.8rem;
                text-align: center;
            }
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
            <span class="nav-user">
                👤 <strong><%= user.getFullName() %></strong>
            </span>
               <a href="${pageContext.request.contextPath}/logout" class="btn-logout">                🚪 Logout
            </a>
        </div>
    </nav>

    <!-- MAIN CONTAINER -->
    <div class="container">

        <!-- WELCOME BANNER -->
        <div class="welcome-banner">
            <div class="welcome-text">
                <h1>Hello, <span><%= user.getFullName().split(" ")[0] %></span> 👋</h1>
                <p>Welcome to your voter dashboard. Cast your vote below.</p>
            </div>
            <div class="voter-id-badge">
                <p>Voter ID</p>
                <strong><%= user.getVoterId() %></strong>
            </div>
        </div>

        <!-- VOTED SUCCESS ALERT -->
        <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success">
                ✅ Your vote has been successfully recorded!
            </div>
        <% } %>

        <!-- ALREADY VOTED WARNING -->
        <% if (user.isHasVoted()) { %>
            <div class="voted-box">
                <span class="big-icon">✅</span>
                <h3>You have already voted!</h3>
                <p>Your vote has been securely recorded. Thank you for participating.</p>
            </div>
        <% } %>

        <!-- STATS CARDS -->
        <div class="stats-grid">
            <div class="stat-card">
                <span class="stat-icon">🗳️</span>
                <h3>Voting Status</h3>
                <div class="stat-value <%= user.isHasVoted() ? "voted" : "pending" %>">
                    <%= user.isHasVoted() ? "✅ Voted" : "⏳ Pending" %>
                </div>
            </div>
            <div class="stat-card">
                <span class="stat-icon">🪪</span>
                <h3>Voter ID</h3>
                <div class="stat-value blue"><%= user.getVoterId() %></div>
            </div>
            <div class="stat-card">
                <span class="stat-icon">👤</span>
                <h3>Account Role</h3>
                <div class="stat-value yellow"><%= user.getRole().toUpperCase() %></div>
            </div>
            <div class="stat-card">
                <span class="stat-icon">📧</span>
                <h3>Email</h3>
                <div class="stat-value blue" style="font-size:0.85rem;">
                    <%= user.getEmail() %>
                </div>
            </div>
        </div>

        <!-- ACTION CARDS -->
        <div class="section-title">📋 Quick Actions</div>
        <div class="action-grid">

            <!-- CAST VOTE -->
            <% if (!user.isHasVoted()) { %>
                <div class="action-card" onclick="window.location='${pageContext.request.contextPath}/vote.jsp'">
                    <span class="action-icon">🗳️</span>
                    <h3>Cast Your Vote</h3>
                    <p>Choose your preferred candidate and submit your vote securely.</p>
                    <span class="action-btn">Vote Now →</span>
                </div>
            <% } else { %>
                <div class="action-card disabled">
                    <span class="action-icon">🗳️</span>
                    <h3>Cast Your Vote</h3>
                    <p>You have already cast your vote. Thank you!</p>
                    <span class="action-btn">Already Voted</span>
                </div>
            <% } %>

            <!-- VIEW CANDIDATES -->
            <div class="action-card green-card" onclick="window.location='${pageContext.request.contextPath}/candidates.jsp'">
                <span class="action-icon">👥</span>
                <h3>View Candidates</h3>
                <p>Learn about all candidates before making your decision.</p>
                <span class="action-btn green">View All →</span>
            </div>

            <!-- VIEW RESULTS -->
            <div class="action-card blue-card" onclick="window.location='${pageContext.request.contextPath}/result.jsp'">
                <span class="action-icon">📊</span>
                <h3>Live Results</h3>
                <p>See real-time voting results and current standings.</p>
                <span class="action-btn blue">View Results →</span>
            </div>

        </div>
        <!-- FOOTER -->
        <div class="dashboard-footer">
            🔒 Your vote is encrypted and securely stored &nbsp;|&nbsp;
            &copy; 2025 VoteSystem
        </div>

    </div>

</body>
</html>