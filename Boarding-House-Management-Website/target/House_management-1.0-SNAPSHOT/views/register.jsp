<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Register - AKDD House</title>
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
            overflow-x: hidden;
        }

        .auth-panel-left {
            flex: 0 0 42%;
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
            width: 360px; height: 360px;
            background: rgba(255,255,255,.07);
            border-radius: 50%;
            top: -80px; left: -80px;
        }
        .auth-panel-left::after {
            content: '';
            position: absolute;
            width: 260px; height: 260px;
            background: rgba(255,255,255,.05);
            border-radius: 50%;
            bottom: -50px; right: -50px;
        }
        .left-inner { position: relative; z-index: 1; text-align: center; color: #fff; }
        .left-inner .brand-icon {
            width: 80px; height: 80px;
            background: rgba(255,255,255,.2);
            border-radius: 24px;
            display: flex; align-items: center; justify-content: center;
            margin: 0 auto 1.5rem;
        }
        .left-inner h1 { font-size: 2rem; font-weight: 700; margin-bottom: .5rem; }
        .left-inner p  { font-size: .95rem; opacity: .85; line-height: 1.6; max-width: 300px; }
        .steps-list { list-style: none; margin-top: 2rem; text-align: left; }
        .steps-list li {
            display: flex; align-items: flex-start; gap: .85rem;
            margin-bottom: 1.25rem;
        }
        .step-num {
            width: 28px; height: 28px; flex-shrink: 0;
            background: rgba(255,255,255,.25);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: .82rem; color: #fff;
            margin-top: 2px;
        }
        .step-text { font-size: .88rem; opacity: .9; line-height: 1.5; }
        .step-text strong { display: block; font-weight: 600; }

        .auth-panel-right {
            flex: 1;
            background: #f8fafc;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
            overflow-y: auto;
        }
        .auth-form-wrap {
            width: 100%;
            max-width: 480px;
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

        .auth-form-wrap h2 { font-size: 1.55rem; font-weight: 700; color: #1e1b4b; }
        .auth-form-wrap .sub { color: #64748b; font-size: .88rem; margin-bottom: 1.6rem; }

        .form-label { font-weight: 600; font-size: .85rem; color: #374151; margin-bottom: .35rem; }
        .required-star { color: #ef4444; }

        .input-icon-wrap { position: relative; }
        .input-icon-wrap .icon-left {
            position: absolute; top: 50%; left: 12px;
            transform: translateY(-50%);
            color: #9ca3af; pointer-events: none; font-size: .95rem;
        }
        .input-icon-wrap input {
            padding-left: 2.35rem;
            border: 1.5px solid #e5e7eb;
            border-radius: 10px;
            font-size: .9rem;
            height: 42px;
            transition: border-color .2s, box-shadow .2s;
            width: 100%;
        }
        .input-icon-wrap input:focus {
            border-color: #7c3aed;
            box-shadow: 0 0 0 3px rgba(124,58,237,.12);
            outline: none;
        }
        .input-icon-wrap input.is-invalid { border-color: #ef4444; }
        .input-icon-wrap input.is-valid   { border-color: #10b981; }

        .btn-eye {
            position: absolute; top: 50%; right: 10px;
            transform: translateY(-50%);
            background: none; border: none;
            color: #9ca3af; cursor: pointer; font-size: .95rem;
            padding: 4px 6px; line-height: 1;
        }
        .btn-eye:hover { color: #7c3aed; }

        .field-error { font-size: .77rem; color: #ef4444; margin-top: .3rem; display: none; }

        .row-2 { display: grid; grid-template-columns: 1fr 1fr; gap: .75rem; }

        .server-error {
            background: #fef2f2;
            border: 1px solid #fecaca;
            border-radius: 10px;
            padding: .85rem 1rem;
            display: flex; align-items: center; gap: .6rem;
            color: #b91c1c; font-size: .88rem;
            margin-bottom: 1.25rem;
        }

        .btn-submit {
            width: 100%; height: 46px;
            background: linear-gradient(135deg, #4f46e5, #7c3aed);
            border: none; border-radius: 10px;
            color: #fff; font-weight: 600; font-size: .95rem;
            cursor: pointer; transition: opacity .2s, transform .15s;
            display: flex; align-items: center; justify-content: center; gap: .4rem;
            margin-top: 1.25rem;
        }
        .btn-submit:hover  { opacity: .92; }
        .btn-submit:active { transform: scale(.98); }

        .switch-link { font-size: .87rem; color: #64748b; text-align: center; margin-top: 1.25rem; }
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
            min-width: 300px; background: #fff;
            border-left: 4px solid #ef4444;
            position: relative;
            animation: toastIn .35s ease both;
        }
        .toast-icon  { font-size: 1.2rem; flex-shrink: 0; color: #ef4444; margin-top: 1px; }
        .toast-title { font-weight: 700; font-size: .88rem; color: #111827; line-height: 1.3; }
        .toast-msg   { font-size: .82rem; color: #6b7280; margin-top: 2px; }
        .toast-close {
            position: absolute; top: 8px; right: 10px;
            background: none; border: none; cursor: pointer;
            color: #9ca3af; font-size: .82rem;
        }
        .toast-close:hover { color: #374151; }
        .toast-progress {
            position: absolute; bottom: 0; left: 0; height: 3px;
            background: #ef4444;
            border-radius: 0 0 0 12px;
            animation: shrink 4.5s linear forwards;
        }
        @keyframes toastIn {
            from { opacity: 0; transform: translateX(30px); }
            to   { opacity: 1; transform: translateX(0); }
        }
        @keyframes shrink { from { width: 100%; } to { width: 0; } }

        @media (max-width: 768px) {
            .auth-panel-left { display: none; }
            .auth-panel-right { background: linear-gradient(145deg, #4f46e5, #7c3aed); }
            .auth-form-wrap { box-shadow: 0 8px 40px rgba(0,0,0,.2); }
            .row-2 { grid-template-columns: 1fr; }
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
        <p>Create an account and start managing your rental experience today.</p>
        <ul class="steps-list">
            <li>
                <span class="step-num">1</span>
                <div class="step-text">
                    <strong>Set your credentials</strong>
                    Choose a username and a secure password
                </div>
            </li>
            <li>
                <span class="step-num">2</span>
                <div class="step-text">
                    <strong>Add contact info</strong>
                    Email and phone for notifications
                </div>
            </li>
            <li>
                <span class="step-num">3</span>
                <div class="step-text">
                    <strong>Log in and explore</strong>
                    Access all features immediately
                </div>
            </li>
        </ul>
    </div>
</div>

<div class="auth-panel-right">
    <div class="auth-form-wrap">

        <h2>Create an account</h2>
        <p class="sub">Fill in the details below to get started</p>

        <c:if test="${not empty error}">
            <div class="server-error">
                <i class="bi bi-exclamation-circle-fill"></i>
                <span><c:out value="${error}" /></span>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/auth" method="post" id="registerForm" novalidate>
            <input type="hidden" name="action" value="register">

            <div class="mb-3">
                <label class="form-label">Username <span class="required-star">*</span></label>
                <div class="input-icon-wrap">
                    <i class="bi bi-person icon-left"></i>
                    <input type="text" name="username" id="username" class="form-control"
                           placeholder="e.g. john_doe"
                           value="${param.username}" required
                           oninput="validateUsername(this)">
                </div>
                <div class="field-error" id="err-username">Username cannot be empty</div>
            </div>

            <div class="row-2 mb-3">
                <div>
                    <label class="form-label">Password <span class="required-star">*</span></label>
                    <div class="input-icon-wrap">
                        <i class="bi bi-lock icon-left"></i>
                        <input type="password" name="password" id="password"
                               class="form-control" placeholder="Min. 6 characters" required
                               oninput="validatePassword(this)">
                        <button class="btn-eye" type="button" onclick="togglePwd('password','eyePwd')">
                            <i class="bi bi-eye" id="eyePwd"></i>
                        </button>
                    </div>
                    <div class="field-error" id="err-password">At least 6 characters required</div>
                </div>
                <div>
                    <label class="form-label">Confirm Password <span class="required-star">*</span></label>
                    <div class="input-icon-wrap">
                        <i class="bi bi-lock-fill icon-left"></i>
                        <input type="password" name="confirmPassword" id="confirmPassword"
                               class="form-control" placeholder="Re-enter password" required
                               oninput="validateConfirm(this)">
                        <button class="btn-eye" type="button" onclick="togglePwd('confirmPassword','eyeConfirm')">
                            <i class="bi bi-eye" id="eyeConfirm"></i>
                        </button>
                    </div>
                    <div class="field-error" id="err-confirm">Passwords do not match</div>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label">Full Name</label>
                <div class="input-icon-wrap">
                    <i class="bi bi-person-badge icon-left"></i>
                    <input type="text" name="fullName" class="form-control"
                           placeholder="John Doe"
                           value="${param.fullName}">
                </div>
            </div>

            <div class="row-2 mb-1">
                <div>
                    <label class="form-label">Email</label>
                    <div class="input-icon-wrap">
                        <i class="bi bi-envelope icon-left"></i>
                        <input type="email" name="email" id="emailField" class="form-control"
                               placeholder="you@example.com"
                               value="${param.email}"
                               oninput="validateEmail(this)">
                    </div>
                    <div class="field-error" id="err-email">Invalid email address</div>
                </div>
                <div>
                    <label class="form-label">Phone</label>
                    <div class="input-icon-wrap">
                        <i class="bi bi-telephone icon-left"></i>
                        <input type="tel" name="phone" id="phoneField" class="form-control"
                               placeholder="09xxxxxxxx"
                               value="${param.phone}"
                               oninput="validatePhone(this)">
                    </div>
                    <div class="field-error" id="err-phone">Invalid phone number</div>
                </div>
            </div>

            <button type="submit" class="btn-submit">
                <i class="bi bi-person-plus"></i> Create Account
            </button>
        </form>

        <p class="switch-link">
            Already have an account?
            <a href="${pageContext.request.contextPath}/auth?action=login">Sign in</a>
        </p>

    </div>
</div>

<div class="toast-wrap" id="toastWrap"></div>

<div id="serverData"
     data-error="<c:out value='${error}' default='' />"
     style="display:none"></div>

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

    function setValid(input, errId, valid) {
        input.classList.toggle('is-invalid', !valid);
        input.classList.toggle('is-valid',   valid);
        const e = document.getElementById(errId);
        if (e) e.style.display = valid ? 'none' : 'block';
    }

    function validateUsername(el) { setValid(el, 'err-username', el.value.trim().length > 0); }
    function validatePassword(el) {
        setValid(el, 'err-password', el.value.length >= 6);
        const c = document.getElementById('confirmPassword');
        if (c.value) validateConfirm(c);
    }
    function validateConfirm(el) {
        setValid(el, 'err-confirm', el.value === document.getElementById('password').value && el.value.length > 0);
    }
    function validateEmail(el) {
        if (!el.value) { el.classList.remove('is-invalid','is-valid'); return; }
        setValid(el, 'err-email', /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(el.value));
    }
    function validatePhone(el) {
        if (!el.value) { el.classList.remove('is-invalid','is-valid'); return; }
        setValid(el, 'err-phone', /^(0|\+\d{1,3})[0-9]{8,11}$/.test(el.value.replace(/\s/g,'')));
    }

    document.getElementById('registerForm').addEventListener('submit', function(e) {
        const u = document.getElementById('username');
        const p = document.getElementById('password');
        const c = document.getElementById('confirmPassword');
        let ok = true;
        if (!u.value.trim())         { validateUsername(u); ok = false; }
        if (p.value.length < 6)      { validatePassword(p); ok = false; }
        if (c.value !== p.value)     { validateConfirm(c);  ok = false; }
        if (!ok) { e.preventDefault(); showToast('Please fix the errors above.'); }
    });

    function showToast(message) {
        const wrap = document.getElementById('toastWrap');
        const item = document.createElement('div');
        item.className = 'toast-item';

        const icon = document.createElement('i');
        icon.className = 'bi bi-exclamation-circle-fill toast-icon';

        const body = document.createElement('div');
        const titleEl = document.createElement('div');
        titleEl.className = 'toast-title';
        titleEl.textContent = 'Error';
        const msgEl = document.createElement('div');
        msgEl.className = 'toast-msg';
        msgEl.textContent = message;
        body.appendChild(titleEl);
        body.appendChild(msgEl);

        const closeBtn = document.createElement('button');
        closeBtn.className = 'toast-close';
        closeBtn.innerHTML = '<i class="bi bi-x-lg"></i>';
        closeBtn.onclick = function() { item.remove(); };

        const progress = document.createElement('div');
        progress.className = 'toast-progress';

        item.appendChild(icon);
        item.appendChild(body);
        item.appendChild(closeBtn);
        item.appendChild(progress);
        wrap.appendChild(item);
        setTimeout(function() { item.remove(); }, 4700);
    }

    document.addEventListener('DOMContentLoaded', function() {
        const err = document.getElementById('serverData').dataset.error.trim();
        if (err) showToast(err);
    });
</script>
</body>
</html>
