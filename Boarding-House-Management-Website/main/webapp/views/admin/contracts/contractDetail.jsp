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
        .page-header { background:linear-gradient(135deg,#1a1a2e,#16213e,#0f3460); color:white; border-radius:12px; padding:22px 28px; margin-bottom:24px; }
        .info-card { border-radius:14px; border:none; }
        .info-row { border-bottom:1px solid #f0f0f0; padding:10px 0; }
        .info-row:last-child { border-bottom:none; }
        .section-label { font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:.6px; color:#6c757d; }
        .table thead th { background:#f8f9fa; font-size:12px; font-weight:700; text-transform:uppercase; letter-spacing:.4px; color:#6c757d; border:none; }
        .nav-pills .nav-link.active { background:linear-gradient(135deg,#1a1a2e,#0f3460); color:white !important; }
        .nav-pills .nav-link { color:#495057; }
        .tenant-card { border-radius:10px; border:1px solid #e9ecef; }
    </style>
</head>
<body>
<%@ include file="../../navbar.jsp" %>

<div class="container-fluid">
<div class="row flex-nowrap admin-layout-row">
<%@ include file="../sidebar.jsp" %>
<main class="col admin-main px-4 py-4">

    <c:if test="${not empty sessionScope.contractSuccess}">
        <div class="alert alert-success alert-dismissible fade show"><i class="bi bi-check-circle-fill me-2"></i>${sessionScope.contractSuccess}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        <% session.removeAttribute("contractSuccess"); %>
    </c:if>
    <c:if test="${not empty sessionScope.contractError}">
        <div class="alert alert-danger alert-dismissible fade show"><i class="bi bi-exclamation-triangle-fill me-2"></i>${sessionScope.contractError}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        <% session.removeAttribute("contractError"); %>
    </c:if>

    <%-- Header --%>
    <div class="page-header d-flex align-items-center gap-3 flex-wrap">
        <div class="rounded-circle bg-white bg-opacity-25 d-flex align-items-center justify-content-center" style="width:60px;height:60px;font-size:24px;flex-shrink:0">
            <i class="bi bi-file-earmark-text-fill"></i>
        </div>
        <div class="flex-grow-1">
            <h4 class="mb-1 fw-bold">Contract #${contract.contractId}</h4>
            <div class="opacity-75 small">
                Room ${contract.roomNumber}
                <c:if test="${not empty contract.categoryName}">&middot; ${contract.categoryName}</c:if>
                &middot; Created ${contract.createdAt}
            </div>
        </div>
        <div class="d-flex gap-2 flex-wrap align-items-center">
            <span class="badge bg-${contract.statusColor}-subtle text-${contract.statusColor} border border-${contract.statusColor}-subtle rounded-pill fs-6 px-3 py-2">
                ${contract.statusLabel}
            </span>
            <a href="${pageContext.request.contextPath}/contract?action=edit&id=${contract.contractId}" class="btn btn-light btn-sm fw-semibold">
                <i class="bi bi-pencil me-1"></i>Edit
            </a>
            <c:if test="${contract.status == 'active'}">
                <button class="btn btn-danger btn-sm fw-semibold"
                    onclick="confirmTerminate(${contract.contractId}, ${contract.roomId}, '${contract.roomNumber}')">
                    <i class="bi bi-x-circle me-1"></i>Terminate
                </button>
            </c:if>
            <a href="${pageContext.request.contextPath}/contract?action=list" class="btn btn-light btn-sm">
                <i class="bi bi-arrow-left me-1"></i>Back
            </a>
        </div>
    </div>

    <div class="row g-4">
        <%-- Left: contract info --%>
        <div class="col-lg-4">
            <div class="card info-card shadow-sm mb-4">
                <div class="card-body p-4">
                    <div class="section-label mb-3"><i class="bi bi-file-text me-1"></i>Contract Details</div>
                    <div class="info-row d-flex justify-content-between"><span class="text-muted small">Contract ID</span><span class="fw-semibold">#${contract.contractId}</span></div>
                    <div class="info-row d-flex justify-content-between"><span class="text-muted small">Room</span><span class="fw-semibold">Room ${contract.roomNumber}</span></div>
                    <div class="info-row d-flex justify-content-between"><span class="text-muted small">Category</span><span class="small">${not empty contract.categoryName ? contract.categoryName : '—'}</span></div>
                    <div class="info-row d-flex justify-content-between"><span class="text-muted small">Base Price</span><span class="small">${not empty contract.basePrice ? contract.basePrice : '—'}đ</span></div>
                    <div class="info-row d-flex justify-content-between"><span class="text-muted small">Deposit</span><span class="fw-semibold text-primary">${contract.deposit}đ</span></div>
                    <div class="info-row d-flex justify-content-between"><span class="text-muted small">Start Date</span><span class="small">${contract.startDate}</span></div>
                    <div class="info-row d-flex justify-content-between"><span class="text-muted small">End Date</span><span class="small">${not empty contract.endDate ? contract.endDate : '—'}</span></div>
                    <div class="info-row d-flex justify-content-between"><span class="text-muted small">Created</span><span class="small">${not empty contract.createdAt ? contract.createdAt : '—'}</span></div>
                </div>
            </div>
            <div class="card info-card shadow-sm">
                <div class="card-body p-4">
                    <div class="section-label mb-3"><i class="bi bi-bar-chart me-1"></i>Summary</div>
                    <div class="row g-3 text-center">
                        <div class="col-4"><div class="fw-bold fs-5 text-primary">${tenants.size()}</div><div class="text-muted small">Accounts</div></div>
                        <div class="col-4"><div class="fw-bold fs-5 text-info">${contractTenants.size()}</div><div class="text-muted small">Tenants</div></div>
                        <div class="col-4"><div class="fw-bold fs-5 text-success">${bills.size()}</div><div class="text-muted small">Bills</div></div>
                    </div>
                </div>
            </div>
        </div>

        <%-- Right: tabs --%>
        <div class="col-lg-8">
            <ul class="nav nav-pills mb-3">
                <li class="nav-item">
                    <button class="nav-link active" data-bs-toggle="pill" data-bs-target="#tab-tenants">
                        <i class="bi bi-people me-1"></i>System Accounts
                        <span class="badge bg-white text-dark ms-1">${tenants.size()}</span>
                    </button>
                </li>
                <li class="nav-item">
                    <button class="nav-link" data-bs-toggle="pill" data-bs-target="#tab-contract-tenants">
                        <i class="bi bi-person-vcard me-1"></i>Occupants
                        <span class="badge bg-white text-dark ms-1">${contractTenants.size()}</span>
                    </button>
                </li>
                <li class="nav-item">
                    <button class="nav-link" data-bs-toggle="pill" data-bs-target="#tab-bills">
                        <i class="bi bi-receipt me-1"></i>Bills
                        <span class="badge bg-white text-dark ms-1">${bills.size()}</span>
                    </button>
                </li>
                <li class="nav-item">
                    <button class="nav-link" data-bs-toggle="pill" data-bs-target="#tab-resident-history">
                        <i class="bi bi-clock-history me-1"></i>Resident History
                        <span class="badge bg-white text-dark ms-1">${contractTenants.size()}</span>
                    </button>
                </li>
            </ul>

            <div class="tab-content">
                <%-- Tenants tab --%>
                <div class="tab-pane fade show active" id="tab-tenants">
                    <div class="d-flex justify-content-end mb-2">
                        <a href="${pageContext.request.contextPath}/contract?action=addTenant&id=${contract.contractId}"
                           class="btn btn-sm btn-outline-primary">
                            <i class="bi bi-person-plus me-1"></i>Manage Accounts
                        </a>
                    </div>
                    <c:choose>
                        <c:when test="${empty tenants}">
                            <div class="card info-card shadow-sm"><div class="text-center py-5 text-muted"><i class="bi bi-people fs-3 d-block mb-2"></i>No tenants assigned</div></div>
                        </c:when>
                        <c:otherwise>
                            <div class="row g-2">
                                <c:forEach var="t" items="${tenants}">
                                    <div class="col-md-6">
                                        <div class="card tenant-card p-3">
                                            <div class="d-flex align-items-center gap-2">
                                                <div class="rounded-circle bg-primary-subtle text-primary d-flex align-items-center justify-content-center fw-bold"
                                                     style="width:38px;height:38px;flex-shrink:0;font-size:14px">
                                                    ${not empty t.fullName ? t.fullName.substring(0,1).toUpperCase() : t.username.substring(0,1).toUpperCase()}
                                                </div>
                                                <div class="flex-grow-1 min-width-0">
                                                    <div class="fw-semibold">${not empty t.fullName ? t.fullName : t.username}</div>
                                                    <div class="text-muted small">@${t.username}</div>
                                                </div>
                                                            <span class="badge ${t.role == 'owner' ? 'bg-primary' : 'bg-secondary'} rounded-pill">${t.role}</span>
                                            </div>
                                            <div class="mt-2 text-muted small d-flex gap-2">
                                                <span><i class="bi bi-calendar-check me-1"></i>${t.joinedAt}</span>
                                                <c:if test="${not empty t.leftAt}"><span><i class="bi bi-calendar-x me-1"></i>${t.leftAt}</span></c:if>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <%-- Tenant Info tab (contract_tenant — no system account required) --%>
                <div class="tab-pane fade" id="tab-contract-tenants">
                    <div class="d-flex justify-content-end mb-2">
                        <a href="${pageContext.request.contextPath}/contract?action=addContractTenant&id=${contract.contractId}"
                           class="btn btn-sm btn-outline-primary">
                            <i class="bi bi-person-plus me-1"></i>Manage Occupants
                        </a>
                    </div>
                    <c:choose>
                        <c:when test="${empty contractTenants}">
                            <div class="card info-card shadow-sm">
                                <div class="text-center py-5 text-muted">
                                    <i class="bi bi-person-vcard fs-3 d-block mb-2"></i>No tenant info recorded
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0 bg-white rounded-3 shadow-sm overflow-hidden">
                                    <thead>
                                        <tr>
                                            <th class="ps-4">Full Name</th>
                                            <th>Phone</th>
                                            <th>CCCD</th>
                                            <th>DOB</th>
                                            <th class="text-center">Role</th>
                                            <th class="text-center pe-3">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="t" items="${contractTenants}">
                                            <tr>
                                                <td class="ps-4 fw-semibold">${t.fullName}</td>
                                                <td class="text-muted small">${not empty t.phone ? t.phone : '—'}</td>
                                                <td class="text-muted small">${not empty t.cccd ? t.cccd : '—'}</td>
                                                <td class="text-muted small">${not empty t.birthDate ? t.birthDate : '—'}</td>
                                                <td class="text-center">
                                                    <span class="badge ${t.primary ? 'bg-primary' : 'bg-secondary'} rounded-pill">
                                                        ${t.primary ? 'Primary' : 'Co-tenant'}
                                                    </span>
                                                </td>
                                                <td class="text-center pe-3">
                                                    <a href="${pageContext.request.contextPath}/contract?action=editContractTenant&tenantId=${t.tenantId}"
                                                       class="btn btn-sm btn-outline-secondary py-0 px-2 me-1" title="Edit">
                                                        <i class="bi bi-pencil"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/contract?action=removeContractTenant&tenantId=${t.tenantId}&contractId=${contract.contractId}"
                                                       class="btn btn-sm btn-outline-danger py-0 px-2"
                                                       onclick="return confirm('Remove ${t.fullName}?')" title="Remove">
                                                        <i class="bi bi-trash"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <%-- Bills tab --%>
                <div class="tab-pane fade" id="tab-bills">                    <div class="card info-card shadow-sm">
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

                <%-- Resident history tab (contract_tenant of this contract) --%>
                <div class="tab-pane fade" id="tab-resident-history">
                    <c:choose>
                        <c:when test="${empty contractTenants}">
                            <div class="card info-card shadow-sm">
                                <div class="text-center py-5 text-muted">
                                    <i class="bi bi-clock-history fs-3 d-block mb-2"></i>No resident records
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0 bg-white rounded-3 shadow-sm overflow-hidden">
                                    <thead>
                                        <tr>
                                            <th class="ps-4">Full Name</th>
                                            <th>Phone</th>
                                            <th>CCCD</th>
                                            <th>DOB</th>
                                            <th class="text-center">Role</th>
                                            <th class="text-muted small pe-3">Added</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="t" items="${contractTenants}">
                                            <tr>
                                                <td class="ps-4 fw-semibold">${t.fullName}</td>
                                                <td class="text-muted small">${not empty t.phone ? t.phone : '—'}</td>
                                                <td class="text-muted small">${not empty t.cccd ? t.cccd : '—'}</td>
                                                <td class="text-muted small">${not empty t.birthDate ? t.birthDate : '—'}</td>
                                                <td class="text-center">
                                                    <span class="badge ${t.primary ? 'bg-primary' : 'bg-secondary'} rounded-pill">
                                                        ${t.primary ? 'Primary' : 'Co-tenant'}
                                                    </span>
                                                </td>
                                                <td class="text-muted small pe-3">${not empty t.createdAt ? t.createdAt : '—'}</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <div class="mt-2">
                        <a href="${pageContext.request.contextPath}/contract?action=addContractTenant&id=${contract.contractId}"
                           class="btn btn-sm btn-outline-primary">
                            <i class="bi bi-person-plus me-1"></i>Manage Occupants
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%-- Terminate modal --%>
<div class="modal fade" id="terminateModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <div class="modal-header border-0"><h5 class="modal-title fw-bold text-danger"><i class="bi bi-x-circle me-2"></i>Terminate Contract</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
            <div class="modal-body"><p class="text-muted mb-0">Terminate contract <strong id="termId"></strong> for <strong id="termRoom"></strong>? The room will be freed immediately.</p></div>
            <div class="modal-footer border-0">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                <a id="termBtn" href="#" class="btn btn-danger"><i class="bi bi-x-circle me-1"></i>Terminate</a>
            </div>
        </div>
    </div>
</div>

<script>
function confirmTerminate(id, roomId, roomNum) {
    document.getElementById('termId').textContent = '#' + id;
    document.getElementById('termRoom').textContent = 'Room ' + roomNum;
    document.getElementById('termBtn').href = '${pageContext.request.contextPath}/contract?action=terminate&id=' + id + '&roomId=' + roomId;
    new bootstrap.Modal(document.getElementById('terminateModal')).show();
}
</script>
<%@ include file="../../footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</main>
</div>
</div>
</body>
</html>
