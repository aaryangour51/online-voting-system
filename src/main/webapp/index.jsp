<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Online Voting System</title>
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
            display: flex;
            flex-direction: column;
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
        }

        .nav-brand {
            color: #e94560;
            font-size: 1.5rem;
            font-weight: 800;
            letter-spacing: 1px;
        }

        .nav-brand span {
            color: #ffffff;
        }

        .nav-links {
            display: flex;
            gap: 1rem;
        }

        .nav-links a {
            color: #ffffff;
            text-decoration: none;
            padding: 0.5rem 1.2rem;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s;
            border: 1px solid transparent;
        }

        .nav-links a:hover {
            border-color: #e94560;
            color: #e94560;
        }

        .nav-links a.btn-nav {
            background: #e94560;
            color: white;
            border-color: #e94560;
        }

        .nav-links a.btn-nav:hover {
            background: transparent;
            color: #e94560;
        }

        /* ===== HERO SECTION ===== */
        .hero {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 4rem 2rem;
            text-align: center;
        }

        .hero-content {
            max-width: 750px;
        }

        .hero-icon {
            font-size: 6rem;
            margin-bottom: 1.5rem;
            animation: float 3s ease-in-out infinite;
            display: block;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50%       { transform: translateY(-15px); }
        }

        .hero-badge {
            display: inline-block;
            background: rgba(233, 69, 96, 0.2);
            color: #e94560;
            border: 1px solid #e94560;
            padding: 0.3rem 1rem;
            border-radius: 999px;
            font-size: 0.85rem;
            font-weight: 600;
            letter-spacing: 2px;
            text-transform: uppercase;
            margin-bottom: 1.5rem;
        }

        .hero h1 {
            font-size: 3.5rem;
            font-weight: 900;
            color: #ffffff;
            line-height: 1.2;
            margin-bottom: 1.2rem;
        }

        .hero h1 span {
            color: #e94560;
        }

        .hero p {
            font-size: 1.15rem;
            color: rgba(255, 255, 255, 0.7);
            line-height: 1.8;
            margin-bottom: 2.5rem;
        }

        .hero-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn {
            padding: 0.85rem 2.2rem;
            border-radius: 50px;
            font-size: 1rem;
            font-weight: 700;
            text-decoration: none;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary {
            background: #e94560;
            color: white;
            box-shadow: 0 8px 25px rgba(233, 69, 96, 0.4);
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(233, 69, 96, 0.5);
        }

        .btn-outline {
            background: transparent;
            color: white;
            border: 2px solid rgba(255, 255, 255, 0.4);
        }

        .btn-outline:hover {
            border-color: white;
            background: rgba(255, 255, 255, 0.1);
            transform: translateY(-3px);
        }

        /* ===== FEATURES SECTION ===== */
        .features {
            padding: 4rem 2rem;
            background: rgba(0, 0, 0, 0.2);
        }

        .features h2 {
            text-align: center;
            color: #ffffff;
            font-size: 2rem;
            font-weight: 800;
            margin-bottom: 0.5rem;
        }

        .features-subtitle {
            text-align: center;
            color: rgba(255,255,255,0.5);
            margin-bottom: 3rem;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 1.5rem;
            max-width: 1000px;
            margin: 0 auto;
        }

        .feature-card {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 16px;
            padding: 2rem 1.5rem;
            text-align: center;
            transition: all 0.3s;
        }

        .feature-card:hover {
            background: rgba(233, 69, 96, 0.1);
            border-color: #e94560;
            transform: translateY(-5px);
        }

        .feature-icon {
            font-size: 2.8rem;
            margin-bottom: 1rem;
            display: block;
        }

        .feature-card h3 {
            color: #ffffff;
            font-size: 1.1rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .feature-card p {
            color: rgba(255, 255, 255, 0.55);
            font-size: 0.9rem;
            line-height: 1.6;
        }

        /* ===== FOOTER ===== */
        footer {
            background: rgba(0, 0, 0, 0.3);
            text-align: center;
            padding: 1.5rem;
            color: rgba(255, 255, 255, 0.4);
            font-size: 0.85rem;
            border-top: 1px solid rgba(255,255,255,0.05);
        }

        footer span {
            color: #e94560;
        }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 600px) {
            .hero h1 { font-size: 2.2rem; }
            .hero-icon { font-size: 4rem; }
            .nav-brand { font-size: 1.1rem; }
        }
    </style>
</head>
<body>

    <!-- NAVBAR -->
    <nav>
        <div class="nav-brand">🗳️ Vote<span>System</span></div>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/login">Login</a>
            <a href="${pageContext.request.contextPath}/register" class="btn-nav">Register</a>
        </div>
    </nav>

    <!-- HERO SECTION -->
    <section class="hero">
        <div class="hero-content">
            <span class="hero-icon">🗳️</span>
            <div class="hero-badge">🔒 Secure &amp; Transparent</div>
            <h1>Your Vote, <span>Your Voice</span></h1>
            <p>
                Participate in fair and secure digital elections from anywhere.
                Our platform ensures every vote is counted, verified, and protected.
            </p>
            <div class="hero-buttons">
                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">
                    🗳️ Login to Vote
                </a>
                <a href="${pageContext.request.contextPath}/register" class="btn btn-outline">
                    📝 Create Account
                </a>
            </div>
        </div>
    </section>

    <!-- FEATURES SECTION -->
    <section class="features">
        <h2>Why Choose VoteSystem?</h2>
        <p class="features-subtitle">Built for trust, transparency, and ease of use</p>
        <div class="features-grid">
            <div class="feature-card">
                <span class="feature-icon">🔐</span>
                <h3>Secure Voting</h3>
                <p>Every vote is encrypted and securely stored. No duplicate votes allowed.</p>
            </div>
            <div class="feature-card">
                <span class="feature-icon">⚡</span>
                <h3>Instant Results</h3>
                <p>Live results updated in real-time as votes are cast across the system.</p>
            </div>
            <div class="feature-card">
                <span class="feature-icon">📱</span>
                <h3>Vote Anywhere</h3>
                <p>Access from any device — desktop, tablet, or mobile browser.</p>
            </div>
            <div class="feature-card">
                <span class="feature-icon">✅</span>
                <h3>One Vote Only</h3>
                <p>Each registered voter can cast exactly one vote — fair and tamper-proof.</p>
            </div>
        </div>
    </section>

    <!-- FOOTER -->
    <footer>
        &copy; 2025 <span>VoteSystem</span>. All rights reserved. Built with ❤️ for democracy.
    </footer>

</body>
</html>