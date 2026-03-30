<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Co-tenants - AKDD House</title>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body { background-color:#f4f6f9; }
        .page-header { background:linear-gradient(135deg,#1a1a2e,#16213e,#0f3460); color:white; border-radius:12px; padding:18px 24px; margin-bottom:24px; }
        .card-sec { border-radius:14px; border:none; }
        .tenant-row { border:1px solid #e9ecef; border-radius:10px; transition:.15s; }
        .tenant-row:hover { border-color:#0f3460; background:#f8f9ff; }
        .form-control:focus,.form-select:focus { border-color:#0f3460; box-shadow:0 0 0 .2rem rgba(15,52,96,.2); }
    </style>
</head>
<body>
<%@ include file="../../navbar.jsp" %>

<div class="container-fluid">
<div class="row flex-nowrap admin-layout-row">
<%@ include file="../sidebar.jsp" %>
<main class="col admin-main px-4 py-4"><div style="max-width:780px">

    <c:if test="${not empty sessionScope.contractSuccess}">
        <div class="alert alert-success alert-dismissible fade show"><i class="bi bi-check-circle-fill me-2"></i>${sessionScope.contractSuccess}<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        <% session.removeAttribute("contractSuccess"); %>
    </c:if>
    <c:if test="${not empty sessionScope.contractError}">
        <div class="alert alert-warning alert-dismissible fade show"><i class="bi bi-exclamation-triangle-fill me-2"></i>${sessionScope.contractError}<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        <% session.removeAttribute("contractError"); %>
    </c:if>

    <div class="page-header d-flex align-items-center gap-3">
        <div class="rounded-circle bg-white bg-opacity-25 d-flex align-items-center justify-content-center" style="width:52px;height:52px;font-size:22px;flex-shrink:0">
            <i class="bi bi-people-fill"></i>
        </div>
        <div>
            <h4 class="mb-0 fw-bold">Manage Co-tenants</h4>
            <small class="opacity-75">Contract #${contract.contractId} &middot; Room ${contract.roomNumber}</small>
        </div>
        <a href="${pageContext.request.contextPath}/contract?action=detail&id=${contract.contractId}" class="btn btn-light btn-sm ms-auto">
            <i class="bi bi-arrow-left me-1"></i>Back to Detail
        </a>
    </div>

    <%-- Current tenants --%>
    <div class="card card-sec shadow-sm mb-4">
        <div class="card-body p-4">
            <h6 class="fw-bold mb-3"><i class="bi bi-people me-2"></i>Current Tenants (${tenants.size()})</h6>
            <c:choose>
                <c:when test="${empty tenants}">
                    <div class="text-center py-4 text-muted"><i class="bi bi-person-x fs-3 d-block mb-2"></i>No tenants assigned</div>
                </c:when>
                <c:otherwise>
                    <div class="d-flex flex-column gap-2">
                        <c:forEach var="t" items="${tenants}">
                            <div class="tenant-row d-flex align-items-center p-3 gap-3">
                                <div class="rounded-circle bg-primary-subtle text-primary d-flex align-items-center justify-content-center fw-bold"
                                     style="width:42px;height:42px;flex-shrink:0;font-size:16px">
                                    ${not empty t.fullName ? t.fullName.substring(0,1).toUpperCase() : '?'}
                                </div>
                                <div class="flex-grow-1">
                                    <div class="fw-semibold">${not empty t.fullName ? t.fullName : t.username}</div>
                                    <div class="text-muted small">@${t.username}
                                        <c:if test="${not empty t.email}"> &middot; ${t.email}</c:if>
                                    </div>
                                </div>
                                <div class="text-center" style="min-width:100px">
                                    <div><span class="badge ${t.role=='owner'?'bg-primary':'bg-secondary'} rounded-pill">${t.role}</span></div>
                                    <div class="text-muted small mt-1">Since ${t.joinedAt}</div>
                                    <c:if test="${not empty t.leftAt}"><div class="text-muted small">Left ${t.leftAt}</div></c:if>
                                </div>
                                <c:if test="${t.role != 'owner' && empty t.leftAt}">
                                    <a href="${pageContext.request.contextPath}/contract?action=removeTenant&contractId=${contract.contractId}&userId=${t.userId}"
                                       class="btn btn-sm btn-outline-danger"
                                       onclick="return confirm('Remove this tenant from the contract?')">
                                        <i class="bi bi-person-dash"></i>
                                    </a>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <%-- Add co-tenant --%>
    <c:if test="${contract.status == 'active'}">
        <div class="card card-sec shadow-sm">
            <div class="card-body p-4">
                <h6 class="fw-bold mb-3"><i class="bi bi-person-plus me-2"></i>Add Co-tenant</h6>
                <form action="${pageContext.request.contextPath}/contract" method="post">
                    <input type="hidden" name="action"     value="addTenant">
                    <input type="hidden" name="contractId" value="${contract.contractId}">
                    <div class="row g-3">
                        <div class="col-md-5">
                            <label class="form-label fw-semibold small">Customer <span class="text-danger">*</span></label>
                            <select name="userId" class="form-select" required>
                                <option value="">— Select customer —</option>
                                <c:forEach var="cu" items="${customers}">
                                    <option value="${cu.userId}">${not empty cu.fullName ? cu.fullName : cu.username} (@${cu.username})</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-semibold small">Role</label>
                            <select name="role" class="form-select">
                                <option value="member">Member</option>
                                <option value="owner">Owner</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-semibold small">Joined Date</label>
                            <input type="date" name="joinedAt" class="form-control" id="joinedAtInput">
                        </div>
                        <div class="col-md-1 d-flex align-items-end">
                            <button type="submit" class="btn btn-dark w-100" title="Add"><i class="bi bi-plus-lg"></i></button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </c:if>
</div>
</div>
<script>
document.addEventListener('DOMContentLoaded', function() {
    var d = document.getElementById('joinedAtInput');
    if (d) d.value = new Date().toISOString().substring(0,10);
});
</script>
<%@ include file="../../footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</main>
</div>
</div>
</body>
</html>
