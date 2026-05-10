<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - VoteSystem</title>
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
            text-decoration: none;
        }

        .nav-brand span {
            color: #ffffff;
        }

        .nav-link {
            color: rgba(255,255,255,0.7);
            text-decoration: none;
            font-size: 0.95rem;
            transition: color 0.3s;
        }

        .nav-link:hover {
            color: #e94560;
        }

        /* ===== PAGE WRAPPER ===== */
        .page-wrapper {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
        }

        /* ===== LOGIN CARD ===== */
        .login-card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.12);
            border-radius: 24px;
            padding: 3rem 2.5rem;
            width: 100%;
            max-width: 440px;
            box-shadow: 0 25px 60px rgba(0, 0, 0, 0.4);
            animation: slideUp 0.5s ease;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* ===== HEADER ===== */
        .card-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .card-icon {
            font-size: 3.5rem;
            display: block;
            margin-bottom: 0.8rem;
        }

        .card-header h2 {
            color: #ffffff;
            font-size: 1.9rem;
            font-weight: 800;
            margin-bottom: 0.4rem;
        }

        .card-header p {
            color: rgba(255, 255, 255, 0.5);
            font-size: 0.95rem;
        }

        /* ===== ALERTS ===== */
        .alert {
            padding: 0.85rem 1.1rem;
            border-radius: 10px;
            margin-bottom: 1.5rem;
            font-size: 0.9rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .alert-error {
            background: rgba(233, 69, 96, 0.15);
            border: 1px solid rgba(233, 69, 96, 0.4);
            color: #ff6b81;
        }

        .alert-success {
            background: rgba(22, 163, 74, 0.15);
            border: 1px solid rgba(22, 163, 74, 0.4);
            color: #4ade80;
        }

        /* ===== FORM ===== */
        .form-group {
            margin-bottom: 1.3rem;
        }

        .form-group label {
            display: block;
            color: rgba(255, 255, 255, 0.75);
            font-size: 0.88rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            letter-spacing: 0.5px;
        }

        .input-wrapper {
            position: relative;
        }

        .input-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            font-size: 1.1rem;
            pointer-events: none;
        }

        .form-group input {
            width: 100%;
            padding: 0.85rem 1rem 0.85rem 2.8rem;
            background: rgba(255, 255, 255, 0.07);
            border: 1.5px solid rgba(255, 255, 255, 0.12);
            border-radius: 12px;
            color: #ffffff;
            font-size: 0.95rem;
            transition: all 0.3s;
            outline: none;
        }

        .form-group input::placeholder {
            color: rgba(255, 255, 255, 0.3);
        }

        .form-group input:focus {
            border-color: #e94560;
            background: rgba(233, 69, 96, 0.08);
            box-shadow: 0 0 0 3px rgba(233, 69, 96, 0.15);
        }

        /* ===== FORGOT PASSWORD ===== */
        .form-extras {
            display: flex;
            justify-content: flex-end;
            margin-top: -0.8rem;
            margin-bottom: 1.3rem;
        }

        .forgot-link {
            color: #e94560;
            font-size: 0.82rem;
            text-decoration: none;
            font-weight: 600;
        }

        .forgot-link:hover {
            text-decoration: underline;
        }

        /* ===== SUBMIT BUTTON ===== */
        .btn-login {
            width: 100%;
            padding: 0.95rem;
            background: linear-gradient(135deg, #e94560, #c0392b);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s;
            letter-spacing: 0.5px;
            box-shadow: 0 6px 20px rgba(233, 69, 96, 0.35);
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 28px rgba(233, 69, 96, 0.5);
        }

        .btn-login:active {
            transform: translateY(0);
        }

        /* ===== DIVIDER ===== */
        .divider {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin: 1.5rem 0;
        }

        .divider::before,
        .divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: rgba(255, 255, 255, 0.12);
        }

        .divider span {
            color: rgba(255, 255, 255, 0.35);
            font-size: 0.8rem;
        }

        /* ===== FOOTER LINK ===== */
        .card-footer {
            text-align: center;
            color: rgba(255, 255, 255, 0.5);
            font-size: 0.9rem;
        }

        .card-footer a {
            color: #e94560;
            font-weight: 700;
            text-decoration: none;
        }

        .card-footer a:hover {
            text-decoration: underline;
        }

        /* ===== ADMIN HINT ===== */
        .admin-hint {
            margin-top: 1.5rem;
            background: rgba(255, 255, 255, 0.04);
            border: 1px dashed rgba(255, 255, 255, 0.15);
            border-radius: 10px;
            padding: 0.9rem 1rem;
            text-align: center;
        }

        .admin-hint p {
            color: rgba(255, 255, 255, 0.4);
            font-size: 0.78rem;
            line-height: 1.7;
        }

        .admin-hint strong {
            color: rgba(255, 255, 255, 0.65);
        }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 480px) {
            .login-card {
                padding: 2rem 1.5rem;
            }
            .card-header h2 {
                font-size: 1.6rem;
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
        <a href="${pageContext.request.contextPath}/register" class="nav-link">
            Don't have an account? <strong>Register</strong>
        </a>
    </nav>

    <!-- PAGE WRAPPER -->
    <div class="page-wrapper">
        <div class="login-card">

            <!-- HEADER -->
            <div class="card-header">
                <span class="card-icon">🔐</span>
                <h2>Welcome Back</h2>
                <p>Sign in to cast your vote securely</p>
            </div>

            <!-- SUCCESS ALERT -->
            <% if ("registered".equals(request.getParameter("success"))) { %>
                <div class="alert alert-success">
                    ✅ Registration successful! Please login.
                </div>
            <% } %>

            <!-- ERROR ALERT -->
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error">
                    ❌ <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <!-- LOGIN FORM -->
            <form action="${pageContext.request.contextPath}/login" method="post">
                <!-- Email -->
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <div class="input-wrapper">
                        <span class="input-icon">📧</span>
                        <input
                            type="email"
                            id="email"
                            name="email"
                            placeholder="you@example.com"
                            required
                            autocomplete="email"
                        />
                    </div>
                </div>

                <!-- Password -->
                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="input-wrapper">
                        <span class="input-icon">🔑</span>
                        <input
                            type="password"
                            id="password"
                            name="password"
                            placeholder="Enter your password"
                            required
                            autocomplete="current-password"
                        />
                    </div>
                </div>

                <!-- Forgot Password -->
                <div class="form-extras">
                    <a href="#" class="forgot-link">Forgot password?</a>
                </div>

                <!-- Submit -->
                <button type="submit" class="btn-login">
                    🗳️ Sign In &amp; Vote
                </button>
            </form>

            <!-- DIVIDER -->
            <div class="divider">
                <span>or</span>
            </div>

            <!-- REGISTER LINK -->
            <div class="card-footer">
                New voter? <a href="${pageContext.request.contextPath}/register">Create an account</a>
            </div>

            <!-- ADMIN HINT -->
            <div class="admin-hint">
                <p>
                    🛡️ <strong>Admin Login:</strong><br>
                    Email: <strong>admin@vote.com</strong> &nbsp;|&nbsp;
                    Password: <strong>admin123</strong>
                </p>
            </div>

        </div>
    </div>

</body>
</html>