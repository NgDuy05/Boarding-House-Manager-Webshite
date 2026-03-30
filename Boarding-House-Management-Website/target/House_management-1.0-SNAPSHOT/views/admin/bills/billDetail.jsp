<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Bill Detail - AKDD House</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<%@ include file="../../navbar.jsp" %>

<div class="container-fluid">
<div class="row flex-nowrap admin-layout-row">
<%@ include file="../sidebar.jsp" %>
<main class="col admin-main px-4 py-4">

<div style="max-width:700px;">
    <div class="d-flex align-items-center gap-2 mb-3">
        <a href="${pageContext.request.contextPath}/bill?action=list"
           class="btn btn-sm btn-outline-secondary"><i class="bi bi-arrow-left"></i></a>
        <h4 class="mb-0"><i class="bi bi-receipt me-2"></i>Bill #${bill.billId}</h4>
    </div>

    <c:if test="${empty bill}">
        <div class="alert alert-danger">Bill not found.</div>
    </c:if>

    <c:if test="${not empty bill}">
        <%-- Summary card --%>
        <div class="card shadow-sm border-0 mb-3">
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-sm-6">
                        <div class="text-muted small">Contract</div>
                        <div class="fw-semibold">#${bill.contractId}</div>
                    </div>
                    <div class="col-sm-6">
                        <div class="text-muted small">Period</div>
                        <div class="fw-semibold">${bill.period}</div>
                    </div>
                    <div class="col-sm-6">
                        <div class="text-muted small">Due Date</div>
                        <div class="fw-semibold">${bill.dueDate}</div>
                    </div>
                    <div class="col-sm-6">
                        <div class="text-muted small">Status</div>
                        <c:choose>
                            <c:when test="${bill.status == 'paid'}">
                                <span class="badge bg-success">Paid</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-danger">Unpaid</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="col-sm-6">
                        <div class="text-muted small">Total Amount</div>
                        <div class="fw-bold text-primary fs-5">
                            <fmt:formatNumber xmlns:fmt="http://java.sun.com/jsp/jstl/fmt"
                                value="${bill.totalAmount}" groupingUsed="true" maxFractionDigits="0"/>&#8363;
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%-- Bill items --%>
        <c:if test="${not empty billItems}">
            <div class="card shadow-sm border-0 mb-3">
                <div class="card-header bg-white fw-semibold">
                    <i class="bi bi-list-ul me-1"></i>Bill Items
                </div>
                <div class="card-body p-0">
                    <table class="table table-sm mb-0 align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>Description</th>
                                <th class="text-center">Qty</th>
                                <th class="text-end">Unit Price</th>
                                <th class="text-end">Subtotal</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${billItems}">
                                <tr>
                                    <td>${item.description}</td>
                                    <td class="text-center">${item.quantity}</td>
                                    <td class="text-end">
                                        <fmt:formatNumber xmlns:fmt="http://java.sun.com/jsp/jstl/fmt"
                                            value="${item.unitPrice}" groupingUsed="true" maxFractionDigits="0"/>&#8363;
                                    </td>
                                    <td class="text-end fw-semibold">
                                        <fmt:formatNumber xmlns:fmt="http://java.sun.com/jsp/jstl/fmt"
                                            value="${item.quantity * item.unitPrice}" groupingUsed="true" maxFractionDigits="0"/>&#8363;
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:if>

        <%-- Actions --%>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/bill?action=edit&id=${bill.billId}"
               class="btn btn-primary btn-sm"><i class="bi bi-pencil me-1"></i>Edit</a>
            <a href="${pageContext.request.contextPath}/bill?action=delete&id=${bill.billId}"
               class="btn btn-danger btn-sm"
               onclick="return confirm('Delete bill #${bill.billId}?')">
                <i class="bi bi-trash me-1"></i>Delete
            </a>
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
