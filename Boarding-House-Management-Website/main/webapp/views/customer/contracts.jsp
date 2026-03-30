<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>My Contracts - AKDD House</title>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body { background-color:#f4f6f9; }
        .page-header { background:linear-gradient(135deg,#0f3460,#16213e); color:white; border-radius:14px; padding:22px 28px; margin-bottom:24px; }
        .contract-card { border-radius:14px; border:none; transition:.2s; }
        .contract-card:hover { transform:translateY(-2px); box-shadow:0 6px 24px rgba(0,0,0,.1)!important; }
        .badge-status { border-radius:50px; padding:4px 14px; font-size:12px; font-weight:600; }
        .info-item { display:flex; flex-direction:column; }
        .info-item .label { font-size:11px; color:#6c757d; font-weight:600; text-transform:uppercase; letter-spacing:.4px; }
        .info-item .value { font-size:14px; font-weight:600; color:#212529; margin-top:2px; }
    </style>
</head>
<body>
<%@ include file="../navbar.jsp" %>
<div class="container-fluid p-0">
  <div class="row g-0" style="min-height: calc(100vh - 56px);">
    <%@ include file="sidebar.jsp" %>
    <main class="col p-4">
<div style="max-width:860px">

    <div class="page-header d-flex justify-content-between align-items-center flex-wrap gap-2">
        <div>
            <h4 class="fw-bold mb-1"><i class="bi bi-file-earmark-text-fill me-2"></i>My Contracts</h4>
            <small class="opacity-75">View and manage your rental agreements</small>
        </div>
        <a href="${pageContext.request.contextPath}/contract?action=signContract" class="btn btn-light fw-semibold">
            <i class="bi bi-pen me-1"></i>Sign a Contract
        </a>
    </div>

    <c:if test="${not empty sessionScope.contractSuccess}">
        <div class="alert alert-success alert-dismissible fade show"><i class="bi bi-check-circle-fill me-2"></i>${sessionScope.contractSuccess}<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        <% session.removeAttribute("contractSuccess"); %>
    </c:if>
    <c:if test="${not empty sessionScope.contractError}">
        <div class="alert alert-danger alert-dismissible fade show"><i class="bi bi-exclamation-triangle-fill me-2"></i>${sessionScope.contractError}<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        <% session.removeAttribute("contractError"); %>
    </c:if>

    <c:choose>
        <c:when test="${empty contracts}">
            <div class="card border-0 shadow-sm rounded-4">
                <div class="card-body text-center py-5">
                    <i class="bi bi-file-earmark-x text-muted" style="font-size:56px"></i>
                    <h5 class="mt-3 mb-1 fw-semibold">No contracts yet</h5>
                    <p class="text-muted">You don't have any rental contracts. Browse available rooms to get started.</p>
                    <a href="${pageContext.request.contextPath}/contract?action=signContract" class="btn btn-dark fw-semibold">
                        <i class="bi bi-pen me-1"></i>Sign a Contract
                    </a>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="d-flex flex-column gap-3">
                <c:forEach var="c" items="${contracts}">
                    <div class="card contract-card shadow-sm">
                        <div class="card-body p-4">
                            <div class="d-flex justify-content-between align-items-start flex-wrap gap-2 mb-3">
                                <div>
                                    <h5 class="fw-bold mb-1">
                                        <i class="bi bi-door-open me-2 text-primary"></i>
                                        Room ${not empty c.roomNumber ? c.roomNumber : c.roomId}
                                        <c:if test="${not empty c.categoryName}">
                                            <span class="text-muted fw-normal fs-6 ms-1">&middot; ${c.categoryName}</span>
                                        </c:if>
                                    </h5>
                                    <div class="text-muted small">Contract #${c.contractId}</div>
                                </div>
                                <span class="badge badge-status
                                    ${c.status=='active' ? 'bg-success-subtle text-success border border-success-subtle' :
                                      c.status=='terminated' ? 'bg-danger-subtle text-danger border border-danger-subtle' :
                                      'bg-secondary-subtle text-secondary border border-secondary-subtle'}">
                                    <c:choose>
                                        <c:when test="${c.status=='active'}"><i class="bi bi-check-circle me-1"></i></c:when>
                                        <c:when test="${c.status=='terminated'}"><i class="bi bi-x-circle me-1"></i></c:when>
                                        <c:otherwise><i class="bi bi-clock-history me-1"></i></c:otherwise>
                                    </c:choose>
                                    ${c.statusLabel}
                                </span>
                            </div>

                            <div class="row g-3 mb-3">
                                <div class="col-6 col-md-3">
                                    <div class="info-item">
                                        <span class="label">Start Date</span>
                                        <span class="value">${c.startDate}</span>
                                    </div>
                                </div>
                                <div class="col-6 col-md-3">
                                    <div class="info-item">
                                        <span class="label">End Date</span>
                                        <span class="value">${not empty c.endDate ? c.endDate : '—'}</span>
                                    </div>
                                </div>
                                <div class="col-6 col-md-3">
                                    <div class="info-item">
                                        <span class="label">Deposit</span>
                                        <span class="value text-primary">${c.deposit}đ</span>
                                    </div>
                                </div>
                                <div class="col-6 col-md-3">
                                    <div class="info-item">
                                        <span class="label">Monthly Rent</span>
                                        <span class="value text-success">${not empty c.basePrice ? c.basePrice : '—'}đ</span>
                                    </div>
                                </div>
                            </div>

                            <div class="d-flex justify-content-end">
                                <a href="${pageContext.request.contextPath}/contract?action=mydetail&id=${c.contractId}"
                                   class="btn btn-outline-primary btn-sm fw-semibold">
                                    <i class="bi bi-eye me-1"></i>View Details
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>
    </main>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
