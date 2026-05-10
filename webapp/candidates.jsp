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
    List<Candidate> candidates = dao.getAllCandidates();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Candidates - VoteSystem</title>
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
            max-width: 1100px;
            margin: 0 auto;
            padding: 2.5rem 1.5rem;
        }

        /* ===== PAGE HEADER ===== */
        .page-header {
            text-align: center;
            margin-bottom: 3rem;
            animation: fadeIn 0.5s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-15px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .page-header .header-icon {
            font-size: 4rem;
            display: block;
            margin-bottom: 0.8rem;
        }

        .page-header h1 {
            font-size: 2.3rem;
            font-weight: 900;
            margin-bottom: 0.5rem;
        }

        .page-header h1 span {
            color: #e94560;
        }

        .page-header p {
            color: rgba(255,255,255,0.55);
            font-size: 1rem;
            max-width: 500px;
            margin: 0 auto;
        }

        /* ===== SEARCH BAR ===== */
        .search-wrap {
            max-width: 420px;
            margin: 0 auto 2.5rem;
            position: relative;
        }

        .search-wrap input {
            width: 100%;
            padding: 0.85rem 1rem 0.85rem 2.8rem;
            background: rgba(255,255,255,0.07);
            border: 1.5px solid rgba(255,255,255,0.12);
            border-radius: 50px;
            color: #ffffff;
            font-size: 0.95rem;
            outline: none;
            transition: all 0.3s;
        }

        .search-wrap input::placeholder {
            color: rgba(255,255,255,0.3);
        }

        .search-wrap input:focus {
            border-color: #e94560;
            background: rgba(233,69,96,0.07);
            box-shadow: 0 0 0 3px rgba(233,69,96,0.12);
        }

        .search-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            font-size: 1rem;
            pointer-events: none;
        }

        /* ===== STATS BAR ===== */
        .stats-bar {
            display: flex;
            justify-content: center;
            gap: 2rem;
            margin-bottom: 2.5rem;
            flex-wrap: wrap;
        }

        .stats-bar-item {
            text-align: center;
        }

        .stats-bar-item .s-value {
            font-size: 1.8rem;
            font-weight: 900;
            color: #e94560;
            display: block;
        }

        .stats-bar-item .s-label {
            font-size: 0.78rem;
            color: rgba(255,255,255,0.45);
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .stats-divider {
            width: 1px;
            background: rgba(255,255,255,0.1);
            height: 40px;
            align-self: center;
        }

        /* ===== CANDIDATES GRID ===== */
        .candidates-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 1.5rem;
            margin-bottom: 3rem;
        }

        /* ===== CANDIDATE CARD ===== */
        .candidate-card {
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 22px;
            padding: 2rem 1.5rem;
            text-align: center;
            transition: all 0.35s;
            position: relative;
            overflow: hidden;
            animation: cardFadeIn 0.5s ease both;
        }

        @keyframes cardFadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .candidate-card:hover {
            background: rgba(255,255,255,0.08);
            border-color: rgba(233,69,96,0.45);
            transform: translateY(-8px);
            box-shadow: 0 20px 50px rgba(233,69,96,0.15);
        }

        /* Top accent line */
        .candidate-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 3px;
            background: linear-gradient(90deg, #e94560, #c0392b);
            transform: scaleX(0);
            transition: transform 0.35s;
        }

        .candidate-card:hover::before {
            transform: scaleX(1);
        }

        /* Number badge */
        .card-number {
            position: absolute;
            top: 1rem;
            left: 1rem;
            width: 26px;
            height: 26px;
            background: rgba(255,255,255,0.08);
            border: 1px solid rgba(255,255,255,0.12);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.75rem;
            font-weight: 700;
            color: rgba(255,255,255,0.45);
        }

        /* Avatar */
        .candidate-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: linear-gradient(135deg, #e94560, #c0392b);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.2rem;
            font-weight: 900;
            margin: 0 auto 1.2rem;
            color: white;
            box-shadow: 0 10px 25px rgba(233,69,96,0.35);
            transition: transform 0.3s;
        }

        .candidate-card:hover .candidate-avatar {
            transform: scale(1.08);
        }

        /* Name */
        .candidate-name {
            font-size: 1.2rem;
            font-weight: 800;
            color: #ffffff;
            margin-bottom: 0.4rem;
        }

        /* Party Badge */
        .party-badge {
            display: inline-block;
            background: rgba(233,69,96,0.15);
            color: #e94560;
            border: 1px solid rgba(233,69,96,0.3);
            padding: 0.28rem 0.9rem;
            border-radius: 999px;
            font-size: 0.78rem;
            font-weight: 700;
            margin-bottom: 1rem;
            letter-spacing: 0.5px;
        }

        /* Divider */
        .card-divider {
            width: 40px;
            height: 2px;
            background: rgba(255,255,255,0.1);
            margin: 0 auto 1rem;
            border-radius: 2px;
        }

        /* Description */
        .candidate-desc {
            color: rgba(255,255,255,0.5);
            font-size: 0.88rem;
            line-height: 1.7;
            margin-bottom: 1.5rem;
            min-height: 60px;
        }

        /* Vote Button */
        .vote-btn {
            display: inline-block;
            padding: 0.7rem 1.8rem;
            background: linear-gradient(135deg, #e94560, #c0392b);
            color: white;
            border-radius: 50px;
            font-size: 0.9rem;
            font-weight: 700;
            text-decoration: none;
            transition: all 0.3s;
            box-shadow: 0 5px 15px rgba(233,69,96,0.3);
            border: none;
            cursor: pointer;
        }

        .vote-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 22px rgba(233,69,96,0.45);
        }

        .vote-btn.disabled {
            background: rgba(255,255,255,0.08);
            color: rgba(255,255,255,0.35);
            cursor: not-allowed;
            box-shadow: none;
            pointer-events: none;
        }

        .voted-tag {
            display: inline-block;
            background: rgba(22,163,74,0.15);
            color: #4ade80;
            border: 1px solid rgba(22,163,74,0.3);
            padding: 0.5rem 1.2rem;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 700;
        }

        /* ===== NO CANDIDATES ===== */
        .no-candidates {
            text-align: center;
            padding: 4rem 2rem;
            color: rgba(255,255,255,0.35);
            grid-column: 1 / -1;
        }

        .no-candidates span {
            font-size: 4rem;
            display: block;
            margin-bottom: 1rem;
        }

        /* ===== BOTTOM ACTION ===== */
        .bottom-action {
            text-align: center;
            margin-bottom: 2rem;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.85rem 2rem;
            border-radius: 50px;
            font-size: 0.95rem;
            font-weight: 700;
            text-decoration: none;
            transition: all 0.3s;
        }

        .btn-primary {
            background: linear-gradient(135deg, #e94560, #c0392b);
            color: white;
            box-shadow: 0 6px 20px rgba(233,69,96,0.35);
            margin-right: 0.8rem;
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
            padding: 1rem 0 2rem;
        }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 600px) {
            .page-header h1 { font-size: 1.7rem; }
            .candidates-grid { grid-template-columns: 1fr; }
            nav { flex-direction: column; gap: 0.8rem; }
            .stats-divider { display: none; }
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
            <span class="header-icon">👥</span>
            <h1>Meet the <span>Candidates</span></h1>
            <p>Learn about each candidate before casting your vote wisely.</p>
        </div>

        <!-- SEARCH BAR -->
        <div class="search-wrap">
            <span class="search-icon">🔍</span>
            <input type="text"
                   id="searchInput"
                   placeholder="Search candidates or parties..."
                   onkeyup="filterCandidates()">
        </div>

        <!-- STATS BAR -->
        <div class="stats-bar">
            <div class="stats-bar-item">
                <span class="s-value"><%= candidates.size() %></span>
                <span class="s-label">Candidates</span>
            </div>
            <div class="stats-divider"></div>
            <div class="stats-bar-item">
                <span class="s-value">
                    <%= user.isHasVoted() ? "✅" : "⏳" %>
                </span>
                <span class="s-label">Your Status</span>
            </div>
            <div class="stats-divider"></div>
            <div class="stats-bar-item">
                <span class="s-value" style="color:#4ade80;">1</span>
                <span class="s-label">Vote Each</span>
            </div>
        </div>

        <!-- CANDIDATES GRID -->
        <div class="candidates-grid" id="candidatesGrid">

            <% if (candidates == null || candidates.isEmpty()) { %>
                <div class="no-candidates">
                    <span>🚫</span>
                    <p>No candidates available at the moment.</p>
                </div>
            <% } else { %>
                <% int num = 1; for (Candidate c : candidates) { %>
                    <div class="candidate-card"
                         data-name="<%= c.getName().toLowerCase() %>"
                         data-party="<%= c.getParty().toLowerCase() %>"
                         style="animation-delay: <%= (num - 1) * 0.1 %>s">

                        <!-- Number -->
                        <div class="card-number">#<%= num %></div>

                        <!-- Avatar -->
                        <div class="candidate-avatar">
                            <%= c.getName().charAt(0) %>
                        </div>

                        <!-- Name -->
                        <div class="candidate-name"><%= c.getName() %></div>

                        <!-- Party -->
                        <span class="party-badge">🏛️ <%= c.getParty() %></span>

                        <!-- Divider -->
                        <div class="card-divider"></div>

                        <!-- Description -->
                        <div class="candidate-desc">
                            <%= c.getDescription() != null && !c.getDescription().isEmpty()
                                ? c.getDescription()
                                : "No description available for this candidate." %>
                        </div>

                        <!-- Action Button -->
                        <% if (user.isHasVoted()) { %>
                            <span class="voted-tag">✅ Vote Cast</span>
                        <% } else { %>
                            <a href="${pageContext.request.contextPath}/vote.jsp"
                               class="vote-btn">
                                🗳️ Vote Now
                            </a>
                        <% } %>

                    </div>
                <% num++; } %>
            <% } %>

        </div>

        <!-- BOTTOM ACTIONS -->
        <div class="bottom-action">
            <% if (!user.isHasVoted()) { %>
                <a href="${pageContext.request.contextPath}/vote.jsp"
                   class="btn btn-primary">
                    🗳️ Go to Voting
                </a>
            <% } %>
            <a href="${pageContext.request.contextPath}/dashboard.jsp"
               class="btn btn-outline">
                ← Back to Dashboard
            </a>
        </div>

        <!-- FOOTER -->
        <div class="page-footer">
            🔒 All information is verified and secure &nbsp;|&nbsp;
            &copy; 2025 VoteSystem
        </div>

    </div>

    <script>
        // Search / Filter candidates
        function filterCandidates() {
            const query = document.getElementById('searchInput')
                                  .value.toLowerCase().trim();
            const cards = document.querySelectorAll('.candidate-card');
            let found = 0;

            cards.forEach(function(card) {
                const name  = card.getAttribute('data-name')  || '';
                const party = card.getAttribute('data-party') || '';
                const match = name.includes(query) || party.includes(query);
                card.style.display = match ? '' : 'none';
                if (match) found++;
            });

            // Show empty message if nothing found
            let msg = document.getElementById('noResultMsg');
            if (found === 0) {
                if (!msg) {
                    msg = document.createElement('div');
                    msg.id = 'noResultMsg';
                    msg.style.cssText =
                        'text-align:center; color:rgba(255,255,255,0.4);' +
                        'padding:2rem; grid-column:1/-1; font-size:1rem;';
                    msg.innerHTML = '🔍 No candidates match "<strong>' +
                                    query + '</strong>"';
                    document.getElementById('candidatesGrid').appendChild(msg);
                }
            } else {
                if (msg) msg.remove();
            }
        }
    </script>

</body>
</html>