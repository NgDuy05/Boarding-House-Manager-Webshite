<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Activity Logs - AKDD House</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; }

        .page-header {
            background: linear-gradient(135deg, #3a1c71, #d76d77, #ffaf7b);
            color: white;
            border-radius: 12px;
            padding: 20px 26px;
            margin-bottom: 24px;
        }

        /* ── Timeline ── */
        .timeline { position: relative; padding-left: 0; }

        .tl-item {
            display: flex;
            gap: 16px;
            margin-bottom: 0;
            position: relative;
        }

        /* vertical connector line */
        .tl-item:not(:last-child) .tl-line {
            position: absolute;
            left: 19px;
            top: 40px;
            bottom: 0;
            width: 2px;
            background: #e9ecef;
            z-index: 0;
        }

        .tl-icon-wrap {
            flex-shrink: 0;
            width: 38px; height: 38px;
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 15px;
            color: white;
            position: relative;
            z-index: 1;
            box-shadow: 0 2px 6px rgba(0,0,0,0.15);
        }

        .tl-body {
            flex: 1;
            background: white;
            border-radius: 10px;
            padding: 12px 16px;
            margin-bottom: 12px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.06);
            border-left: 3px solid transparent;
        }

        .tl-body.border-success { border-left-color: #198754; }
        .tl-body.border-primary { border-left-color: #0d6efd; }
        .tl-body.border-secondary { border-left-color: #6c757d; }
        .tl-body.border-warning { border-left-color: #ffc107; }
        .tl-body.border-info    { border-left-color: #0dcaf0; }

        .tl-meta {
            font-size: 11px;
            color: #adb5bd;
        }

        .tl-avatar {
            width: 22px; height: 22px;
            border-radius: 50%;
            background: linear-gradient(135deg, #3a1c71, #d76d77);
            display: inline-flex; align-items: center; justify-content: center;
            color: white; font-weight: 700; font-size: 10px;
            flex-shrink: 0;
        }

        /* ── Filter card ── */
        .filter-card { border-radius: 14px; border: none; }

        /* ── Stat badges ── */
        .stat-pill {
            border-radius: 50px;
            padding: 6px 16px;
            font-size: 13px;
            font-weight: 600;
            display: inline-flex; align-items: center; gap: 6px;
        }

        /* ── Pagination ── */
        .pagination .page-link { color: #d76d77; border-color: #dee2e6; }
        .pagination .page-item.active .page-link { background-color: #d76d77; border-color: #d76d77; color: white; }
        .pagination .page-link:hover { background-color: #fff0f2; }
        .pagination .page-item.disabled .page-link { color: #adb5bd; }

        /* type badge colours */
        .badge-ACCOUNT_CREATED  { background: #d1e7dd; color: #0a3622; }
        .badge-CONTRACT_JOINED  { background: #cfe2ff; color: #084298; }
        .badge-CONTRACT_LEFT    { background: #e2e3e5; color: #41464b; }
        .badge-BILL_CREATED     { background: #fff3cd; color: #664d03; }
        .badge-BILL_PAID        { background: #d1e7dd; color: #0a3622; }
        .badge-SERVICE_USED     { background: #cff4fc; color: #055160; }
        .badge-UTILITY_READING  { background: #fff3cd; color: #664d03; }
    </style>
</head>
<body>
    <%@ include file="../../navbar.jsp" %>

<div class="container-fluid">
<div class="row flex-nowrap admin-layout-row">
<%@ include file="../sidebar.jsp" %>
<main class="col admin-main px-4 py-4">

        <%-- Header --%>
        <div class="page-header d-flex justify-content-between align-items-center flex-wrap gap-2">
            <div>
                <h4 class="fw-bold mb-1">
                    <i class="bi bi-activity me-2"></i>Activity Logs
                </h4>
                <small class="opacity-75">Tenant activity timeline across contracts, bills, services &amp; utilities</small>
            </div>
            <div class="badge bg-white text-dark fs-6 px-3 py-2">
                <i class="bi bi-list-ul me-1"></i>
                <strong>${totalItems}</strong> events found
            </div>
        </div>

        <%-- Summary badges --%>
        <div class="d-flex flex-wrap gap-2 mb-4">
            <a href="${pageContext.request.contextPath}/activity-log"
               class="stat-pill text-decoration-none ${empty typeFilter ? 'bg-dark text-white' : 'bg-white text-muted border'}">
                <i class="bi bi-grid-3x3-gap-fill"></i>All Types
            </a>
            <a href="${pageContext.request.contextPath}/activity-log?type=ACCOUNT_CREATED${not empty search ? '&search='.concat(search) : ''}"
               class="stat-pill text-decoration-none ${typeFilter == 'ACCOUNT_CREATED' ? 'bg-success text-white' : 'badge-ACCOUNT_CREATED border'}">
                <i class="bi bi-person-plus-fill"></i>Account
            </a>
            <a href="${pageContext.request.contextPath}/activity-log?type=CONTRACT_JOINED${not empty search ? '&search='.concat(search) : ''}"
               class="stat-pill text-decoration-none ${typeFilter == 'CONTRACT_JOINED' ? 'bg-primary text-white' : 'badge-CONTRACT_JOINED border'}">
                <i class="bi bi-file-earmark-check-fill"></i>Joined
            </a>
            <a href="${pageContext.request.contextPath}/activity-log?type=CONTRACT_LEFT${not empty search ? '&search='.concat(search) : ''}"
               class="stat-pill text-decoration-none ${typeFilter == 'CONTRACT_LEFT' ? 'bg-secondary text-white' : 'badge-CONTRACT_LEFT border'}">
                <i class="bi bi-file-earmark-x-fill"></i>Left
            </a>
            <a href="${pageContext.request.contextPath}/activity-log?type=BILL_CREATED${not empty search ? '&search='.concat(search) : ''}"
               class="stat-pill text-decoration-none ${typeFilter == 'BILL_CREATED' ? 'bg-warning text-dark' : 'badge-BILL_CREATED border'}">
                <i class="bi bi-receipt"></i>Bill Issued
            </a>
            <a href="${pageContext.request.contextPath}/activity-log?type=BILL_PAID${not empty search ? '&search='.concat(search) : ''}"
               class="stat-pill text-decoration-none ${typeFilter == 'BILL_PAID' ? 'bg-success text-white' : 'badge-BILL_PAID border'}">
                <i class="bi bi-check-circle-fill"></i>Bill Paid
            </a>
            <a href="${pageContext.request.contextPath}/activity-log?type=SERVICE_USED${not empty search ? '&search='.concat(search) : ''}"
               class="stat-pill text-decoration-none ${typeFilter == 'SERVICE_USED' ? 'bg-info text-dark' : 'badge-SERVICE_USED border'}">
                <i class="bi bi-tools"></i>Service
            </a>
            <a href="${pageContext.request.contextPath}/activity-log?type=UTILITY_READING${not empty search ? '&search='.concat(search) : ''}"
               class="stat-pill text-decoration-none ${typeFilter == 'UTILITY_READING' ? 'bg-warning text-dark' : 'badge-UTILITY_READING border'}">
                <i class="bi bi-lightning-charge-fill"></i>Utility
            </a>
        </div>

        <%-- Advanced filter form --%>
        <div class="card filter-card shadow-sm mb-4">
            <div class="card-body p-3">
                <form action="${pageContext.request.contextPath}/activity-log" method="get"
                      class="row g-2 align-items-end">

                    <div class="col-md-3">
                        <label class="form-label small fw-semibold text-muted mb-1">Search customer</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-search"></i></span>
                            <input type="text" name="search" class="form-control"
                                   placeholder="Name or username..." value="${search}">
                        </div>
                    </div>

                    <div class="col-md-2">
                        <label class="form-label small fw-semibold text-muted mb-1">Customer</label>
                        <select name="userId" class="form-select">
                            <option value="">All customers</option>
                            <c:forEach var="cu" items="${customers}">
                                <option value="${cu.userId}"
                                        ${filterUserId == cu.userId ? 'selected' : ''}>
                                    ${not empty cu.fullName ? cu.fullName : cu.username}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-md-2">
                        <label class="form-label small fw-semibold text-muted mb-1">Activity type</label>
                        <select name="type" class="form-select">
                            <option value="">All types</option>
                            <option value="ACCOUNT_CREATED"  ${typeFilter == 'ACCOUNT_CREATED'  ? 'selected' : ''}>Account Created</option>
                            <option value="CONTRACT_JOINED"  ${typeFilter == 'CONTRACT_JOINED'  ? 'selected' : ''}>Contract Joined</option>
                            <option value="CONTRACT_LEFT"    ${typeFilter == 'CONTRACT_LEFT'    ? 'selected' : ''}>Contract Left</option>
                            <option value="BILL_CREATED"     ${typeFilter == 'BILL_CREATED'     ? 'selected' : ''}>Bill Issued</option>
                            <option value="BILL_PAID"        ${typeFilter == 'BILL_PAID'        ? 'selected' : ''}>Bill Paid</option>
                            <option value="SERVICE_USED"     ${typeFilter == 'SERVICE_USED'     ? 'selected' : ''}>Service Used</option>
                            <option value="UTILITY_READING"  ${typeFilter == 'UTILITY_READING'  ? 'selected' : ''}>Utility Reading</option>
                        </select>
                    </div>

                    <div class="col-md-2">
                        <label class="form-label small fw-semibold text-muted mb-1">From date</label>
                        <input type="date" name="dateFrom" class="form-control" value="${dateFrom}">
                    </div>

                    <div class="col-md-1">
                        <label class="form-label small fw-semibold text-muted mb-1">To date</label>
                        <input type="date" name="dateTo" class="form-control" value="${dateTo}">
                    </div>

                    <div class="col-md-1">
                        <button type="submit" class="btn btn-dark w-100">
                            <i class="bi bi-funnel"></i>
                        </button>
                    </div>
                    <div class="col-md-1">
                        <a href="${pageContext.request.contextPath}/activity-log"
                           class="btn btn-outline-secondary w-100">
                            <i class="bi bi-x-circle"></i>
                        </a>
                    </div>
                </form>
            </div>
        </div>

        <%-- Timeline --%>
        <c:choose>
            <c:when test="${empty logs}">
                <div class="card border-0 shadow-sm text-center py-5">
                    <div class="text-muted">
                        <i class="bi bi-inbox fs-2 d-block mb-2"></i>
                        No activity logs found for the selected filters.
                    </div>
                </div>
            </c:when>
            <c:otherwise>

                <%-- Date grouping variable (previous date) --%>
                <c:set var="prevDate" value="" />

                <div class="timeline">
                    <c:forEach var="log" items="${logs}" varStatus="st">

                        <%-- Extract date portion for grouping header --%>
                        <c:set var="logDateStr" value="${log.formattedDate}" />

                        <c:if test="${logDateStr != prevDate}">
                            <div class="d-flex align-items-center gap-2 my-3">
                                <hr class="flex-grow-1 my-0">
                                <span class="badge bg-light text-muted border px-3 py-2 fw-semibold small">
                                    <i class="bi bi-calendar3 me-1"></i>${logDateStr}
                                </span>
                                <hr class="flex-grow-1 my-0">
                            </div>
                            <c:set var="prevDate" value="${logDateStr}" />
                        </c:if>

                        <div class="tl-item">
                            <div class="tl-line"></div>

                            <%-- Icon dot --%>
                            <div class="tl-icon-wrap bg-${log.colorClass} mt-1">
                                <i class="bi ${log.icon}"></i>
                            </div>

                            <%-- Body --%>
                            <div class="tl-body border-${log.colorClass} flex-grow-1">
                                <div class="d-flex justify-content-between align-items-start gap-2 flex-wrap">
                                    <div class="d-flex align-items-center gap-2 flex-wrap">
                                        <div class="tl-avatar">
                                            ${not empty log.fullName ? log.fullName.substring(0,1).toUpperCase() : log.username.substring(0,1).toUpperCase()}
                                        </div>
                                        <span class="fw-semibold">
                                            ${not empty log.fullName ? log.fullName : log.username}
                                        </span>
                                        <span class="text-muted small">@${log.username}</span>
                                        <span class="badge badge-${log.activityType} rounded-pill px-2 py-1 small">
                                            ${log.label}
                                        </span>
                                    </div>
                                    <div class="tl-meta text-end">
                                        <c:if test="${not empty log.formattedTime}">
                                            <i class="bi bi-clock me-1"></i>${log.formattedTime}
                                        </c:if>
                                        <c:if test="${not empty log.relatedId}">
                                            <span class="ms-2 text-muted">#${log.relatedId}</span>
                                        </c:if>
                                    </div>
                                </div>
                                <div class="mt-1 text-muted small">${log.description}</div>
                            </div>
                        </div>

                    </c:forEach>
                </div>

            </c:otherwise>
        </c:choose>

        <%-- Pagination --%>
        <c:if test="${totalPages > 1}">
            <div class="d-flex justify-content-between align-items-center mt-4 flex-wrap gap-2">
                <div class="text-muted small">
                    Showing <strong>${(currentPage - 1) * pageSize + 1}</strong>–<strong>${(currentPage - 1) * pageSize + logs.size()}</strong>
                    of <strong>${totalItems}</strong> events
                </div>
                <nav>
                    <ul class="pagination pagination-sm mb-0">

                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/activity-log?page=${currentPage - 1}&search=${search}&type=${typeFilter}&dateFrom=${dateFrom}&dateTo=${dateTo}&userId=${filterUserId}">
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
                                        <a class="page-link"
                                           href="${pageContext.request.contextPath}/activity-log?page=${p}&search=${search}&type=${typeFilter}&dateFrom=${dateFrom}&dateTo=${dateTo}&userId=${filterUserId}">${p}</a>
                                    </li>
                                </c:when>
                                <c:when test="${(p == currentPage - 3 && currentPage > 4) || (p == currentPage + 3 && currentPage < totalPages - 3)}">
                                    <li class="page-item disabled"><span class="page-link">…</span></li>
                                </c:when>
                            </c:choose>
                        </c:forEach>

                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/activity-log?page=${currentPage + 1}&search=${search}&type=${typeFilter}&dateFrom=${dateFrom}&dateTo=${dateTo}&userId=${filterUserId}">
                                <i class="bi bi-chevron-right"></i>
                            </a>
                        </li>

                    </ul>
                </nav>
            </div>
        </c:if>

    </div>

    <%@ include file="../../footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</main>
</div>
</div>
</body>
</html>
