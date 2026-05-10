<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.voting.model.User" %>
<%@ page import="com.voting.model.Candidate" %>
<%@ page import="com.voting.dao.CandidateDAO" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    if (user.isHasVoted()) {
        response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
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
    <title>Cast Your Vote - VoteSystem</title>
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
            max-width: 1000px;
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

        /* ===== ALERT ===== */
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

        .alert-error {
            background: rgba(233, 69, 96, 0.15);
            border: 1px solid rgba(233, 69, 96, 0.4);
            color: #ff6b81;
        }

        /* ===== INSTRUCTION BOX ===== */
        .instruction-box {
            background: rgba(255, 255, 255, 0.04);
            border: 1px dashed rgba(255, 255, 255, 0.2);
            border-radius: 14px;
            padding: 1rem 1.5rem;
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .instruction-box p {
            color: rgba(255,255,255,0.6);
            font-size: 0.9rem;
            line-height: 1.6;
        }

        .instruction-box strong {
            color: #e94560;
        }

        /* ===== CANDIDATES GRID ===== */
        .candidates-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(270px, 1fr));
            gap: 1.3rem;
            margin-bottom: 2.5rem;
        }

        /* ===== CANDIDATE CARD ===== */
        .candidate-card {
            background: rgba(255, 255, 255, 0.05);
            border: 2px solid rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            padding: 1.8rem 1.5rem;
            cursor: pointer;
            transition: all 0.3s;
            position: relative;
            overflow: hidden;
            animation: fadeIn 0.5s ease;
        }

        .candidate-card:hover {
            border-color: rgba(233, 69, 96, 0.5);
            background: rgba(233, 69, 96, 0.08);
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(233, 69, 96, 0.15);
        }

        /* Selected State */
        .candidate-card.selected {
            border-color: #e94560;
            background: rgba(233, 69, 96, 0.12);
            box-shadow: 0 0 0 3px rgba(233, 69, 96, 0.2),
                        0 15px 40px rgba(233, 69, 96, 0.2);
            transform: translateY(-5px);
        }

        /* Hide Radio Button */
        .candidate-card input[type="radio"] {
            display: none;
        }

        /* Check Badge */
        .check-badge {
            position: absolute;
            top: 1rem;
            right: 1rem;
            width: 28px;
            height: 28px;
            background: #e94560;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.9rem;
            opacity: 0;
            transform: scale(0);
            transition: all 0.3s;
        }

        .candidate-card.selected .check-badge {
            opacity: 1;
            transform: scale(1);
        }

        /* Avatar */
        .candidate-avatar {
            width: 72px;
            height: 72px;
            background: linear-gradient(135deg, #e94560, #c0392b);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            font-weight: 900;
            margin: 0 auto 1.2rem;
            color: white;
            box-shadow: 0 8px 20px rgba(233, 69, 96, 0.3);
        }

        .candidate-info {
            text-align: center;
        }

        .candidate-info h3 {
            font-size: 1.15rem;
            font-weight: 800;
            margin-bottom: 0.4rem;
            color: #ffffff;
        }

        .party-badge {
            display: inline-block;
            background: rgba(233, 69, 96, 0.15);
            color: #e94560;
            border: 1px solid rgba(233, 69, 96, 0.3);
            padding: 0.25rem 0.85rem;
            border-radius: 999px;
            font-size: 0.78rem;
            font-weight: 700;
            margin-bottom: 0.8rem;
            letter-spacing: 0.5px;
        }

        .candidate-info p {
            color: rgba(255,255,255,0.5);
            font-size: 0.87rem;
            line-height: 1.6;
        }

        /* ===== VOTE ACTION BAR ===== */
        .vote-action-bar {
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 18px;
            padding: 1.5rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .selected-info {
            color: rgba(255,255,255,0.6);
            font-size: 0.95rem;
        }

        .selected-info strong {
            color: #e94560;
            font-size: 1.05rem;
        }

        .action-buttons {
            display: flex;
            gap: 1rem;
            align-items: center;
        }

        .btn-submit {
            background: linear-gradient(135deg, #e94560, #c0392b);
            color: white;
            border: none;
            padding: 0.85rem 2rem;
            border-radius: 50px;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s;
            box-shadow: 0 6px 20px rgba(233, 69, 96, 0.35);
            opacity: 0.5;
            pointer-events: none;
        }

        .btn-submit.active {
            opacity: 1;
            pointer-events: all;
        }

        .btn-submit.active:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 28px rgba(233, 69, 96, 0.5);
        }

        .btn-back {
            background: rgba(255,255,255,0.08);
            color: rgba(255,255,255,0.7);
            border: 1px solid rgba(255,255,255,0.15);
            padding: 0.85rem 1.5rem;
            border-radius: 50px;
            font-size: 0.95rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s;
        }

        .btn-back:hover {
            background: rgba(255,255,255,0.13);
            color: #ffffff;
        }

        /* ===== CONFIRM MODAL ===== */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(0,0,0,0.7);
            backdrop-filter: blur(5px);
            z-index: 999;
            align-items: center;
            justify-content: center;
        }

        .modal-overlay.show {
            display: flex;
        }

        .modal-box {
            background: #16213e;
            border: 1px solid rgba(233, 69, 96, 0.3);
            border-radius: 24px;
            padding: 2.5rem;
            max-width: 420px;
            width: 90%;
            text-align: center;
            animation: popIn 0.3s ease;
            box-shadow: 0 25px 60px rgba(0,0,0,0.5);
        }

        @keyframes popIn {
            from { opacity: 0; transform: scale(0.85); }
            to   { opacity: 1; transform: scale(1); }
        }

        .modal-icon {
            font-size: 3.5rem;
            display: block;
            margin-bottom: 1rem;
        }

        .modal-box h3 {
            font-size: 1.4rem;
            font-weight: 800;
            margin-bottom: 0.5rem;
        }

        .modal-box p {
            color: rgba(255,255,255,0.6);
            font-size: 0.95rem;
            margin-bottom: 0.5rem;
        }

        .modal-candidate-name {
            color: #e94560;
            font-size: 1.2rem;
            font-weight: 800;
            margin: 0.8rem 0 1.5rem;
        }

        .modal-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
        }

        .btn-confirm {
            background: linear-gradient(135deg, #e94560, #c0392b);
            color: white;
            border: none;
            padding: 0.8rem 2rem;
            border-radius: 50px;
            font-size: 0.95rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-confirm:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(233,69,96,0.4);
        }

        .btn-cancel {
            background: rgba(255,255,255,0.08);
            color: rgba(255,255,255,0.7);
            border: 1px solid rgba(255,255,255,0.15);
            padding: 0.8rem 1.5rem;
            border-radius: 50px;
            font-size: 0.95rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-cancel:hover {
            background: rgba(255,255,255,0.13);
            color: white;
        }

        /* ===== NO CANDIDATES ===== */
        .no-candidates {
            text-align: center;
            padding: 4rem 2rem;
            color: rgba(255,255,255,0.4);
        }

        .no-candidates span {
            font-size: 4rem;
            display: block;
            margin-bottom: 1rem;
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
            .vote-action-bar { flex-direction: column; text-align: center; }
            .candidates-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

    <!-- NAVBAR -->
    <nav>
        <a href="${pageContext.request.contextPath}/index.jsp" class="nav-brand">
            🗳️ Vote<span>System</span>
            <img src="${pageContext.request.contextPath}/image/thor.jpg"
     width="120">
        </a>
        <div class="nav-right">
            <a href="${pageContext.request.contextPath}/dashboard.jsp" class="nav-link">
                ← Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/logout.jsp" class="btn-logout">
                🚪 Logout
            </a>
        </div>
    </nav>

    <!-- CONTAINER -->
    <div class="container">

        <!-- PAGE HEADER -->
        <div class="page-header">
            <span class="header-icon">🗳️</span>
            <h1>Cast Your <span>Vote</span></h1>
            <p>Select one candidate carefully. Your vote cannot be changed once submitted.</p>
        </div>

        <!-- ERROR ALERT -->
        <% if ("nocandidate".equals(request.getParameter("error"))) { %>
            <div class="alert alert-error">
                ❌ Please select a candidate before submitting your vote.
            </div>
        <% } %>
        <% if ("failed".equals(request.getParameter("error"))) { %>
            <div class="alert alert-error">
                ❌ Voting failed. Please try again.
            </div>
        <% } %>

        <!-- INSTRUCTION BOX -->
        <div class="instruction-box">
            <span style="font-size:1.8rem;">ℹ️</span>
            <p>
                <strong>Instructions:</strong> Click on a candidate card to select them.
                A confirmation dialog will appear before your vote is submitted.
                You can only vote <strong>once</strong> — choose wisely!
            </p>
        </div>

        <!-- VOTE FORM -->
        <form action="${pageContext.request.contextPath}/vote"
              method="post" id="voteForm">

            <!-- CANDIDATES GRID -->
            <% if (candidates == null || candidates.isEmpty()) { %>
                <div class="no-candidates">
                    <span>🚫</span>
                    <p>No candidates available at the moment.</p>
                </div>
            <% } else { %>
                <div class="candidates-grid">
                    <% for (Candidate c : candidates) { %>
                        <div class="candidate-card"
                             id="card-<%= c.getId() %>"
                             onclick="selectCandidate(<%= c.getId() %>, '<%= c.getName() %>')">

                            <input type="radio"
                                   name="candidateId"
                                   id="candidate-<%= c.getId() %>"
                                   value="<%= c.getId() %>">

                            <div class="check-badge">✓</div>

                            <div class="candidate-avatar">
                                <%= c.getName().charAt(0) %>
                            </div>

                            <div class="candidate-info">
                                <h3><%= c.getName() %></h3>
                                <span class="party-badge"><%= c.getParty() %></span>
                                <p><%= c.getDescription() != null ? c.getDescription() : "" %></p>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } %>

            <!-- VOTE ACTION BAR -->
            <div class="vote-action-bar">
                <div class="selected-info">
                    Selected: <strong id="selectedName">None</strong>
                </div>
                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/dashboard.jsp"
                       class="btn-back">
                        ← Cancel
                    </a>
                    <button type="button"
                            class="btn-submit"
                            id="submitBtn"
                            onclick="showConfirmModal()">
                        ✅ Submit Vote
                    </button>
                </div>
            </div>

        </form>

        <!-- FOOTER -->
        <div class="page-footer">
            🔒 Your vote is encrypted and securely stored &nbsp;|&nbsp;
            &copy; 2025 VoteSystem
        </div>

    </div>

    <!-- CONFIRM MODAL -->
    <div class="modal-overlay" id="confirmModal">
        <div class="modal-box">
            <span class="modal-icon">⚠️</span>
            <h3>Confirm Your Vote</h3>
            <p>You are about to vote for:</p>
            <div class="modal-candidate-name" id="modalCandidateName"></div>
            <p>This action <strong>cannot be undone.</strong> Are you sure?</p>
            <div class="modal-buttons">
                <button class="btn-cancel" onclick="hideConfirmModal()">
                    ✗ Cancel
                </button>
                <button class="btn-confirm" onclick="submitVote()">
                    ✅ Yes, Submit
                </button>
            </div>
        </div>
    </div>

    <script>
        let selectedId   = null;
        let selectedName = null;

        // Select a candidate card
        function selectCandidate(id, name) {
            // Remove selected from all cards
            document.querySelectorAll('.candidate-card').forEach(card => {
                card.classList.remove('selected');
            });

            // Select clicked card
            const card = document.getElementById('card-' + id);
            card.classList.add('selected');

            // Check the radio button
            document.getElementById('candidate-' + id).checked = true;

            // Update state
            selectedId   = id;
            selectedName = name;

            // Update bottom bar
            document.getElementById('selectedName').textContent = name;

            // Enable submit button
            const btn = document.getElementById('submitBtn');
            btn.classList.add('active');
        }

        // Show confirmation modal
        function showConfirmModal() {
            if (!selectedId) return;
            document.getElementById('modalCandidateName').textContent = selectedName;
            document.getElementById('confirmModal').classList.add('show');
        }

        // Hide confirmation modal
        function hideConfirmModal() {
            document.getElementById('confirmModal').classList.remove('show');
        }

        // Submit the form
        function submitVote() {
            document.getElementById('voteForm').submit();
        }

        // Close modal on overlay click
        document.getElementById('confirmModal').addEventListener('click', function(e) {
            if (e.target === this) hideConfirmModal();
        });
    </script>

</body>
</html>