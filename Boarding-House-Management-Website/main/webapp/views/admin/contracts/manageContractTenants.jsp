<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Occupants - Contract #${contract.contractId}</title>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body { background:#f4f6f9; }
        .page-header { background:linear-gradient(135deg,#1a1a2e,#0f3460); color:#fff; border-radius:12px; padding:18px 24px; margin-bottom:24px; }
        .form-card  { border-radius:14px; border:none; }
        .section-title { font-size:12px; font-weight:700; text-transform:uppercase; letter-spacing:.5px; color:#6c757d; margin-bottom:12px; }
        .tenant-row { border-radius:10px; border:1px solid #e9ecef; padding:12px 16px; background:#fff; }
        .form-control:focus,.form-select:focus { border-color:#0f3460; box-shadow:0 0 0 .2rem rgba(15,52,96,.2); }
        .btn-primary-dark { background:linear-gradient(135deg,#1a1a2e,#0f3460); border:none; color:#fff; }
        .btn-primary-dark:hover { opacity:.9; color:#fff; }
    </style>
</head>
<body>
<%@ include file="../../navbar.jsp" %>

<div class="container-fluid">
<div class="row flex-nowrap admin-layout-row">
<%@ include file="../sidebar.jsp" %>
<main class="col admin-main px-4 py-4"><div style="max-width:860px">

    <%-- Flash messages --%>
    <c:if test="${not empty sessionScope.contractSuccess}">
        <div class="alert alert-success alert-dismissible fade show">
            <i class="bi bi-check-circle-fill me-2"></i>${sessionScope.contractSuccess}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% session.removeAttribute("contractSuccess"); %>
    </c:if>
    <c:if test="${not empty sessionScope.contractError}">
        <div class="alert alert-danger alert-dismissible fade show">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>${sessionScope.contractError}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% session.removeAttribute("contractError"); %>
    </c:if>

    <%-- Header --%>
    <div class="page-header d-flex align-items-center gap-3 flex-wrap">
        <div class="rounded-circle bg-white bg-opacity-25 d-flex align-items-center justify-content-center" style="width:50px;height:50px;font-size:20px;flex-shrink:0">
            <i class="bi bi-people-fill"></i>
        </div>
        <div class="flex-grow-1">
            <h5 class="mb-0 fw-bold">Manage Occupants &mdash; Contract #${contract.contractId}</h5>
            <small class="opacity-75">Room ${contract.roomNumber}
                <c:if test="${not empty contract.categoryName}">&middot; ${contract.categoryName}</c:if>
            </small>
        </div>
        <a href="${pageContext.request.contextPath}/contract?action=detail&id=${contract.contractId}"
           class="btn btn-light btn-sm"><i class="bi bi-arrow-left me-1"></i>Back to Contract</a>
    </div>

    <div class="row g-4">

        <%-- Left: current tenant list --%>
        <div class="col-lg-6">
            <div class="card form-card shadow-sm">
                <div class="card-body p-4">
                    <div class="section-title"><i class="bi bi-people me-1"></i>Occupant List
                        <span class="badge bg-primary-subtle text-primary border border-primary-subtle ms-1">${contractTenants.size()}</span>
                    </div>

                    <c:choose>
                        <c:when test="${empty contractTenants}">
                            <div class="text-center py-4 text-muted">
                                <i class="bi bi-people fs-3 d-block mb-2"></i>No occupants yet
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="d-flex flex-column gap-2">
                                <c:forEach var="t" items="${contractTenants}">
                                    <div class="tenant-row d-flex align-items-center gap-2">
                                        <div class="rounded-circle d-flex align-items-center justify-content-center fw-bold flex-shrink-0
                                                    ${t.primary ? 'bg-primary text-white' : 'bg-secondary-subtle text-secondary'}"
                                             style="width:36px;height:36px;font-size:13px">
                                            ${t.fullName.substring(0,1).toUpperCase()}
                                        </div>
                                        <div class="flex-grow-1">
                                            <div class="fw-semibold small">${t.fullName}
                                                <c:if test="${t.primary}">
                                                    <span class="badge bg-primary rounded-pill ms-1" style="font-size:10px">Primary</span>
                                                </c:if>
                                            </div>
                                            <div class="text-muted" style="font-size:11px">
                                                <c:if test="${not empty t.phone}"><i class="bi bi-telephone me-1"></i>${t.phone} &nbsp;</c:if>
                                                <c:if test="${not empty t.cccd}"><i class="bi bi-card-text me-1"></i>${t.cccd}</c:if>
                                            </div>
                                        </div>
                                        <div class="d-flex gap-1">
                                            <a href="${pageContext.request.contextPath}/contract?action=editContractTenant&tenantId=${t.tenantId}"
                                               class="btn btn-sm btn-outline-secondary py-0 px-2" title="Edit">
                                                <i class="bi bi-pencil"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/contract?action=removeContractTenant&tenantId=${t.tenantId}&contractId=${contract.contractId}"
                                               class="btn btn-sm btn-outline-danger py-0 px-2"
                                               onclick="return confirm('Remove ${t.fullName}?')" title="Remove">
                                                <i class="bi bi-trash"></i>
                                            </a>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <%-- Right: add / edit form --%>
        <div class="col-lg-6">
            <div class="card form-card shadow-sm">
                <div class="card-body p-4">
                    <div class="section-title">
                        <i class="bi bi-person-plus me-1"></i>
                        ${not empty editTenant ? 'Edit Occupant' : 'Add Occupant'}
                    </div>

                    <form action="${pageContext.request.contextPath}/contract" method="post">
                        <input type="hidden" name="action"     value="saveContractTenant">
                        <input type="hidden" name="contractId" value="${contract.contractId}">
                        <c:if test="${not empty editTenant}">
                            <input type="hidden" name="tenantId" value="${editTenant.tenantId}">
                        </c:if>

                        <div class="mb-3">
                            <label class="form-label fw-semibold small">Full Name <span class="text-danger">*</span></label>
                            <input type="text" name="fullName" class="form-control form-control-sm"
                                   value="${not empty editTenant ? editTenant.fullName : ''}" required>
                        </div>
                        <div class="row g-2 mb-3">
                            <div class="col-6">
                                <label class="form-label fw-semibold small">Phone</label>
                                <input type="text" name="phone" class="form-control form-control-sm"
                                       value="${not empty editTenant ? editTenant.phone : ''}">
                            </div>
                            <div class="col-6">
                                <label class="form-label fw-semibold small">CCCD / ID</label>
                                <input type="text" name="cccd" class="form-control form-control-sm"
                                       value="${not empty editTenant ? editTenant.cccd : ''}">
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold small">Date of Birth</label>
                            <input type="date" name="birthDate" class="form-control form-control-sm"
                                   value="${not empty editTenant ? editTenant.birthDate : ''}">
                        </div>
                        <div class="mb-4">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="isPrimary" value="1" id="isPrimaryCheck"
                                       ${(not empty editTenant and editTenant.primary) ? 'checked' : ''}>
                                <label class="form-check-label small fw-semibold" for="isPrimaryCheck">
                                    Primary renter (main contract holder)
                                </label>
                            </div>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary-dark btn-sm flex-fill fw-semibold">
                                <i class="bi bi-floppy me-1"></i>
                                ${not empty editTenant ? 'Update' : 'Add Occupant'}
                            </button>
                            <c:if test="${not empty editTenant}">
                                <a href="${pageContext.request.contextPath}/contract?action=addContractTenant&id=${contract.contractId}"
                                   class="btn btn-outline-secondary btn-sm flex-fill">Cancel</a>
                            </c:if>
                        </div>
                    </form>
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
