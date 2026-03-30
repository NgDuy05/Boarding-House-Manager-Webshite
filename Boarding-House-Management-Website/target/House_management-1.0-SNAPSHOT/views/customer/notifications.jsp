<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Notifications - AKDD House</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { background: #f4f6f9; font-family: 'Inter', sans-serif; }

        /* ── Hero ── */
        .page-hero {
            background: linear-gradient(135deg, #4f46e5, #7c3aed);
            color: #fff; padding: 48px 0 56px; margin-bottom: -32px;
        }
        .page-hero h1 { font-weight: 700; font-size: 2rem; }

        /* ── Filter bar ── */
        .filter-bar {
            background: #fff; border-radius: 50px;
            padding: 6px; display: inline-flex; gap: 4px;
            box-shadow: 0 2px 12px rgba(0,0,0,.09);
        }
        .filter-btn {
            border-radius: 50px; border: none;
            padding: 8px 20px; font-weight: 600; font-size: .84rem;
            cursor: pointer; text-decoration: none;
            display: inline-flex; align-items: center; gap: .4rem;
            color: #6b7280; background: transparent; transition: all .2s;
        }
        .filter-btn:hover  { background: #f3f4f6; color: #374151; }
        .filter-btn.active { background: linear-gradient(135deg,#4f46e5,#7c3aed); color: #fff; }

        /* ── Notification cards ── */
        .notif-card {
            background: #fff; border-radius: 16px; border: none;
            box-shadow: 0 2px 16px rgba(0,0,0,.07);
            padding: 1.4rem 1.6rem;
            transition: transform .18s, box-shadow .18s;
            display: flex; gap: 1.2rem; align-items: flex-start;
        }
        .notif-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 28px rgba(0,0,0,.11);
        }

        .notif-icon-wrap {
            width: 48px; height: 48px; flex-shrink: 0;
            border-radius: 14px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.3rem;
        }
        .icon-broadcast { background: #ede9fe; color: #7c3aed; }
        .icon-targeted  { background: #dbeafe; color: #1d4ed8; }

        .notif-body { flex: 1; min-width: 0; }
        .notif-title {
            font-weight: 700; font-size: 1rem; color: #1e1b4b;
            margin-bottom: .25rem;
            white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
        }
        .notif-preview {
            font-size: .85rem; color: #6b7280;
            display: -webkit-box;
            -webkit-line-clamp: 2; -webkit-box-orient: vertical;
            overflow: hidden; margin-bottom: .6rem;
        }
        .notif-meta {
            display: flex; align-items: center; gap: 1rem;
            flex-wrap: wrap;
        }
        .notif-meta span { font-size: .78rem; color: #9ca3af; display: flex; align-items: center; gap: .3rem; }
        .badge-broadcast { background: #ede9fe; color: #6d28d9; }
        .badge-targeted  { background: #dbeafe; color: #1e40af; }
        .badge-pill {
            border-radius: 20px; padding: 2px 10px;
            font-size: .73rem; font-weight: 700;
        }

        .notif-action {
            flex-shrink: 0; align-self: center;
        }
        .btn-read {
            display: inline-flex; align-items: center; gap: .3rem;
            font-size: .82rem; font-weight: 600; color: #7c3aed;
            text-decoration: none; padding: 6px 14px;
            border: 1.5px solid #ede9fe; border-radius: 10px;
            transition: all .18s; white-space: nowrap;
        }
        .btn-read:hover {
            background: #ede9fe; color: #6d28d9; border-color: #ddd6fe;
        }

        .empty-state { text-align: center; padding: 4rem 1rem; color: #9ca3af; }
        .empty-state i { font-size: 3.5rem; display: block; margin-bottom: 1rem; }

        .results-info { font-size: .85rem; color: #9ca3af; margin-bottom: 1.25rem; }
        .results-info strong { color: #4f46e5; }
    </style>
</head>
<body>
    <%@ include file="../navbar.jsp" %>

    <div class="container-fluid p-0">
      <div class="row g-0" style="min-height: calc(100vh - 56px);">
        <%@ include file="sidebar.jsp" %>
        <main class="col p-0">

    <%-- Hero --%>
    <div class="page-hero">
        <div class="container">
            <nav aria-label="breadcrumb" class="mb-3">
                <ol class="breadcrumb" style="--bs-breadcrumb-divider-color:rgba(255,255,255,.5)">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/" class="text-white text-opacity-75">Home</a>
                    </li>
                    <li class="breadcrumb-item active text-white">Notifications</li>
                </ol>
            </nav>
            <h1><i class="bi bi-bell-fill me-2"></i>Notifications</h1>
            <p class="mb-0 opacity-85">Stay updated with announcements and important messages</p>
        </div>
    </div>

    <div class="container pb-5" style="padding-top: 48px;">

        <%-- Filter bar --%>
        <div class="d-flex justify-content-center mb-4">
            <div class="filter-bar">
                <a href="${pageContext.request.contextPath}/notification?action=publicList"
                   class="filter-btn ${empty typeFilter ? 'active' : ''}">
                    <i class="bi bi-grid"></i> All
                    <span style="background:#e5e7eb;color:#374151;border-radius:20px;padding:1px 8px;font-size:.73rem">
                        ${totalItems}
                    </span>
                </a>
                <a href="${pageContext.request.contextPath}/notification?action=publicList&type=broadcast"
                   class="filter-btn ${typeFilter == 'broadcast' ? 'active' : ''}">
                    <i class="bi bi-megaphone"></i> General
                </a>
                <a href="${pageContext.request.contextPath}/notification?action=publicList&type=targeted"
                   class="filter-btn ${typeFilter == 'targeted' ? 'active' : ''}">
                    <i class="bi bi-person-lines-fill"></i> For Me
                </a>
            </div>
        </div>

        <%-- Results info --%>
        <div class="results-info">
            <strong>${totalItems}</strong>
            notification<c:if test="${totalItems != 1}">s</c:if>
            <c:if test="${typeFilter == 'broadcast'}"> &middot; general only</c:if>
            <c:if test="${typeFilter == 'targeted'}"> &middot; targeted to you</c:if>
        </div>

        <%-- Notification list --%>
        <c:choose>
            <c:when test="${empty notifications}">
                <div class="empty-state">
                    <i class="bi bi-bell-slash"></i>
                    <h5>No notifications</h5>
                    <p class="mb-0">
                        <c:choose>
                            <c:when test="${typeFilter == 'broadcast'}">No general notifications found.</c:when>
                            <c:when test="${typeFilter == 'targeted'}">No personal notifications found.</c:when>
                            <c:otherwise>You have no notifications at the moment.</c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="d-flex flex-column gap-3">
                    <c:forEach var="n" items="${notifications}">
                        <div class="notif-card">
                            <%-- Icon --%>
                            <div class="notif-icon-wrap ${n.broadcast ? 'icon-broadcast' : 'icon-targeted'}">
                                <i class="bi ${n.broadcast ? 'bi-megaphone-fill' : 'bi-person-fill-exclamation'}"></i>
                            </div>

                            <%-- Content --%>
                            <div class="notif-body">
                                <div class="notif-title">${n.title}</div>
                                <div class="notif-preview">${n.content}</div>
                                <div class="notif-meta">
                                    <%-- Type badge --%>
                                    <span>
                                        <c:choose>
                                            <c:when test="${n.broadcast}">
                                                <span class="badge-pill badge-broadcast">
                                                    <i class="bi bi-megaphone me-1"></i>General
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-pill badge-targeted">
                                                    <i class="bi bi-person me-1"></i>For You
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                    <%-- Created by --%>
                                    <span>
                                        <i class="bi bi-person-circle"></i>
                                        ${not empty n.createdByName ? n.createdByName : 'System'}
                                    </span>
                                    <%-- Timestamp --%>
                                    <c:if test="${not empty n.createdAt}">
                                        <span>
                                            <i class="bi bi-clock"></i>
                                            <fmt:formatDate value="${n.createdAt}" pattern="MMM dd, yyyy HH:mm"/>
                                        </span>
                                    </c:if>
                                </div>
                            </div>

                            <%-- Action --%>
                            <div class="notif-action">
                                <a href="${pageContext.request.contextPath}/notification?action=publicDetail&id=${n.notificationId}"
                                   class="btn-read">
                                    Read <i class="bi bi-arrow-right"></i>
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

        <%-- Pagination --%>
        <c:if test="${totalPages > 1}">
            <div class="d-flex justify-content-between align-items-center mt-4">
                <div class="text-muted small">
                    Showing <strong>${(currentPage - 1) * pageSize + 1}</strong>–<strong>${(currentPage - 1) * pageSize + notifications.size()}</strong>
                    of <strong>${totalItems}</strong>
                </div>
                <nav>
                    <ul class="pagination pagination-sm mb-0">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/notification?action=publicList&page=${currentPage - 1}&type=${typeFilter}">
                                <i class="bi bi-chevron-left"></i>
                            </a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="p">
                            <c:choose>
                                <c:when test="${p == currentPage}">
                                    <li class="page-item active"><span class="page-link">${p}</span></li>
                                </c:when>
                                <c:when test="${p == 1 || p == totalPages || (p >= currentPage - 2 && p <= currentPage + 2)}">
                                    <li class="page-item">
                                        <a class="page-link" href="${pageContext.request.contextPath}/notification?action=publicList&page=${p}&type=${typeFilter}">${p}</a>
                                    </li>
                                </c:when>
                                <c:when test="${(p == currentPage - 3 && currentPage > 4) || (p == currentPage + 3 && currentPage < totalPages - 3)}">
                                    <li class="page-item disabled"><span class="page-link">…</span></li>
                                </c:when>
                            </c:choose>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/notification?action=publicList&page=${currentPage + 1}&type=${typeFilter}">
                                <i class="bi bi-chevron-right"></i>
                            </a>
                        </li>
                    </ul>
                </nav>
            </div>
        </c:if>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        </main>
      </div>
    </div>
</body>
</html>
