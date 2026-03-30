<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Service Detail - AKDD House</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
</head>
<body class="bg-light" style="overflow-x:hidden;">
<%@ include file="../navbar.jsp" %>

<div class="container-fluid p-0">
  <div class="row g-0" style="min-height: calc(100vh - 56px);">
    <%@ include file="sidebar.jsp" %>
    <main class="col p-4">
<div style="max-width:680px;">
    <div class="d-flex align-items-center gap-2 mb-4">
        <a href="${pageContext.request.contextPath}/services"
           class="btn btn-sm btn-outline-secondary"><i class="bi bi-arrow-left"></i></a>
        <h4 class="mb-0"><i class="bi bi-grid me-2"></i>Service Detail</h4>
    </div>

    <c:if test="${empty service}">
        <div class="alert alert-warning">Service not found.</div>
    </c:if>

    <c:if test="${not empty service}">
        <div class="card shadow-sm border-0 mb-3">
            <div class="card-header bg-white fw-semibold">
                <i class="bi bi-grid me-2"></i>${service.serviceName}
            </div>
            <div class="card-body">
                <c:if test="${not empty service.image}">
                    <img src="${pageContext.request.contextPath}/${service.image}"
                         class="img-fluid rounded mb-3" style="max-height:200px; object-fit:cover;"
                         alt="${service.serviceName}">
                </c:if>
                <div class="row g-3">
                    <div class="col-sm-6">
                        <div class="text-muted small">Price</div>
                        <div class="fw-bold text-primary">
                            <c:if test="${not empty service.price}">
                                <fmt:formatNumber value="${service.price}" groupingUsed="true" maxFractionDigits="0"/>&#8363;
                            </c:if>
                        </div>
                    </div>
                    <div class="col-12">
                        <div class="text-muted small">Description</div>
                        <div>${not empty service.description ? service.description : '—'}</div>
                    </div>
                </div>
            </div>
        </div>

        <c:if test="${sessionScope.user.role == 'customer'}">
            <a href="${pageContext.request.contextPath}/services?action=request&serviceId=${service.serviceId}"
               class="btn btn-primary btn-sm">
                <i class="bi bi-plus-circle me-1"></i>Request This Service
            </a>
        </c:if>
    </c:if>
</div>
    </main>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
