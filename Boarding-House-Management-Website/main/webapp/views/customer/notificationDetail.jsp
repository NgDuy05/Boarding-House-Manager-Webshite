<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title><c:choose><c:when test="${not empty notification}">${notification.title} - </c:when></c:choose>Notifications - AKDD House</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { background: #f4f6f9; font-family: 'Inter', sans-serif; }

        .page-hero {
            background: linear-gradient(135deg, #4f46e5, #7c3aed);
            color: #fff; padding: 48px 0 56px; margin-bottom: -32px;
        }
        .page-hero h1 { font-weight: 700; font-size: 1.85rem; line-height: 1.3; }

        .detail-card {
            background: #fff; border-radius: 20px; border: none;
            box-shadow: 0 4px 24px rgba(0,0,0,.08);
            overflow: hidden;
        }

        .detail-header {
            padding: 2rem 2rem 1.5rem;
            border-bottom: 1px solid #f3f4f6;
        }
        .detail-type-badge {
            display: inline-flex; align-items: center; gap: .4rem;
            border-radius: 20px; padding: 5px 14px;
            font-size: .8rem; font-weight: 700;
            margin-bottom: 1rem;
        }
        .badge-broadcast { background: #ede9fe; color: #6d28d9; }
        .badge-targeted  { background: #dbeafe; color: #1e40af; }

        .detail-title {
            font-size: 1.5rem; font-weight: 700; color: #1e1b4b;
            margin-bottom: 1rem; line-height: 1.4;
        }

        .meta-row {
            display: flex; flex-wrap: wrap; gap: 1.5rem;
        }
        .meta-item {
            display: flex; align-items: center; gap: .5rem;
            font-size: .82rem; color: #9ca3af;
        }
        .meta-item i { color: #7c3aed; font-size: 1rem; }
        .meta-item strong { color: #374151; }

        .detail-content {
            padding: 2rem;
            font-size: 1rem; line-height: 1.85;
            color: #374151; white-space: pre-wrap;
        }

        .btn-back {
            display: inline-flex; align-items: center; gap: .4rem;
            color: #7c3aed; font-weight: 600; font-size: .88rem;
            text-decoration: none; margin-bottom: 1.5rem;
        }
        .btn-back:hover { text-decoration: underline; color: #6d28d9; }

        .icon-hero {
            width: 64px; height: 64px; border-radius: 18px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.8rem; margin-bottom: 1.25rem;
        }
        .icon-broadcast { background: rgba(255,255,255,.2); color: #fff; }
        .icon-targeted  { background: rgba(255,255,255,.2); color: #fff; }

        .not-found { text-align:center; padding: 4rem 1rem; color: #9ca3af; }
        .not-found i { font-size: 3rem; display:block; margin-bottom: 1rem; }
    </style>
</head>
<body>
    <%@ include file="../navbar.jsp" %>

    <div class="container-fluid p-0">
      <div class="row g-0" style="min-height: calc(100vh - 56px);">
        <%@ include file="sidebar.jsp" %>
        <main class="col p-0">

    <c:choose>
        <c:when test="${empty notification}">
            <%-- Not Found --%>
            <div class="page-hero">
                <div class="container">
                    <h1><i class="bi bi-bell me-2"></i>Notification Not Found</h1>
                </div>
            </div>
            <div class="container py-5">
                <div class="not-found">
                    <i class="bi bi-exclamation-circle"></i>
                    <h5>Notification not found</h5>
                    <p>The notification you're looking for doesn't exist or has been removed.</p>
                    <a href="${pageContext.request.contextPath}/notification?action=publicList"
                       class="btn btn-primary rounded-pill px-4">
                        Back to Notifications
                    </a>
                </div>
            </div>
        </c:when>
        <c:otherwise>

            <%-- Hero --%>
            <div class="page-hero">
                <div class="container">
                    <nav aria-label="breadcrumb" class="mb-3">
                        <ol class="breadcrumb" style="--bs-breadcrumb-divider-color:rgba(255,255,255,.5)">
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/" class="text-white text-opacity-75">Home</a>
                            </li>
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/notification?action=publicList"
                                   class="text-white text-opacity-75">Notifications</a>
                            </li>
                            <li class="breadcrumb-item active text-white">Detail</li>
                        </ol>
                    </nav>
                    <div class="icon-hero ${notification.broadcast ? 'icon-broadcast' : 'icon-targeted'}">
                        <i class="bi ${notification.broadcast ? 'bi-megaphone-fill' : 'bi-person-fill-exclamation'}"></i>
                    </div>
                    <h1>${notification.title}</h1>
                </div>
            </div>

            <div class="container py-4" style="max-width: 780px;">

                <a href="${pageContext.request.contextPath}/notification?action=publicList" class="btn-back">
                    <i class="bi bi-arrow-left"></i> Back to Notifications
                </a>

                <div class="detail-card">

                    <%-- Header: meta info --%>
                    <div class="detail-header">
                        <div class="detail-type-badge ${notification.broadcast ? 'badge-broadcast' : 'badge-targeted'}">
                            <i class="bi ${notification.broadcast ? 'bi-megaphone' : 'bi-person'}"></i>
                            ${notification.broadcast ? 'Broadcast Announcement' : 'Personal Notification'}
                        </div>

                        <div class="detail-title">${notification.title}</div>

                        <div class="meta-row">
                            <div class="meta-item">
                                <i class="bi bi-person-circle"></i>
                                <span>From: <strong>${not empty notification.createdByName ? notification.createdByName : 'System'}</strong></span>
                            </div>
                            <c:if test="${not empty notification.createdAt}">
                                <div class="meta-item">
                                    <i class="bi bi-calendar3"></i>
                                    <span>
                                        <strong><fmt:formatDate value="${notification.createdAt}" pattern="MMMM dd, yyyy"/></strong>
                                    </span>
                                </div>
                                <div class="meta-item">
                                    <i class="bi bi-clock"></i>
                                    <span>
                                        <strong><fmt:formatDate value="${notification.createdAt}" pattern="HH:mm"/></strong>
                                    </span>
                                </div>
                            </c:if>
                            <c:if test="${not notification.broadcast}">
                                <div class="meta-item">
                                    <i class="bi bi-file-earmark-text"></i>
                                    <span>Contract ID: <strong>#${notification.targetContractId}</strong></span>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <%-- Full content --%>
                    <div class="detail-content">${notification.content}</div>

                </div>

                <%-- Navigation buttons --%>
                <div class="d-flex gap-3 mt-4">
                    <a href="${pageContext.request.contextPath}/notification?action=publicList"
                       class="btn px-4 py-2 fw-semibold rounded-pill"
                       style="background:#f3f4f6;color:#374151;border:none">
                        <i class="bi bi-arrow-left me-1"></i>All Notifications
                    </a>
                    <a href="${pageContext.request.contextPath}/notification?action=publicList&type=${notification.broadcast ? 'broadcast' : 'targeted'}"
                       class="btn px-4 py-2 fw-semibold rounded-pill"
                       style="background:linear-gradient(135deg,#4f46e5,#7c3aed);color:#fff;border:none">
                        <i class="bi bi-filter me-1"></i>
                        More ${notification.broadcast ? 'Broadcast' : 'Personal'} Notifications
                    </a>
                </div>

            </div>

        </c:otherwise>
    </c:choose>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        </main>
      </div>
    </div>
</body>
</html>
