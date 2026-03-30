<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Contract Detail - AKDD House</title>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body { background-color:#f4f6f9; }
        .page-header { background:linear-gradient(135deg,#0f3460,#16213e); color:white; border-radius:14px; padding:22px 28px; margin-bottom:24px; }
        .info-card { border-radius:14px; border:none; }
        .info-row { border-bottom:1px solid #f0f0f0; padding:10px 0; }
        .info-row:last-child { border-bottom:none; }
        .label-sm { font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:.5px; color:#6c757d; }
        .nav-pills .nav-link.active { background:linear-gradient(135deg,#0f3460,#1a1a2e); color:white!important; }
        .nav-pills .nav-link { color:#495057; }
        .table thead th { background:#f8f9fa; font-size:12px; font-weight:700; text-transform:uppercase; letter-spacing:.4px; color:#6c757d; border:none; }
    </style>
</head>
<body>
<%@ include file="../navbar.jsp" %>
<div class="container-fluid p-0">
  <div class="row g-0" style="min-height: calc(100vh - 56px);">
    <%@ include file="sidebar.jsp" %>
    <main class="col p-4">
<div style="max-width:900px">

    <div class="page-header d-flex align-items-center gap-3 flex-wrap">
        <div class="rounded-circle bg-white bg-opacity-25 d-flex align-items-center justify-content-center" style="width:58px;height:58px;font-size:24px;flex-shrink:0">
            <i class="bi bi-file-earmark-text"></i>
        </div>
        <div class="flex-grow-1">
            <h4 class="mb-1 fw-bold">Contract #${contract.contractId}</h4>
            <div class="opacity-75 small">Room ${contract.roomNumber}
                <c:if test="${not empty contract.categoryName}">&middot; ${contract.categoryName}</c:if>
            </div>
        </div>
        <span class="badge bg-${contract.statusColor}-subtle text-${contract.statusColor} border border-${contract.statusColor}-subtle rounded-pill fs-6 px-3 py-2">${contract.statusLabel}</span>
        <a href="${pageContext.request.contextPath}/contract?action=mycontract" class="btn btn-light btn-sm">
            <i class="bi bi-arrow-left me-1"></i>Back
        </a>
    </div>

    <div class="row g-4">
        <%-- Left: info --%>
        <div class="col-lg-4">
            <div class="card info-card shadow-sm mb-4">
                <div class="card-body p-4">
                    <div class="label-sm mb-3"><i class="bi bi-house me-1"></i>Room Info</div>
                    <div class="info-row d-flex justify-content-between"><span class="text-muted small">Room Number</span><span class="fw-semibold">Room ${contract.roomNumber}</span></div>
                    <div class="info-row d-flex justify-content-between"><span class="text-muted small">Category</span><span class="small">${not empty contract.categoryName ? contract.categoryName : '—'}</span></div>
                    <div class="info-row d-flex justify-content-between"><span class="text-muted small">Monthly Rent</span><span class="fw-semibold text-success">${not empty contract.basePrice ? contract.basePrice : '—'}đ</span></div>
                </div>
            </div>
            <div class="card info-card shadow-sm">
                <div class="card-body p-4">
                    <div class="label-sm mb-3"><i class="bi bi-file-text me-1"></i>Contract Terms</div>
                    <div class="info-row d-flex justify-content-between"><span class="text-muted small">Contract ID</span><span class="fw-semibold">#${contract.contractId}</span></div>
                    <div class="info-row d-flex justify-content-between"><span class="text-muted small">Deposit Paid</span><span class="fw-semibold text-primary">${contract.deposit}đ</span></div>
                    <div class="info-row d-flex justify-content-between"><span class="text-muted small">Start Date</span><span class="small">${contract.startDate}</span></div>
                    <div class="info-row d-flex justify-content-between"><span class="text-muted small">End Date</span><span class="small">${not empty contract.endDate ? contract.endDate : '—'}</span></div>
                    <div class="info-row d-flex justify-content-between"><span class="text-muted small">Status</span>
                        <span class="badge bg-${contract.statusColor}-subtle text-${contract.statusColor} border border-${contract.statusColor}-subtle rounded-pill small">${contract.statusLabel}</span>
                    </div>
                </div>
            </div>
        </div>

        <%-- Right: tabs --%>
        <div class="col-lg-8">
            <ul class="nav nav-pills mb-3">
                <li class="nav-item">
                    <button class="nav-link active" data-bs-toggle="pill" data-bs-target="#t-roommates">
                        <i class="bi bi-people me-1"></i>Roommates <span class="badge bg-white text-dark ms-1">${tenants.size()}</span>
                    </button>
                </li>
                <li class="nav-item">
                    <button class="nav-link" data-bs-toggle="pill" data-bs-target="#t-tenants">
                        <i class="bi bi-person-vcard me-1"></i>Tenants <span class="badge bg-white text-dark ms-1">${contractTenants.size()}</span>
                    </button>
                </li>
                <li class="nav-item">
                    <button class="nav-link" data-bs-toggle="pill" data-bs-target="#t-bills">
                        <i class="bi bi-receipt me-1"></i>Bills <span class="badge bg-white text-dark ms-1">${bills.size()}</span>
                    </button>
                </li>
            </ul>

            <div class="tab-content">
                <%-- Roommates --%>
                <div class="tab-pane fade show active" id="t-roommates">
                    <div class="card info-card shadow-sm">
                        <div class="card-body p-4">
                            <c:choose>
                                <c:when test="${empty tenants}">
                                    <div class="text-center py-4 text-muted"><i class="bi bi-people fs-3 d-block mb-2"></i>No roommates</div>
                                </c:when>
                                <c:otherwise>
                                    <div class="d-flex flex-column gap-3">
                                        <c:forEach var="t" items="${tenants}">
                                            <div class="d-flex align-items-center gap-3 p-3 bg-light rounded-3">
                                                <div class="rounded-circle bg-primary-subtle text-primary d-flex align-items-center justify-content-center fw-bold"
                                                     style="width:44px;height:44px;flex-shrink:0;font-size:16px">
                                                    ${not empty t.fullName ? t.fullName.substring(0,1).toUpperCase() : '?'}
                                                </div>
                                                <div class="flex-grow-1">
                                                    <div class="fw-semibold">${not empty t.fullName ? t.fullName : t.username}</div>
                                                    <div class="text-muted small">Joined ${t.joinedAt}
                                                        <c:if test="${not empty t.leftAt}"> &middot; Left ${t.leftAt}</c:if>
                                                    </div>
                                                </div>
                                                <span class="badge ${t.role=='owner'?'bg-primary':'bg-secondary'} rounded-pill">${t.role}</span>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <%-- Tenants (contract_tenant list — read-only for customer) --%>
                <div class="tab-pane fade" id="t-tenants">
                    <div class="card info-card shadow-sm">
                        <div class="card-body p-4">
                            <c:choose>
                                <c:when test="${empty contractTenants}">
                                    <div class="text-center py-4 text-muted">
                                        <i class="bi bi-person-vcard fs-3 d-block mb-2"></i>No tenant records
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="d-flex flex-column gap-3">
                                        <c:forEach var="t" items="${contractTenants}">
                                            <div class="d-flex align-items-center gap-3 p-3 bg-light rounded-3">
                                                <div class="rounded-circle d-flex align-items-center justify-content-center fw-bold flex-shrink-0
                                                            ${t.primary ? 'bg-primary text-white' : 'bg-secondary-subtle text-secondary'}"
                                                     style="width:44px;height:44px;flex-shrink:0;font-size:16px">
                                                    ${t.fullName.substring(0,1).toUpperCase()}
                                                </div>
                                                <div class="flex-grow-1">
                                                    <div class="fw-semibold">${t.fullName}</div>
                                                    <div class="text-muted small">
                                                        <c:if test="${not empty t.phone}"><i class="bi bi-telephone me-1"></i>${t.phone} &nbsp;</c:if>
                                                        <c:if test="${not empty t.birthDate}"><i class="bi bi-calendar me-1"></i>${t.birthDate}</c:if>
                                                    </div>
                                                </div>
                                                <span class="badge ${t.primary ? 'bg-primary' : 'bg-secondary'} rounded-pill">${t.roleLabel}</span>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <%-- Bills --%>
                <div class="tab-pane fade" id="t-bills">
                    <div class="card info-card shadow-sm">
                        <div class="card-body p-0">
                            <c:choose>
                                <c:when test="${empty bills}">
                                    <div class="text-center py-5 text-muted"><i class="bi bi-receipt fs-3 d-block mb-2"></i>No bills yet</div>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle mb-0">
                                            <thead><tr>
                                                <th class="ps-4">ID</th><th>Period</th><th>Due Date</th><th>Amount</th><th class="text-center pe-4">Status</th>
                                            </tr></thead>
                                            <tbody>
                                                <c:forEach var="b" items="${bills}">
                                                    <tr>
                                                        <td class="ps-4 text-muted small">#${b.billId}</td>
                                                        <td>${b.period}</td>
                                                        <td class="text-muted small">${b.dueDate}</td>
                                                        <td class="fw-semibold text-success">${b.totalAmount}đ</td>
                                                        <td class="text-center pe-4">
                                                            <c:choose>
                                                                <c:when test="${b.status=='paid'}"><span class="badge bg-success-subtle text-success border border-success-subtle rounded-pill"><i class="bi bi-check-circle me-1"></i>Paid</span></c:when>
                                                                <c:when test="${b.status=='pending'}"><span class="badge bg-warning-subtle text-warning border border-warning-subtle rounded-pill"><i class="bi bi-clock me-1"></i>Unpaid</span></c:when>
                                                                <c:when test="${b.status=='overdue'}"><span class="badge bg-danger-subtle text-danger border border-danger-subtle rounded-pill"><i class="bi bi-exclamation-circle me-1"></i>Overdue</span></c:when>
                                                                <c:otherwise><span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle rounded-pill">${b.status}</span></c:otherwise>
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
    </main>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
