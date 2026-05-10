<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.voting.model.User" %>
<%@ page import="com.voting.model.Candidate" %>
<%@ page import="com.voting.dao.CandidateDAO" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    CandidateDAO dao = new CandidateDAO();
    List<Candidate> candidates = dao.getAllCandidates();
    int totalVotes = dao.getTotalVotes();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Panel - VoteSystem</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            min-height: 100vh;
            color: #ffffff;
        }

        /* ===== NAVBAR ===== */
        nav {
            background: rgba(255,255,255,0.05);
            backdrop-filter: blur(10px);
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid rgba(255,255,255,0.1);
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

        .nav-brand span { color: #ffffff; }

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

        .nav-link:hover { color: #e94560; }

        .admin-badge {
            background: rgba(233,69,96,0.2);
            color: #e94560;
            border: 1px solid rgba(233,69,96,0.4);
            padding: 0.3rem 0.9rem;
            border-radius: 25px;
            font-size: 0.8rem;
            font-weight: 700;
        }

        .btn-logout {
            background: rgba(233,69,96,0.2);
            color: #e94560;
            border: 1px solid rgba(233,69,96,0.4);
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
            margin-bottom: 2rem;
            animation: fadeIn 0.5s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .page-header h1 {
            font-size: 2rem;
            font-weight: 900;
            margin-bottom: 0.3rem;
        }

        .page-header h1 span { color: #e94560; }

        .page-header p {
            color: rgba(255,255,255,0.5);
            font-size: 0.95rem;
        }

        /* ===== QUICK LINKS ===== */
        .quick-links {
            display: flex;
            gap: 0.8rem;
            flex-wrap: wrap;
            margin-bottom: 2rem;
        }

        .quick-link {
            background: rgba(255,255,255,0.06);
            border: 1px solid rgba(255,255,255,0.12);
            color: rgba(255,255,255,0.7);
            padding: 0.55rem 1.2rem;
            border-radius: 25px;
            font-size: 0.85rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s;
        }

        .quick-link:hover {
            background: rgba(233,69,96,0.15);
            border-color: rgba(233,69,96,0.4);
            color: #e94560;
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
            background: rgba(22,163,74,0.15);
            border: 1px solid rgba(22,163,74,0.35);
            color: #4ade80;
        }

        .alert-error {
            background: rgba(233,69,96,0.15);
            border: 1px solid rgba(233,69,96,0.4);
            color: #ff6b81;
        }

        /* ===== STATS GRID ===== */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 1.2rem;
            margin-bottom: 2.5rem;
        }

        .stat-card {
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 16px;
            padding: 1.5rem;
            text-align: center;
            transition: all 0.3s;
        }

        .stat-card:hover {
            background: rgba(255,255,255,0.08);
            transform: translateY(-3px);
        }

        .stat-icon {
            font-size: 2.2rem;
            display: block;
            margin-bottom: 0.6rem;
        }

        .stat-card h3 {
            color: rgba(255,255,255,0.5);
            font-size: 0.78rem;
            font-weight: 600;
            letter-spacing: 1px;
            text-transform: uppercase;
            margin-bottom: 0.4rem;
        }

        .stat-value {
            font-size: 1.8rem;
            font-weight: 900;
            color: #e94560;
        }

        .stat-value.blue   { color: #60a5fa; }
        .stat-value.green  { color: #4ade80; }
        .stat-value.yellow { color: #facc15; font-size: 1rem; margin-top: 0.3rem; }

        /* ===== MAIN GRID ===== */
        .main-grid {
            display: grid;
            grid-template-columns: 1fr 1.6fr;
            gap: 1.5rem;
            align-items: start;
        }

        @media (max-width: 800px) {
            .main-grid { grid-template-columns: 1fr; }
        }

        /* ===== PANEL ===== */
        .panel {
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 20px;
            padding: 1.8rem;
            animation: fadeIn 0.5s ease;
        }

        .panel-title {
            font-size: 1.1rem;
            font-weight: 800;
            margin-bottom: 1.5rem;
            padding-bottom: 0.8rem;
            border-bottom: 1px solid rgba(255,255,255,0.08);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        /* ===== FORM ===== */
        .form-group {
            margin-bottom: 1.1rem;
        }

        .form-group label {
            display: block;
            color: rgba(255,255,255,0.6);
            font-size: 0.85rem;
            font-weight: 600;
            margin-bottom: 0.45rem;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 0.8rem 1rem;
            background: rgba(255,255,255,0.07);
            border: 1.5px solid rgba(255,255,255,0.12);
            border-radius: 10px;
            color: #ffffff;
            font-size: 0.92rem;
            transition: all 0.3s;
            outline: none;
            font-family: inherit;
        }

        .form-group input::placeholder,
        .form-group textarea::placeholder {
            color: rgba(255,255,255,0.25);
        }

        .form-group input:focus,
        .form-group textarea:focus {
            border-color: #e94560;
            background: rgba(233,69,96,0.07);
            box-shadow: 0 0 0 3px rgba(233,69,96,0.12);
        }

        .form-group textarea {
            resize: vertical;
            min-height: 90px;
        }

        .btn-add {
            width: 100%;
            padding: 0.9rem;
            background: linear-gradient(135deg, #e94560, #c0392b);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s;
            box-shadow: 0 6px 20px rgba(233,69,96,0.3);
            margin-top: 0.5rem;
        }

        .btn-add:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 28px rgba(233,69,96,0.45);
        }

        /* ===== CANDIDATES LIST ===== */
        .candidates-list {
            display: flex;
            flex-direction: column;
            gap: 0.9rem;
        }

        .candidate-row {
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 14px;
            padding: 1rem 1.2rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            transition: all 0.3s;
        }

        .candidate-row:hover {
            background: rgba(255,255,255,0.07);
            border-color: rgba(255,255,255,0.15);
        }

        .candidate-avatar {
            width: 46px;
            height: 46px;
            border-radius: 50%;
            background: linear-gradient(135deg, #e94560, #c0392b);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.3rem;
            font-weight: 900;
            flex-shrink: 0;
            color: white;
        }

        .candidate-details { flex: 1; min-width: 0; }

        .candidate-name {
            font-size: 1rem;
            font-weight: 700;
            color: #ffffff;
            margin-bottom: 0.2rem;
        }

        .candidate-party {
            display: inline-block;
            background: rgba(233,69,96,0.12);
            color: #e94560;
            border: 1px solid rgba(233,69,96,0.25);
            padding: 0.15rem 0.6rem;
            border-radius: 999px;
            font-size: 0.72rem;
            font-weight: 700;
        }

        .candidate-votes {
            text-align: center;
            flex-shrink: 0;
        }

        .v-count {
            font-size: 1.3rem;
            font-weight: 900;
            color: #60a5fa;
            display: block;
        }

        .v-label {
            font-size: 0.7rem;
            color: rgba(255,255,255,0.35);
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .btn-delete {
            background: rgba(233,69,96,0.12);
            color: #e94560;
            border: 1px solid rgba(233,69,96,0.3);
            padding: 0.45rem 0.9rem;
            border-radius: 8px;
            font-size: 0.82rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s;
            flex-shrink: 0;
        }

        .btn-delete:hover {
            background: #e94560;
            color: white;
        }

        /* ===== MINI CHART ===== */
        .mini-result {
            display: flex;
            align-items: center;
            gap: 0.8rem;
            margin-bottom: 0.9rem;
        }

        .mini-name {
            font-size: 0.88rem;
            font-weight: 600;
            color: rgba(255,255,255,0.8);
            min-width: 80px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .mini-bar-wrap {
            flex: 1;
            height: 8px;
            background: rgba(255,255,255,0.08);
            border-radius: 999px;
            overflow: hidden;
        }

        .mini-bar-fill {
            height: 100%;
            border-radius: 999px;
            background: linear-gradient(90deg, #e94560, #c0392b);
        }

        .mini-pct {
            font-size: 0.8rem;
            font-weight: 700;
            color: rgba(255,255,255,0.5);
            min-width: 35px;
            text-align: right;
        }

        /* ===== EMPTY STATE ===== */
        .empty-state {
            text-align: center;
            padding: 2.5rem 1rem;
            color: rgba(255,255,255,0.35);
        }

        .empty-state span {
            font-size: 3rem;
            display: block;
            margin-bottom: 0.8rem;
        }

        /* ===== FOOTER ===== */
        .page-footer {
            text-align: center;
            color: rgba(255,255,255,0.25);
            font-size: 0.8rem;
            padding: 2rem 0 1rem;
        }

        @media (max-width: 600px) {
            nav { flex-direction: column; gap: 0.8rem; }
            .candidate-row { flex-wrap: wrap; }
        }
    </style>
</head>
<body>

    <!-- NAVBAR -->
    <nav>
        <a href="${pageContext.request.contextPath}/index.jsp"
           class="nav-brand">🗳️ Vote<span>System</span></a>
        <div class="nav-right">
            <span class="admin-badge">🛡️ Admin</span>
            <a href="${pageContext.request.contextPath}/results"
               class="nav-link">📊 Results</a>
            <a href="${pageContext.request.contextPath}/logout"
               class="btn-logout">🚪 Logout</a>
        </div>
    </nav>

    <!-- CONTAINER -->
    <div class="container">

        <!-- PAGE HEADER -->
        <div class="page-header">
            <h1>🛡️ Admin <span>Panel</span></h1>
            <p>Manage candidates and monitor voting activity</p>
        </div>

        <!-- QUICK LINKS -->
        <div class="quick-links">
            <a href="${pageContext.request.contextPath}/results"
               class="quick-link">📊 Live Results</a>
            <a href="${pageContext.request.contextPath}/candidates.jsp"
               class="quick-link">👥 Candidates Page</a>
            <a href="${pageContext.request.contextPath}/index.jsp"
               class="quick-link">🏠 Home</a>
        </div>

        <!-- ALERTS -->
        <% if ("added".equals(request.getParameter("success"))) { %>
            <div class="alert alert-success">✅ Candidate added successfully!</div>
        <% } %>
        <% if ("deleted".equals(request.getParameter("success"))) { %>
            <div class="alert alert-success">✅ Candidate deleted successfully!</div>
        <% } %>
        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-error">❌ Something went wrong. Try again.</div>
        <% } %>

        <!-- STATS -->
        <div class="stats-grid">
            <div class="stat-card">
                <span class="stat-icon">👥</span>
                <h3>Candidates</h3>
                <div class="stat-value blue"><%= candidates.size() %></div>
            </div>
            <div class="stat-card">
                <span class="stat-icon">🗳️</span>
                <h3>Total Votes</h3>
                <div class="stat-value"><%= totalVotes %></div>
            </div>
            <div class="stat-card">
                <span class="stat-icon">🏆</span>
                <h3>Leading</h3>
                <div class="stat-value yellow">
                    <% if (!candidates.isEmpty() && totalVotes > 0) { %>
                        <%= candidates.get(0).getName().split(" ")[0] %>
                    <% } else { %>
                        N/A
                    <% } %>
                </div>
            </div>
            <div class="stat-card">
                <span class="stat-icon">📊</span>
                <h3>Status</h3>
                <div class="stat-value green" style="font-size:1rem; margin-top:0.3rem;">
                    <%= totalVotes > 0 ? "Active" : "No Votes" %>
                </div>
            </div>
        </div>

        <!-- MAIN GRID -->
        <div class="main-grid">

            <!-- LEFT: ADD FORM -->
            <div class="panel">
                <div class="panel-title">➕ Add New Candidate</div>

                <form action="${pageContext.request.contextPath}/candidate"
                      method="post">
                    <input type="hidden" name="action" value="add">

                    <div class="form-group">
                        <label>Full Name *</label>
                        <input type="text" name="name"
                               placeholder="e.g. John Smith" required>
                    </div>

                    <div class="form-group">
                        <label>Party Name *</label>
                        <input type="text" name="party"
                               placeholder="e.g. Progressive Party" required>
                    </div>

                    <div class="form-group">
                        <label>Description</label>
                        <textarea name="description"
                                  placeholder="Brief bio..."></textarea>
                    </div>

                    <div class="form-group">
                        <label>Image URL (optional)</label>
                        <input type="url" name="imageUrl"
                               placeholder="https://example.com/photo.jpg">
                    </div>

                    <button type="submit" class="btn-add">
                        ➕ Add Candidate
                    </button>
                </form>

                <!-- MINI CHART -->
                <% if (!candidates.isEmpty() && totalVotes > 0) { %>
                    <div class="panel-title" style="margin-top:1.5rem;">
                        📊 Vote Distribution
                    </div>
                    <% for (Candidate c : candidates) {
                        double pct = (c.getVoteCount() * 100.0 / totalVotes);
                    %>
                        <div class="mini-result">
                            <span class="mini-name">
                                <%= c.getName().split(" ")[0] %>
                            </span>
                            <div class="mini-bar-wrap">
                                <div class="mini-bar-fill"
                                     style="width:<%= String.format("%.1f", pct) %>%">
                                </div>
                            </div>
                            <span class="mini-pct">
                                <%= String.format("%.0f", pct) %>%
                            </span>
                        </div>
                    <% } %>
                <% } %>
            </div>

            <!-- RIGHT: CANDIDATES LIST -->
            <div class="panel">
                <div class="panel-title">
                    👥 Manage Candidates
                    <span style="margin-left:auto; font-size:0.85rem;
                                 color:rgba(255,255,255,0.4); font-weight:500;">
                        <%= candidates.size() %> total
                    </span>
                </div>

                <% if (candidates.isEmpty()) { %>
                    <div class="empty-state">
                        <span>🚫</span>
                        <p>No candidates yet. Add one!</p>
                    </div>
                <% } else { %>
                    <div class="candidates-list">
                        <% for (Candidate c : candidates) { %>
                            <div class="candidate-row">

                                <div class="candidate-avatar">
                                    <%= c.getName().charAt(0) %>
                                </div>

                                <div class="candidate-details">
                                    <div class="candidate-name">
                                        <%= c.getName() %>
                                    </div>
                                    <span class="candidate-party">
                                        <%= c.getParty() %>
                                    </span>
                                </div>

                                <div class="candidate-votes">
                                    <span class="v-count">
                                        <%= c.getVoteCount() %>
                                    </span>
                                    <span class="v-label">votes</span>
                                </div>

                                <form action="${pageContext.request.contextPath}/candidate"
                                      method="post"
                                      onsubmit="return confirmDelete('<%= c.getName() %>')">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="<%= c.getId() %>">
                                    <button type="submit" class="btn-delete">
                                        🗑️ Delete
                                    </button>
                                </form>

                            </div>
                        <% } %>
                    </div>
                <% } %>
            </div>

        </div>

        <!-- FOOTER -->
        <div class="page-footer">
            🛡️ Admin Panel &nbsp;|&nbsp; VoteSystem &copy; 2025
        </div>

    </div>

    <script>
        function confirmDelete(name) {
            return confirm('Delete "' + name + '"? This cannot be undone.');
        }

        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('.alert').forEach(function(alert) {
                setTimeout(function() {
                    alert.style.transition = 'opacity 0.5s';
                    alert.style.opacity = '0';
                    setTimeout(function() { alert.remove(); }, 500);
                }, 4000);
            });
        });
    </script>

</body>
</html>