<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>My Profile - AKDD House</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; }
        .profile-header {
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 16px;
            color: white;
            padding: 32px 24px;
            position: relative;
            overflow: hidden;
        }
        .profile-header::after {
            content: '';
            position: absolute;
            top: -40px; right: -40px;
            width: 160px; height: 160px;
            border-radius: 50%;
            background: rgba(255,255,255,0.08);
        }
        .avatar-wrapper {
            width: 100px; height: 100px;
            border-radius: 50%;
            background: rgba(255,255,255,0.2);
            display: flex; align-items: center; justify-content: center;
            font-size: 42px;
            border: 3px solid rgba(255,255,255,0.4);
            flex-shrink: 0;
        }
        .info-card { border-radius: 14px; border: none; }
        .info-row {
            display: flex;
            align-items: flex-start;
            padding: 14px 0;
            border-bottom: 1px solid #f0f0f0;
        }
        .info-row:last-child { border-bottom: none; }
        .info-label {
            width: 160px;
            color: #6c757d;
            font-size: 13px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: .4px;
            flex-shrink: 0;
        }
        .info-value { font-weight: 500; color: #212529; }
        .role-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        .role-admin    { background: #fff3cd; color: #856404; }
        .role-staff    { background: #cff4fc; color: #0a6071; }
        .role-customer { background: #d1e7dd; color: #0a3622; }
        .btn-edit {
            background: linear-gradient(135deg, #667eea, #764ba2);
            border: none;
        }
        .btn-edit:hover { background: linear-gradient(135deg, #5568d6, #6a3fa0); }
    </style>
</head>
<body>
    <%@ include file="../navbar.jsp" %>

    <div class="container-fluid p-0">
      <div class="row g-0" style="min-height: calc(100vh - 56px);">
        <%@ include file="sidebar.jsp" %>
        <main class="col p-4">
    <div style="max-width: 720px;">

        <%-- Success message --%>
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success d-flex align-items-center mb-3" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>
                <span><c:out value="${sessionScope.successMessage}" /></span>
            </div>
            <% session.removeAttribute("successMessage"); %>
        </c:if>

        <%-- Profile header --%>
        <div class="profile-header mb-4 d-flex align-items-center gap-4">
            <div class="avatar-wrapper">
                <i class="bi bi-person-fill"></i>
            </div>
            <div>
                <h4 class="fw-bold mb-1">${user.fullName}</h4>
                <div class="opacity-75 small mb-2">@${user.username}</div>
                <span class="role-badge
                    ${user.role == 'admin' ? 'role-admin' :
                      user.role == 'staff' ? 'role-staff' : 'role-customer'}">
                    ${user.role == 'admin' ? 'Administrator' :
                      user.role == 'staff' ? 'Staff'         : 'Tenant'}
                </span>
            </div>
        </div>

        <%-- Info card --%>
        <div class="card info-card shadow-sm mb-4">
            <div class="card-body px-4 py-3">

                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h6 class="fw-bold text-muted mb-0">
                        <i class="bi bi-person-lines-fill me-2"></i>Personal Information
                    </h6>
                    <a href="${pageContext.request.contextPath}/customer?action=editProfile"
                       class="btn btn-edit btn-primary btn-sm">
                        <i class="bi bi-pencil-square me-1"></i>Edit
                    </a>
                </div>

                <div class="info-row">
                    <div class="info-label"><i class="bi bi-person me-2"></i>Full Name</div>
                    <div class="info-value">${not empty user.fullName ? user.fullName : '—'}</div>
                </div>

                <div class="info-row">
                    <div class="info-label"><i class="bi bi-at me-2"></i>Username</div>
                    <div class="info-value text-muted">${user.username}</div>
                </div>

                <div class="info-row">
                    <div class="info-label"><i class="bi bi-envelope me-2"></i>Email</div>
                    <div class="info-value">
                        <c:choose>
                            <c:when test="${not empty user.email}">
                                <a href="mailto:${user.email}" class="text-decoration-none">${user.email}</a>
                            </c:when>
                            <c:otherwise><span class="text-muted">Not set</span></c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="info-row">
                    <div class="info-label"><i class="bi bi-telephone me-2"></i>Phone</div>
                    <div class="info-value">
                        <c:choose>
                            <c:when test="${not empty user.phone}">
                                <a href="tel:${user.phone}" class="text-decoration-none">${user.phone}</a>
                            </c:when>
                            <c:otherwise><span class="text-muted">Not set</span></c:otherwise>
                        </c:choose>
                    </div>
                </div>

            </div>
        </div>

        <%-- Quick actions --%>
        <div class="row g-3">
            <div class="col-sm-6">
                <a href="${pageContext.request.contextPath}/customer?action=editProfile"
                   class="card info-card shadow-sm text-decoration-none d-flex flex-row align-items-center p-3 gap-3">
                    <div class="rounded-circle d-flex align-items-center justify-content-center"
                         style="width:44px;height:44px;background:#e8eaff;flex-shrink:0">
                        <i class="bi bi-pencil" style="color:#667eea;font-size:18px"></i>
                    </div>
                    <div>
                        <div class="fw-semibold text-dark small">Edit Profile</div>
                        <div class="text-muted" style="font-size:12px">Update your personal details</div>
                    </div>
                </a>
            </div>
            <div class="col-sm-6">
                <a href="${pageContext.request.contextPath}/auth?action=changePassword"
                   class="card info-card shadow-sm text-decoration-none d-flex flex-row align-items-center p-3 gap-3">
                    <div class="rounded-circle d-flex align-items-center justify-content-center"
                         style="width:44px;height:44px;background:#f0fdf4;flex-shrink:0">
                        <i class="bi bi-shield-lock" style="color:#28a745;font-size:18px"></i>
                    </div>
                    <div>
                        <div class="fw-semibold text-dark small">Change Password</div>
                        <div class="text-muted" style="font-size:12px">Update your security password</div>
                    </div>
                </a>
            </div>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        </main>
      </div>
    </div>
</body>
</html>
