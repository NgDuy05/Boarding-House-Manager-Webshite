<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Change Password - AKDD House</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { background: #f4f6f9; font-family: 'Inter', sans-serif; }

        /* ── Page header ── */
        .page-hero {
            background: linear-gradient(135deg, #4f46e5, #7c3aed);
            border-radius: 16px;
            padding: 28px;
            color: #fff;
            display: flex;
            align-items: center;
            gap: 18px;
            margin-bottom: 24px;
            position: relative;
            overflow: hidden;
        }
        .page-hero::after {
            content: '';
            position: absolute;
            width: 200px; height: 200px;
            background: rgba(255,255,255,.06);
            border-radius: 50%;
            top: -60px; right: -60px;
        }
        .hero-icon {
            width: 64px; height: 64px;
            background: rgba(255,255,255,.2);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 28px;
            flex-shrink: 0;
        }
        .page-hero h4    { font-weight: 700; margin-bottom: 2px; font-size: 1.25rem; }
        .page-hero small { opacity: .8; font-size: .87rem; }

        /* ── Cards ── */
        .form-card, .tip-card {
            background: #fff;
            border-radius: 16px;
            border: none;
            box-shadow: 0 2px 20px rgba(0,0,0,.07);
            padding: 2rem;
        }
        .tip-card { padding: 1.25rem 1.5rem; }

        .section-label {
            font-size: .75rem;
            font-weight: 700;
            color: #9ca3af;
            text-transform: uppercase;
            letter-spacing: .6px;
            margin-bottom: 1rem;
            padding-bottom: .5rem;
            border-bottom: 1px solid #f0f0f0;
        }

        /* ── Inputs ── */
        .field-wrap { position: relative; }
        .field-wrap .field-icon {
            position: absolute; top: 50%; left: 12px;
            transform: translateY(-50%);
            color: #9ca3af; font-size: .95rem; pointer-events: none;
        }
        .field-wrap input {
            padding-left: 2.4rem;
            padding-right: 2.8rem;
            border: 1.5px solid #e5e7eb;
            border-radius: 10px;
            height: 44px;
            font-size: .92rem;
            width: 100%;
            transition: border-color .2s, box-shadow .2s;
        }
        .field-wrap input:focus {
            border-color: #7c3aed;
            box-shadow: 0 0 0 3px rgba(124,58,237,.12);
            outline: none;
        }
        .field-wrap input.is-valid   { border-color: #10b981; }
        .field-wrap input.is-invalid { border-color: #ef4444; }
        .btn-eye {
            position: absolute; top: 50%; right: 10px;
            transform: translateY(-50%);
            background: none; border: none;
            color: #9ca3af; cursor: pointer; font-size: .95rem;
            padding: 4px 6px; line-height: 1;
        }
        .btn-eye:hover { color: #7c3aed; }
        .form-label { font-weight: 600; font-size: .85rem; color: #374151; margin-bottom: .35rem; }

        /* ── Strength bar ── */
        .strength-track {
            height: 5px;
            background: #f0f0f0;
            border-radius: 3px;
            margin-top: .5rem;
            overflow: hidden;
        }
        .strength-fill {
            height: 100%;
            border-radius: 3px;
            transition: width .3s ease, background .3s ease;
            width: 0%;
        }
        .strength-label { font-size: .78rem; color: #9ca3af; margin-top: .3rem; }

        /* ── Match feedback ── */
        .match-text { font-size: .78rem; margin-top: .3rem; }

        /* ── Buttons ── */
        .btn-save {
            background: linear-gradient(135deg, #4f46e5, #7c3aed);
            border: none; border-radius: 10px;
            color: #fff; font-weight: 600; font-size: .93rem;
            height: 44px; padding: 0 1.5rem;
            display: inline-flex; align-items: center; gap: .4rem;
            transition: opacity .2s, transform .15s; cursor: pointer;
        }
        .btn-save:hover  { opacity: .9; }
        .btn-save:active { transform: scale(.98); }
        .btn-cancel {
            border: 1.5px solid #e5e7eb; border-radius: 10px;
            background: #fff; color: #6b7280;
            font-weight: 600; font-size: .93rem;
            height: 44px; padding: 0 1.5rem;
            display: inline-flex; align-items: center; gap: .4rem;
            text-decoration: none; transition: border-color .2s, color .2s;
        }
        .btn-cancel:hover { border-color: #7c3aed; color: #7c3aed; }

        /* ── Tips card ── */
        .tip-list { list-style: none; padding: 0; margin: 0; }
        .tip-list li {
            display: flex; align-items: flex-start; gap: .6rem;
            font-size: .83rem; color: #6b7280; margin-bottom: .5rem;
        }
        .tip-list li:last-child { margin-bottom: 0; }
        .tip-list li i { color: #7c3aed; margin-top: 2px; flex-shrink: 0; }

        /* ── Toast ── */
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
            position: relative;
            animation: toastIn .35s ease both;
        }
        .toast-item.success { border-left: 4px solid #10b981; }
        .toast-item.error   { border-left: 4px solid #ef4444; }
        .toast-icon { font-size: 1.2rem; flex-shrink: 0; margin-top: 1px; }
        .toast-item.success .toast-icon { color: #10b981; }
        .toast-item.error   .toast-icon { color: #ef4444; }
        .toast-title { font-weight: 700; font-size: .88rem; color: #111827; }
        .toast-msg   { font-size: .82rem; color: #6b7280; margin-top: 2px; }
        .toast-close {
            position: absolute; top: 8px; right: 10px;
            background: none; border: none; cursor: pointer;
            color: #9ca3af; font-size: .82rem;
        }
        .toast-progress {
            position: absolute; bottom: 0; left: 0; height: 3px;
            border-radius: 0 0 0 12px;
            animation: shrink 4s linear forwards;
        }
        .toast-item.success .toast-progress { background: #10b981; }
        .toast-item.error   .toast-progress { background: #ef4444; }
        @keyframes toastIn  { from { opacity:0; transform:translateX(30px); } to { opacity:1; transform:translateX(0); } }
        @keyframes shrink   { from { width:100%; } to { width:0; } }
        .toast-item.hiding  { animation: toastOut .3s ease forwards; }
        @keyframes toastOut { to { opacity:0; transform:translateX(30px); } }
    </style>
</head>
<body>
    <%@ include file="../navbar.jsp" %>

    <div class="container-fluid p-0">
      <div class="row g-0" style="min-height: calc(100vh - 56px);">
        <%@ include file="sidebar.jsp" %>
        <main class="col p-4">
    <div style="max-width: 560px;">

        <%-- Hero header --%>
        <div class="page-hero">
            <div class="hero-icon">
                <i class="bi bi-shield-lock-fill"></i>
            </div>
            <div style="position:relative;z-index:1;">
                <h4>Change Password</h4>
                <small>Keep your account secure with a strong password</small>
            </div>
        </div>

        <%-- Form card --%>
        <div class="form-card mb-3">

            <div class="section-label">Security Update</div>

            <form action="${pageContext.request.contextPath}/auth" method="post" id="cpForm" novalidate>
                <input type="hidden" name="action" value="changePassword">

                <%-- Current password --%>
                <div class="mb-3">
                    <label class="form-label">Current Password</label>
                    <div class="field-wrap">
                        <i class="bi bi-lock field-icon"></i>
                        <input type="password" name="oldPassword" id="oldPassword"
                               class="form-control" placeholder="Enter your current password"
                               required autofocus>
                        <button class="btn-eye" type="button" onclick="toggleEye('oldPassword','eyeOld')">
                            <i class="bi bi-eye" id="eyeOld"></i>
                        </button>
                    </div>
                </div>

                <%-- New password --%>
                <div class="mb-1">
                    <label class="form-label">New Password</label>
                    <div class="field-wrap">
                        <i class="bi bi-lock-fill field-icon"></i>
                        <input type="password" name="newPassword" id="newPassword"
                               class="form-control" placeholder="At least 6 characters"
                               required oninput="onNewPwd(this.value)">
                        <button class="btn-eye" type="button" onclick="toggleEye('newPassword','eyeNew')">
                            <i class="bi bi-eye" id="eyeNew"></i>
                        </button>
                    </div>
                </div>
                <%-- Strength bar --%>
                <div class="mb-3">
                    <div class="strength-track">
                        <div class="strength-fill" id="strengthFill"></div>
                    </div>
                    <div class="strength-label" id="strengthLabel"></div>
                </div>

                <%-- Confirm password --%>
                <div class="mb-4">
                    <label class="form-label">Confirm New Password</label>
                    <div class="field-wrap">
                        <i class="bi bi-shield-check field-icon"></i>
                        <input type="password" name="confirmPassword" id="confirmPassword"
                               class="form-control" placeholder="Re-enter new password"
                               required oninput="onConfirm()">
                        <button class="btn-eye" type="button" onclick="toggleEye('confirmPassword','eyeConfirm')">
                            <i class="bi bi-eye" id="eyeConfirm"></i>
                        </button>
                    </div>
                    <div class="match-text" id="matchText"></div>
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn-save flex-fill">
                        <i class="bi bi-arrow-repeat"></i> Update Password
                    </button>
                    <a href="${pageContext.request.contextPath}/customer?action=profile"
                       class="btn-cancel flex-fill justify-content-center">
                        <i class="bi bi-x-circle"></i> Cancel
                    </a>
                </div>

            </form>
        </div>

        <%-- Tips card --%>
        <div class="tip-card">
            <div class="fw-semibold text-dark mb-2" style="font-size:.88rem;">
                <i class="bi bi-lightbulb me-1" style="color:#7c3aed;"></i>
                Password Tips
            </div>
            <ul class="tip-list">
                <li><i class="bi bi-check2-circle"></i>Use at least 6 characters</li>
                <li><i class="bi bi-check2-circle"></i>Mix uppercase, lowercase, numbers and symbols</li>
                <li><i class="bi bi-check2-circle"></i>Avoid using the same word as your username</li>
                <li><i class="bi bi-check2-circle"></i>Never share your password with anyone</li>
            </ul>
        </div>

    </div>

    <%-- Toast container --%>
    <div class="toast-wrap" id="toastWrap"></div>

    <%-- Pass server messages via data attributes --%>
    <div id="serverData"
         data-success="<c:out value='${success}' default='' />"
         data-error="<c:out value='${error}'   default='' />"
         style="display:none"></div>

        </main>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        /* ── Show / hide password ── */
        function toggleEye(inputId, iconId) {
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

        /* ── Password strength ── */
        const LEVELS = [
            { pct: '20%',  bg: '#ef4444', label: 'Very Weak'  },
            { pct: '40%',  bg: '#f97316', label: 'Weak'       },
            { pct: '60%',  bg: '#eab308', label: 'Fair'       },
            { pct: '80%',  bg: '#3b82f6', label: 'Strong'     },
            { pct: '100%', bg: '#10b981', label: 'Very Strong' }
        ];

        function onNewPwd(val) {
            const fill  = document.getElementById('strengthFill');
            const label = document.getElementById('strengthLabel');
            const inp   = document.getElementById('newPassword');

            if (!val) {
                fill.style.width = '0'; label.textContent = '';
                inp.classList.remove('is-valid','is-invalid'); return;
            }

            let score = 0;
            if (val.length >= 6)               score++;
            if (val.length >= 10)              score++;
            if (/[A-Z]/.test(val))             score++;
            if (/[0-9]/.test(val))             score++;
            if (/[^A-Za-z0-9]/.test(val))      score++;

            const lvl = LEVELS[Math.min(score - 1, 4)] || LEVELS[0];
            fill.style.width      = lvl.pct;
            fill.style.background = lvl.bg;
            label.textContent     = 'Strength: ' + lvl.label;
            label.style.color     = lvl.bg;

            inp.classList.toggle('is-valid',   val.length >= 6);
            inp.classList.toggle('is-invalid', val.length < 6);

            const conf = document.getElementById('confirmPassword');
            if (conf.value) onConfirm();
        }

        /* ── Confirm match ── */
        function onConfirm() {
            const np   = document.getElementById('newPassword').value;
            const cp   = document.getElementById('confirmPassword').value;
            const mt   = document.getElementById('matchText');
            const conf = document.getElementById('confirmPassword');
            if (!cp) { mt.textContent = ''; conf.classList.remove('is-valid','is-invalid'); return; }
            if (np === cp) {
                mt.textContent  = '✓ Passwords match';
                mt.style.color  = '#10b981';
                conf.classList.add('is-valid'); conf.classList.remove('is-invalid');
            } else {
                mt.textContent  = '✗ Passwords do not match';
                mt.style.color  = '#ef4444';
                conf.classList.add('is-invalid'); conf.classList.remove('is-valid');
            }
        }

        /* ── Submit guard ── */
        document.getElementById('cpForm').addEventListener('submit', function(e) {
            const np = document.getElementById('newPassword').value;
            const cp = document.getElementById('confirmPassword').value;
            const op = document.getElementById('oldPassword').value;
            if (!op.trim()) {
                e.preventDefault();
                showToast('error', 'Validation Error', 'Please enter your current password.');
                return;
            }
            if (np.length < 6) {
                e.preventDefault();
                showToast('error', 'Validation Error', 'New password must be at least 6 characters.');
                return;
            }
            if (np !== cp) {
                e.preventDefault();
                showToast('error', 'Validation Error', 'Passwords do not match.');
            }
        });

        /* ── Toast ── */
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
            closeBtn.innerHTML = '<i class="bi bi-x-lg"></i>';
            closeBtn.onclick = function() { dismiss(item); };

            const progress = document.createElement('div');
            progress.className = 'toast-progress';

            item.appendChild(icon);
            item.appendChild(body);
            item.appendChild(closeBtn);
            item.appendChild(progress);
            wrap.appendChild(item);

            const t = setTimeout(function() { dismiss(item); }, 4500);
            item._t = t;
        }

        function dismiss(el) {
            if (!el || el.classList.contains('hiding')) return;
            clearTimeout(el._t);
            el.classList.add('hiding');
            setTimeout(function() { el.remove(); }, 320);
        }

        /* ── Show server messages on load ── */
        document.addEventListener('DOMContentLoaded', function() {
            const d       = document.getElementById('serverData');
            const success = d.dataset.success.trim();
            const error   = d.dataset.error.trim();
            if (success) showToast('success', 'Password Updated!', success);
            if (error)   showToast('error',   'Error',              error);
        });
    </script>
        </main>
      </div>
    </div>
</body>
</html>
