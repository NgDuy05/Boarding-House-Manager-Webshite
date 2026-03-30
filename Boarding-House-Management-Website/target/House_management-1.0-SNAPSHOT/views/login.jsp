<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Login - AKDD House</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Inter', sans-serif;
            min-height: 100vh;
            display: flex;
            overflow: hidden;
        }

        .auth-panel-left {
            flex: 0 0 48%;
            background: linear-gradient(145deg, #4f46e5 0%, #7c3aed 50%, #9333ea 100%);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 3rem;
            position: relative;
            overflow: hidden;
        }
        .auth-panel-left::before {
            content: '';
            position: absolute;
            width: 380px; height: 380px;
            background: rgba(255,255,255,.08);
            border-radius: 50%;
            top: -100px; left: -100px;
        }
        .auth-panel-left::after {
            content: '';
            position: absolute;
            width: 280px; height: 280px;
            background: rgba(255,255,255,.06);
            border-radius: 50%;
            bottom: -60px; right: -60px;
        }
        .left-inner { position: relative; z-index: 1; text-align: center; color: #fff; }
        .left-inner .brand-icon {
            width: 80px; height: 80px;
            background: rgba(255,255,255,.2);
            border-radius: 24px;
            display: flex; align-items: center; justify-content: center;
            margin: 0 auto 1.5rem;
            backdrop-filter: blur(10px);
        }
        .left-inner h1 { font-size: 2.2rem; font-weight: 700; margin-bottom: .5rem; }
        .left-inner p  { font-size: 1rem; opacity: .85; line-height: 1.6; max-width: 320px; }
        .feature-list  { list-style: none; margin-top: 2rem; text-align: left; }
        .feature-list li {
            display: flex; align-items: center; gap: .75rem;
            margin-bottom: 1rem; font-size: .93rem; opacity: .9;
        }
        .feature-list li .fi {
            width: 32px; height: 32px;
            background: rgba(255,255,255,.15);
            border-radius: 8px;
            display: flex; align-items: center; justify-content: center;
            flex-shrink: 0;
        }

        .auth-panel-right {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #f8fafc;
            padding: 2rem;
        }
        .auth-form-wrap {
            width: 100%;
            max-width: 420px;
            background: #fff;
            border-radius: 20px;
            padding: 2.5rem;
            box-shadow: 0 4px 40px rgba(0,0,0,.08);
            animation: slideUp .45s ease both;
        }
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .auth-form-wrap h2 { font-size: 1.65rem; font-weight: 700; color: #1e1b4b; }
        .auth-form-wrap .sub { color: #64748b; font-size: .9rem; margin-bottom: 1.8rem; }

        .form-label { font-weight: 600; font-size: .875rem; color: #374151; }

        .input-icon-wrap { position: relative; }
        .input-icon-wrap .icon-left {
            position: absolute; top: 50%; left: 12px;
            transform: translateY(-50%);
            color: #9ca3af; pointer-events: none; font-size: 1rem;
        }
        .input-icon-wrap input {
            padding-left: 2.4rem;
            border: 1.5px solid #e5e7eb;
            border-radius: 10px;
            font-size: .93rem;
            transition: border-color .2s, box-shadow .2s;
            height: 44px;
            width: 100%;
        }
        .input-icon-wrap input:focus {
            border-color: #7c3aed;
            box-shadow: 0 0 0 3px rgba(124,58,237,.12);
            outline: none;
        }
        .btn-eye {
            position: absolute; top: 50%; right: 10px;
            transform: translateY(-50%);
            background: none; border: none;
            color: #9ca3af; cursor: pointer; font-size: 1rem;
            padding: 4px 6px; line-height: 1;
        }
        .btn-eye:hover { color: #7c3aed; }

        .forgot-link {
            font-size: .82rem; color: #7c3aed;
            text-decoration: none; font-weight: 500;
        }
        .forgot-link:hover { text-decoration: underline; }

        .btn-submit {
            width: 100%; height: 46px;
            background: linear-gradient(135deg, #4f46e5, #7c3aed);
            border: none; border-radius: 10px;
            color: #fff; font-weight: 600; font-size: .95rem;
            cursor: pointer; transition: opacity .2s, transform .15s;
            display: flex; align-items: center; justify-content: center; gap: .4rem;
        }
        .btn-submit:hover  { opacity: .92; }
        .btn-submit:active { transform: scale(.98); }

        .divider {
            display: flex; align-items: center; gap: .75rem;
            color: #9ca3af; font-size: .8rem; margin: 1.25rem 0;
        }
        .divider::before, .divider::after {
            content: ''; flex: 1; height: 1px; background: #e5e7eb;
        }

        .switch-link { font-size: .87rem; color: #64748b; text-align: center; }
        .switch-link a { color: #7c3aed; font-weight: 600; text-decoration: none; }
        .switch-link a:hover { text-decoration: underline; }

        /* Toast */
        .toast-wrap {
            position: fixed; top: 24px; right: 24px; z-index: 9999;
            display: flex; flex-direction: column; gap: .5rem;
        }
        .toast-item {
            display: flex; align-items: flex-start; gap: .75rem;
            padding: 1rem 2.5rem 1rem 1.25rem;
            border-radius: 12px;
            box-shadow: 0 8px 30px rgba(0,0,0,.14);
            min-width: 300px; max-width: 380px;
            position: relative; background: #fff;
            animation: toastIn .35s ease both;
        }
        .toast-item.success { border-left: 4px solid #10b981; }
        .toast-item.error   { border-left: 4px solid #ef4444; }
        .toast-icon { font-size: 1.25rem; flex-shrink: 0; margin-top: 1px; }
        .toast-item.success .toast-icon { color: #10b981; }
        .toast-item.error   .toast-icon { color: #ef4444; }
        .toast-title { font-weight: 700; font-size: .88rem; color: #111827; line-height: 1.3; }
        .toast-msg   { font-size: .82rem; color: #6b7280; margin-top: 2px; line-height: 1.4; }
        .toast-close {
            position: absolute; top: 8px; right: 10px;
            background: none; border: none; cursor: pointer;
            color: #9ca3af; font-size: .85rem; line-height: 1;
        }
        .toast-close:hover { color: #374151; }
        .toast-progress {
            position: absolute; bottom: 0; left: 0; height: 3px;
            border-radius: 0 0 0 12px;
            animation: shrink 4.5s linear forwards;
        }
        .toast-item.success .toast-progress { background: #10b981; }
        .toast-item.error   .toast-progress { background: #ef4444; }
        @keyframes toastIn {
            from { opacity: 0; transform: translateX(30px); }
            to   { opacity: 1; transform: translateX(0); }
        }
        @keyframes shrink { from { width: 100%; } to { width: 0; } }
        .toast-item.hiding { animation: toastOut .3s ease forwards; }
        @keyframes toastOut { to { opacity: 0; transform: translateX(30px); } }

        @media (max-width: 768px) {
            .auth-panel-left { display: none; }
            .auth-panel-right { background: linear-gradient(145deg, #4f46e5, #7c3aed); }
            .auth-form-wrap { box-shadow: 0 8px 40px rgba(0,0,0,.2); }
        }
    </style>
</head>
<body>

<div class="auth-panel-left">
    <div class="left-inner">
        <div class="brand-icon">
            <i class="bi bi-house-heart-fill fs-2 text-white"></i>
        </div>
        <h1>AKDD House</h1>
        <p>Smart boarding house management — simple, fast and secure.</p>
        <ul class="feature-list">
            <li>
                <span class="fi"><i class="bi bi-shield-check"></i></span>
                Secure account protection
            </li>
            <li>
                <span class="fi"><i class="bi bi-bell"></i></span>
                Instant bill notifications
            </li>
            <li>
                <span class="fi"><i class="bi bi-graph-up"></i></span>
                Easy contract tracking
            </li>
            <li>
                <span class="fi"><i class="bi bi-headset"></i></span>
                24/7 support
            </li>
        </ul>
    </div>
</div>

<div class="auth-panel-right">
    <div class="auth-form-wrap">

        <h2>Welcome back!</h2>
        <p class="sub">Sign in to continue to your account</p>

        <form action="${pageContext.request.contextPath}/auth" method="post" novalidate>
            <input type="hidden" name="action" value="login">

            <div class="mb-3">
                <label class="form-label">Username</label>
                <div class="input-icon-wrap">
                    <i class="bi bi-person icon-left"></i>
                    <input type="text" name="username" class="form-control"
                           placeholder="Enter your username"
                           value="${param.username}" required autofocus>
                </div>
            </div>

            <div class="mb-1">
                <label class="form-label">Password</label>
                <div class="input-icon-wrap">
                    <i class="bi bi-lock icon-left"></i>
                    <input type="password" name="password" id="loginPassword"
                           class="form-control" placeholder="Enter your password" required>
                    <button class="btn-eye" type="button" onclick="togglePwd('loginPassword','eyeLogin')">
                        <i class="bi bi-eye" id="eyeLogin"></i>
                    </button>
                </div>
            </div>
            <div class="text-end mb-3">
                <a href="${pageContext.request.contextPath}/auth?action=forgetPassword" class="forgot-link">
                    Forgot password?
                </a>
            </div>

            <button type="submit" class="btn-submit">
                <i class="bi bi-box-arrow-in-right"></i> Sign In
            </button>
        </form>

        <div class="divider">or</div>

        <p class="switch-link">
            Don't have an account?
            <a href="${pageContext.request.contextPath}/auth?action=register">Register now</a>
        </p>

    </div>
</div>

<div class="toast-wrap" id="toastWrap"></div>

<%-- Pass server messages to JS as data attributes to avoid template-literal conflicts --%>
<div id="serverData"
     data-success="<c:out value='${sessionScope.successMessage}' default='' />"
     data-error="<c:out value='${error}' default='' />"
     style="display:none"></div>
<c:if test="${not empty sessionScope.successMessage}">
    <% session.removeAttribute("successMessage"); %>
</c:if>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function togglePwd(inputId, iconId) {
        const inp  = document.getElementById(inputId);
        const icon = document.getElementById(iconId);
        if (inp.type === 'password') {
            inp.type = 'text';
            icon.classList.replace('bi-eye', 'bi-eye-slash');
        } else {
            inp.type = 'password';
            icon.classList.replace('bi-eye-slash', 'bi-eye');
        }
    }

    function showToast(type, title, message) {
        const wrap = document.getElementById('toastWrap');

        const item = document.createElement('div');
        item.className = 'toast-item ' + type;

        const icon = document.createElement('i');
        icon.className = 'bi toast-icon ' + (type === 'success' ? 'bi-check-circle-fill' : 'bi-exclamation-circle-fill');

        const body = document.createElement('div');

        const titleEl = document.createElement('div');
        titleEl.className = 'toast-title';
        titleEl.textContent = title;

        const msgEl = document.createElement('div');
        msgEl.className = 'toast-msg';
        msgEl.textContent = message;

        body.appendChild(titleEl);
        body.appendChild(msgEl);

        const closeBtn = document.createElement('button');
        closeBtn.className = 'toast-close';
        closeBtn.setAttribute('aria-label', 'Close');
        closeBtn.innerHTML = '<i class="bi bi-x-lg"></i>';
        closeBtn.onclick = function() { dismissToast(item); };

        const progress = document.createElement('div');
        progress.className = 'toast-progress';

        item.appendChild(icon);
        item.appendChild(body);
        item.appendChild(closeBtn);
        item.appendChild(progress);
        wrap.appendChild(item);

        const timer = setTimeout(function() { dismissToast(item); }, 4500);
        item._timer = timer;
    }

    function dismissToast(el) {
        if (!el || el.classList.contains('hiding')) return;
        clearTimeout(el._timer);
        el.classList.add('hiding');
        setTimeout(function() { el.remove(); }, 320);
    }

    document.addEventListener('DOMContentLoaded', function() {
        const data    = document.getElementById('serverData');
        const success = data.dataset.success.trim();
        const error   = data.dataset.error.trim();

        if (success) showToast('success', 'Registration Successful!', success);
        if (error)   showToast('error',   'Login Failed',             error);
    });
</script>
</body>
</html>
