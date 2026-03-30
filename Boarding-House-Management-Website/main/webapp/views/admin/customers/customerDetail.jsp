<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Customer Detail - AKDD House</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; }
        .page-header {
            background: linear-gradient(135deg, #11998e, #38ef7d);
            color: white;
            border-radius: 12px;
            padding: 22px 28px;
            margin-bottom: 24px;
        }
        .avatar-lg {
            width: 72px; height: 72px; border-radius: 50%;
            background: rgba(255,255,255,0.25);
            display: flex; align-items: center; justify-content: center;
            font-size: 30px; font-weight: 700;
            border: 3px solid rgba(255,255,255,0.5);
            flex-shrink: 0;
        }
        .info-card { border-radius: 14px; border: none; }
        .section-label {
            font-size: 11px; font-weight: 700;
            text-transform: uppercase; letter-spacing: .6px;
            color: #6c757d;
        }
        .info-row { border-bottom: 1px solid #f0f0f0; padding: 10px 0; }
        .info-row:last-child { border-bottom: none; }
        .table thead th {
            background: #f8f9fa;
            font-size: 12px; font-weight: 700;
            text-transform: uppercase; letter-spacing: .4px;
            color: #6c757d; border: none;
        }
        .nav-pills .nav-link.active {
            background: linear-gradient(135deg, #11998e, #38ef7d);
            color: white !important;
        }
        .nav-pills .nav-link { color: #495057; }
    </style>
</head>
<body>
    <%@ include file="../../navbar.jsp" %>

<div class="container-fluid">
<div class="row flex-nowrap admin-layout-row">
<%@ include file="../sidebar.jsp" %>
<main class="col admin-main px-4 py-4">

        <%-- Header --%>
        <div class="page-header d-flex align-items-center gap-3 flex-wrap">
            <div class="avatar-lg">
                ${not empty customer.fullName ? customer.fullName.substring(0,1).toUpperCase() : customer.username.substring(0,1).toUpperCase()}
            </div>
            <div class="flex-grow-1">
                <h4 class="mb-1 fw-bold">
                    ${not empty customer.fullName ? customer.fullName : customer.username}
                    <c:if test="${customer.isDeleted}">
                        <span class="badge bg-secondary fs-6 ms-2">Hidden</span>
                    </c:if>
                </h4>
                <div class="opacity-75 small">
                    <i class="bi bi-at me-1"></i>${customer.username}
                    <span class="mx-2">&middot;</span>
                    <i class="bi bi-hash me-1"></i>ID ${customer.userId}
                </div>
            </div>
            <div class="d-flex gap-2 flex-wrap">
                <a href="${pageContext.request.contextPath}/manage-customer?action=edit&id=${customer.userId}"
                   class="btn btn-light fw-semibold btn-sm">
                    <i class="bi bi-pencil me-1"></i>Edit
                </a>
                <a href="${pageContext.request.contextPath}/manage-customer"
                   class="btn btn-light btn-sm">
                    <i class="bi bi-arrow-left me-1"></i>Back
                </a>
            </div>
        </div>

        <div class="row g-4">
            <%-- Left: personal info --%>
            <div class="col-lg-4">
                <div class="card info-card shadow-sm mb-4">
                    <div class="card-body p-4">
                        <div class="section-label mb-3"><i class="bi bi-person me-1"></i>Personal Information</div>

                        <div class="info-row d-flex justify-content-between">
                            <span class="text-muted small">Full Name</span>
                            <span class="fw-semibold">${not empty customer.fullName ? customer.fullName : '—'}</span>
                        </div>
                        <div class="info-row d-flex justify-content-between">
                            <span class="text-muted small">Username</span>
                            <span class="fw-semibold">@${customer.username}</span>
                        </div>
                        <div class="info-row d-flex justify-content-between">
                            <span class="text-muted small">Email</span>
                            <span class="small">${not empty customer.email ? customer.email : '—'}</span>
                        </div>
                        <div class="info-row d-flex justify-content-between">
                            <span class="text-muted small">Phone</span>
                            <span class="small">${not empty customer.phone ? customer.phone : '—'}</span>
                        </div>
                        <div class="info-row d-flex justify-content-between">
                            <span class="text-muted small">Status</span>
                            <c:choose>
                                <c:when test="${not customer.isDeleted}">
                                    <span class="badge bg-success-subtle text-success border border-success-subtle rounded-pill">Active</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle rounded-pill">Hidden</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <%-- Quick stats --%>
                <div class="card info-card shadow-sm">
                    <div class="card-body p-4">
                        <div class="section-label mb-3"><i class="bi bi-bar-chart me-1"></i>Overview</div>
                        <div class="row g-3 text-center">
                            <div class="col-6">
                                <div class="fw-bold fs-4 text-success">${contracts.size()}</div>
                                <div class="text-muted small">Contracts</div>
                            </div>
                            <div class="col-6">
                                <div class="fw-bold fs-4 text-primary">${bills.size()}</div>
                                <div class="text-muted small">Bills</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Right: activity logs --%>
            <div class="col-lg-8">
                <ul class="nav nav-pills mb-3" id="activityTabs">
                    <li class="nav-item">
                        <button class="nav-link active" data-bs-toggle="pill" data-bs-target="#tab-contracts">
                            <i class="bi bi-file-earmark-text me-1"></i>Contracts
                            <span class="badge bg-white text-dark ms-1">${contracts.size()}</span>
                        </button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" data-bs-toggle="pill" data-bs-target="#tab-bills">
                            <i class="bi bi-receipt me-1"></i>Bills
                            <span class="badge bg-white text-dark ms-1">${bills.size()}</span>
                        </button>
                    </li>
                </ul>

                <div class="tab-content">
                    <%-- Contracts tab --%>
                    <div class="tab-pane fade show active" id="tab-contracts">
                        <div class="card info-card shadow-sm">
                            <div class="card-body p-0">
                                <c:choose>
                                    <c:when test="${empty contracts}">
                                        <div class="text-center py-5 text-muted">
                                            <i class="bi bi-file-earmark-x fs-3 d-block mb-2"></i>
                                            No contracts found
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="table-responsive">
                                            <table class="table table-hover align-middle mb-0">
                                                <thead>
                                                    <tr>
                                                        <th class="ps-4">ID</th>
                                                        <th>Room</th>
                                                        <th>Start Date</th>
                                                        <th>End Date</th>
                                                        <th>Deposit</th>
                                                        <th class="text-center pe-4">Status</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="ct" items="${contracts}">
                                                        <tr>
                                                            <td class="ps-4 text-muted small">#${ct.contractId}</td>
                                                            <td class="fw-semibold">Room ${ct.roomId}</td>
                                                            <td class="text-muted small">${ct.startDate}</td>
                                                            <td class="text-muted small">${not empty ct.endDate ? ct.endDate : '—'}</td>
                                                            <td>
                                                                <span class="fw-semibold">
                                                                    <fmt:formatNumber value="${ct.deposit}" type="number" groupingUsed="true"/>đ
                                                                </span>
                                                            </td>
                                                            <td class="text-center pe-4">
                                                                <c:choose>
                                                                    <c:when test="${ct.status == 'active'}">
                                                                        <span class="badge bg-success-subtle text-success border border-success-subtle rounded-pill">Active</span>
                                                                    </c:when>
                                                                    <c:when test="${ct.status == 'terminated'}">
                                                                        <span class="badge bg-danger-subtle text-danger border border-danger-subtle rounded-pill">Terminated</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle rounded-pill">${ct.status}</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <%-- Bills tab --%>
                    <div class="tab-pane fade" id="tab-bills">
                        <div class="card info-card shadow-sm">
                            <div class="card-body p-0">
                                <c:choose>
                                    <c:when test="${empty bills}">
                                        <div class="text-center py-5 text-muted">
                                            <i class="bi bi-receipt fs-3 d-block mb-2"></i>
                                            No bills found
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="table-responsive">
                                            <table class="table table-hover align-middle mb-0">
                                                <thead>
                                                    <tr>
                                                        <th class="ps-4">ID</th>
                                                        <th>Period</th>
                                                        <th>Due Date</th>
                                                        <th>Total Amount</th>
                                                        <th class="text-center pe-4">Status</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="b" items="${bills}">
                                                        <tr>
                                                            <td class="ps-4 text-muted small">#${b.billId}</td>
                                                            <td>${b.period}</td>
                                                            <td class="text-muted small">${b.dueDate}</td>
                                                            <td class="fw-semibold text-success">
                                                                <fmt:formatNumber value="${b.totalAmount}" type="number" groupingUsed="true"/>đ
                                                            </td>
                                                            <td class="text-center pe-4">
                                                                <c:choose>
                                                                    <c:when test="${b.status == 'paid'}">
                                                                        <span class="badge bg-success-subtle text-success border border-success-subtle rounded-pill">
                                                                            <i class="bi bi-check-circle me-1"></i>Paid
                                                                        </span>
                                                                    </c:when>
                                                                    <c:when test="${b.status == 'pending'}">
                                                                        <span class="badge bg-warning-subtle text-warning border border-warning-subtle rounded-pill">
                                                                            <i class="bi bi-clock me-1"></i>Unpaid
                                                                        </span>
                                                                    </c:when>
                                                                    <c:when test="${b.status == 'overdue'}">
                                                                        <span class="badge bg-danger-subtle text-danger border border-danger-subtle rounded-pill">
                                                                            <i class="bi bi-exclamation-circle me-1"></i>Overdue
                                                                        </span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle rounded-pill">${b.status}</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <%@ include file="../../footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</main>
</div>
</div>
</body>
</html>
