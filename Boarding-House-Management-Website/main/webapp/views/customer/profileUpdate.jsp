<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Edit Profile - AKDD House</title>
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
            padding: 28px 28px;
            color: #fff;
            display: flex;
            align-items: center;
            gap: 20px;
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
        .hero-avatar {
            width: 72px; height: 72px;
            background: rgba(255,255,255,.2);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 32px;
            border: 2.5px solid rgba(255,255,255,.4);
            flex-shrink: 0;
        }
        .page-hero h4 { font-weight: 700; margin-bottom: 2px; font-size: 1.3rem; }
        .page-hero small { opacity: .8; font-size: .88rem; }

        /* ── Form card ── */
        .form-card {
            background: #fff;
            border-radius: 16px;
            border: none;
            box-shadow: 0 2px 20px rgba(0,0,0,.07);
            padding: 2rem;
        }

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
        .field-wrap input.readonly-field {
            background: #f9fafb;
            color: #6b7280;
            cursor: not-allowed;
        }
        .form-label { font-weight: 600; font-size: .85rem; color: #374151; margin-bottom: .35rem; }
        .field-hint { font-size: .78rem; color: #9ca3af; margin-top: .3rem; }

        /* ── Buttons ── */
        .btn-save {
            background: linear-gradient(135deg, #4f46e5, #7c3aed);
            border: none; border-radius: 10px;
            color: #fff; font-weight: 600; font-size: .93rem;
            height: 44px; padding: 0 1.5rem;
            display: inline-flex; align-items: center; gap: .4rem;
            transition: opacity .2s, transform .15s;
            cursor: pointer;
        }
        .btn-save:hover  { opacity: .9; }
        .btn-save:active { transform: scale(.98); }
        .btn-cancel {
            border: 1.5px solid #e5e7eb;
            border-radius: 10px;
            background: #fff;
            color: #6b7280; font-weight: 600; font-size: .93rem;
            height: 44px; padding: 0 1.5rem;
            display: inline-flex; align-items: center; gap: .4rem;
            text-decoration: none;
            transition: border-color .2s, color .2s;
        }
        .btn-cancel:hover { border-color: #7c3aed; color: #7c3aed; }

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
    <div style="max-width: 620px;">

        <%-- Hero header --%>
        <div class="page-hero">
            <div class="hero-avatar">
                <i class="bi bi-person-fill"></i>
            </div>
            <div style="position:relative;z-index:1;">
                <h4>Edit Profile</h4>
                <small>Update your personal information</small>
            </div>
        </div>

        <%-- Form card --%>
        <div class="form-card">

            <div class="section-label">Account Information</div>

            <form action="${pageContext.request.contextPath}/customer" method="post" id="editForm" novalidate>
                <input type="hidden" name="action" value="updateProfile">

                <%-- Username (read-only) --%>
                <div class="mb-3">
                    <label class="form-label">Username</label>
                    <div class="field-wrap">
                        <i class="bi bi-at field-icon"></i>
                        <input type="text" class="readonly-field" value="${user.username}" readonly>
                    </div>
                    <div class="field-hint"><i class="bi bi-info-circle me-1"></i>Username cannot be changed</div>
                </div>

                <%-- Full Name --%>
                <div class="mb-3">
                    <label class="form-label">Full Name <span style="color:#ef4444">*</span></label>
                    <div class="field-wrap">
                        <i class="bi bi-person field-icon"></i>
                        <input type="text" name="fullName" id="fullName" class="form-control"
                               placeholder="Enter your full name"
                               value="${user.fullName}" required
                               oninput="validateFullName(this)">
                    </div>
                    <div class="field-hint" id="err-fullname" style="color:#ef4444;display:none">Full name is required</div>
                </div>

                <%-- Email --%>
                <div class="mb-3">
                    <label class="form-label">Email Address</label>
                    <div class="field-wrap">
                        <i class="bi bi-envelope field-icon"></i>
                        <input type="email" name="email" id="emailField" class="form-control"
                               placeholder="you@example.com"
                               value="${user.email}"
                               oninput="validateEmail(this)">
                    </div>
                    <div class="field-hint" id="err-email" style="color:#ef4444;display:none">Invalid email address</div>
                </div>

                <%-- Phone --%>
                <div class="mb-4">
                    <label class="form-label">Phone Number</label>
                    <div class="field-wrap">
                        <i class="bi bi-telephone field-icon"></i>
                        <input type="tel" name="phone" id="phoneField" class="form-control"
                               placeholder="09xxxxxxxx"
                               value="${user.phone}"
                               oninput="validatePhone(this)">
                    </div>
                    <div class="field-hint" id="err-phone" style="color:#ef4444;display:none">Invalid phone number</div>
                </div>

                <%-- Action buttons --%>
                <div class="d-flex gap-2">
                    <button type="submit" class="btn-save flex-fill">
                        <i class="bi bi-check-circle"></i> Save Changes
                    </button>
                    <a href="${pageContext.request.contextPath}/customer?action=profile"
                       class="btn-cancel flex-fill justify-content-center">
                        <i class="bi bi-x-circle"></i> Cancel
                    </a>
                </div>

            </form>
        </div>
    </div>

    <%-- Toast container --%>
    <div class="toast-wrap" id="toastWrap"></div>

    <%-- Pass server error via data attribute --%>
    <div id="serverData"
         data-error="<c:out value='${error}' default='' />"
         style="display:none"></div>

        </main>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        /* ── Validation ── */
        function validateFullName(el) {
            const ok = el.value.trim().length > 0;
            el.style.borderColor = ok ? '#e5e7eb' : '#ef4444';
            document.getElementById('err-fullname').style.display = ok ? 'none' : 'block';
            return ok;
        }
        function validateEmail(el) {
            if (!el.value) { el.style.borderColor = '#e5e7eb'; document.getElementById('err-email').style.display='none'; return true; }
            const ok = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(el.value);
            el.style.borderColor = ok ? '#10b981' : '#ef4444';
            document.getElementById('err-email').style.display = ok ? 'none' : 'block';
            return ok;
        }
        function validatePhone(el) {
            if (!el.value) { el.style.borderColor = '#e5e7eb'; document.getElementById('err-phone').style.display='none'; return true; }
            const ok = /^(0|\+\d{1,3})[0-9]{8,11}$/.test(el.value.replace(/\s/g,''));
            el.style.borderColor = ok ? '#10b981' : '#ef4444';
            document.getElementById('err-phone').style.display = ok ? 'none' : 'block';
            return ok;
        }

        document.getElementById('editForm').addEventListener('submit', function(e) {
            const fn = document.getElementById('fullName');
            if (!validateFullName(fn)) {
                e.preventDefault();
                showToast('error', 'Validation Error', 'Full name is required.');
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

        document.addEventListener('DOMContentLoaded', function() {
            const err = document.getElementById('serverData').dataset.error.trim();
            if (err) showToast('error', 'Update Failed', err);
        });
    </script>
        </main>
      </div>
    </div>
</body>
</html>
