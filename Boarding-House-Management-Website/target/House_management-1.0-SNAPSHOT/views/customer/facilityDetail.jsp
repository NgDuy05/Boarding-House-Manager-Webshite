<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Facility Detail - AKDD House</title>
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
        <a href="${pageContext.request.contextPath}/facility"
           class="btn btn-sm btn-outline-secondary"><i class="bi bi-arrow-left"></i></a>
        <h4 class="mb-0"><i class="bi bi-wrench me-2"></i>Facility Detail</h4>
    </div>

    <c:if test="${empty facility}">
        <div class="alert alert-warning">Facility not found.</div>
    </c:if>

    <c:if test="${not empty facility}">
        <div class="card shadow-sm border-0">
            <div class="card-header bg-white fw-semibold">
                <i class="bi bi-wrench me-2"></i>${facility.facilityName}
            </div>
            <div class="card-body">
                <c:if test="${not empty facility.image}">
                    <img src="${pageContext.request.contextPath}/${facility.image}"
                         class="img-fluid rounded mb-3" style="max-height:200px; object-fit:cover;"
                         alt="${facility.facilityName}">
                </c:if>
                <div class="row g-3">
                    <div class="col-sm-6">
                        <div class="text-muted small">Facility ID</div>
                        <div class="fw-semibold">${facility.facilityId}</div>
                    </div>
                    <div class="col-12">
                        <div class="text-muted small">Description</div>
                        <div>${not empty facility.description ? facility.description : '—'}</div>
                    </div>
                </div>
            </div>
        </div>
    </c:if>
</div>
    </main>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
