<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page session="true"%>
<%@taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Dashboard - AKDD House</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; }
        .section-card {
            border: none;
            border-radius: 14px;
            box-shadow: 0 1px 8px rgba(0,0,0,.07);
        }
        .section-card .card-header {
            background: transparent;
            border-bottom: 1px solid #f0f0f0;
            font-weight: 600;
            padding: 1rem 1.25rem 0.75rem;
        }
        .info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.45rem 0;
            border-bottom: 1px solid #f5f5f5;
            font-size: .9rem;
        }
        .info-row:last-child { border-bottom: none; }
        .info-label { color: #6c757d; }
        .status-badge-pending  { background:#fff3cd; color:#856404; }
        .status-badge-approved { background:#d1e7dd; color:#0f5132; }
        .status-badge-rejected { background:#f8d7da; color:#842029; }
        .status-badge-paid     { background:#d1e7dd; color:#0f5132; }
        .status-badge-unpaid   { background:#f8d7da; color:#842029; }
        .status-badge-overdue  { background:#f8d7da; color:#842029; }
        .status-badge {
            font-size: .75rem;
            padding: .25rem .6rem;
            border-radius: 20px;
            font-weight: 600;
            text-transform: capitalize;
        }
    </style>
</head>
<body class="bg-light" style="overflow-x:hidden;">

<%@ include file="../navbar.jsp" %>

<div class="container-fluid p-0">
  <div class="row g-0" style="min-height: calc(100vh - 56px);">
    <%@ include file="sidebar.jsp" %>
    <main class="col p-4">

    <!-- WELCOME -->
    <div class="mb-4">
        <h4 class="fw-bold mb-0">Welcome, ${sessionScope.user.fullName}</h4>
        <small class="text-muted">Here's an overview of your account</small>
    </div>

    <div class="row g-4">

        <!-- LEFT COLUMN -->
        <div class="col-lg-7">

            <!-- SECTION 1: MY ROOM -->
            <div class="card section-card mb-4">
                <div class="card-header d-flex align-items-center gap-2">
                    <i class="bi bi-house-door text-info"></i> My Room
                </div>
                <div class="card-body px-4 py-3">
                    <c:choose>
                        <c:when test="${not empty contract}">
                            <div class="info-row">
                                <span class="info-label">Room Number</span>
                                <span class="fw-semibold">${contract.roomNumber}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Room Type</span>
                                <span>${contract.categoryName}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Contract End Date</span>
                                <span>${contract.endDate}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Roommates</span>
                                <span>${contract.tenantCount}</span>
                            </div>
                            <div class="mt-3">
                                <a href="${pageContext.request.contextPath}/contract?action=mycontract"
                                   class="btn btn-sm btn-outline-info">
                                    <i class="bi bi-file-earmark-text me-1"></i>View Contract
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-muted text-center py-3">
                                <i class="bi bi-house-slash d-block fs-3 mb-2"></i>
                                No active room. <a href="${pageContext.request.contextPath}/contract?action=signContract">Sign a contract</a> to get started.
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- SECTION 2: CURRENT BILL -->
            <div class="card section-card mb-4">
                <div class="card-header d-flex align-items-center gap-2">
                    <i class="bi bi-receipt text-danger"></i> Current Bill
                </div>
                <div class="card-body px-4 py-3">
                    <c:choose>
                        <c:when test="${not empty currentBill}">
                            <div class="info-row">
                                <span class="info-label">Amount Due</span>
                                <span class="fw-bold text-danger fs-5">
                                    <fmt:formatNumber value="${currentBill.totalAmount}" groupingUsed="true" maxFractionDigits="0"/>&#8363;
                                </span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Period</span>
                                <span>${currentBill.period}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Due Date</span>
                                <span>${currentBill.dueDate}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Status</span>
                                <span class="status-badge status-badge-${currentBill.status}">${currentBill.status}</span>
                            </div>
                            <div class="mt-3 d-flex gap-2">
                                <c:if test="${currentBill.status != 'paid'}">
                                    <a href="${pageContext.request.contextPath}/bill?action=detail&id=${currentBill.billId}"
                                       class="btn btn-sm btn-danger">
                                        <i class="bi bi-credit-card me-1"></i>Pay Bill
                                    </a>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/bill?action=mybill"
                                   class="btn btn-sm btn-outline-secondary">
                                    <i class="bi bi-list-ul me-1"></i>View All Bills
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-muted text-center py-3">
                                <i class="bi bi-receipt d-block fs-3 mb-2"></i>
                                No bills yet.
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

        </div>

        <!-- RIGHT COLUMN -->
        <div class="col-lg-5">

            <!-- SECTION 3: RECENT NOTIFICATIONS -->
            <div class="card section-card mb-4">
                <div class="card-header d-flex align-items-center justify-content-between">
                    <span><i class="bi bi-bell text-warning me-2"></i>Notifications</span>
                    <a href="${pageContext.request.contextPath}/notification?action=publicList"
                       class="text-decoration-none small text-muted">View all</a>
                </div>
                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${empty recentNotifications}">
                            <div class="text-muted text-center py-4 small">
                                <i class="bi bi-bell-slash d-block fs-4 mb-1"></i>No notifications
                            </div>
                        </c:when>
                        <c:otherwise>
                            <ul class="list-group list-group-flush">
                                <c:forEach var="n" items="${recentNotifications}">
                                    <li class="list-group-item border-0 px-4 py-2">
                                        <div class="fw-semibold small text-truncate" style="max-width:260px;">${n.title}</div>
                                        <div class="text-muted" style="font-size:.78rem;">${n.createdAt}</div>
                                    </li>
                                </c:forEach>
                            </ul>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- SECTION 4: RECENT SERVICE REQUESTS -->
            <div class="card section-card">
                <div class="card-header d-flex align-items-center justify-content-between">
                    <span><i class="bi bi-tools text-success me-2"></i>Service Requests</span>
                    <a href="${pageContext.request.contextPath}/services?action=myHistory"
                       class="text-decoration-none small text-muted">View all</a>
                </div>
                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${empty recentServices}">
                            <div class="text-muted text-center py-4 small">
                                <i class="bi bi-clipboard-x d-block fs-4 mb-1"></i>No service requests
                            </div>
                        </c:when>
                        <c:otherwise>
                            <ul class="list-group list-group-flush">
                                <c:forEach var="s" items="${recentServices}">
                                    <li class="list-group-item border-0 px-4 py-2 d-flex justify-content-between align-items-center">
                                        <div>
                                            <div class="fw-semibold small">${s.serviceName}</div>
                                            <div class="text-muted" style="font-size:.78rem;">${s.usageDate}</div>
                                        </div>
                                        <span class="status-badge status-badge-${s.status}">${s.status}</span>
                                    </li>
                                </c:forEach>
                            </ul>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

        </div>
    </div>
    </main>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
