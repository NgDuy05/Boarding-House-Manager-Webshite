<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Bill Detail - AKDD House</title>
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
    <a href="${pageContext.request.contextPath}/bill?action=mybill" class="btn btn-sm btn-outline-secondary mb-3">
        <i class="bi bi-arrow-left me-1"></i>Back to Bills
    </a>

    <c:if test="${empty bill}">
        <div class="alert alert-danger">Bill not found.</div>
    </c:if>

    <c:if test="${not empty bill}">
        <div class="card shadow-sm border-0 mb-3">
            <div class="card-header bg-white fw-bold">
                <i class="bi bi-receipt me-2"></i>Bill #${bill.billId}
                <c:choose>
                    <c:when test="${bill.status == 'paid'}">
                        <span class="badge bg-success float-end">Paid</span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge bg-danger float-end">Unpaid</span>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="card-body">
                <div class="row g-2">
                    <div class="col-6">
                        <div class="text-muted small">Period</div>
                        <div class="fw-semibold">${bill.period}</div>
                    </div>
                    <div class="col-6">
                        <div class="text-muted small">Due Date</div>
                        <div class="fw-semibold">${bill.dueDate}</div>
                    </div>
                    <div class="col-6">
                        <div class="text-muted small">Contract</div>
                        <div class="fw-semibold">#${bill.contractId}</div>
                    </div>
                    <div class="col-6">
                        <div class="text-muted small">Total Amount</div>
                        <div class="fw-bold text-primary">
                            <c:if test="${not empty bill.totalAmount}">
                                <fmt:formatNumber value="${bill.totalAmount}" groupingUsed="true" maxFractionDigits="0"/>&#8363;
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </c:if>
    </main>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
