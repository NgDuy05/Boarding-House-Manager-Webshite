<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Deposit Transactions - AKDD House</title>
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
    <div class="d-flex align-items-center justify-content-between mb-3">
        <div>
            <h4 class="mb-0">
                <i class="bi bi-wallet2 me-2"></i>Deposit Transactions
                <c:if test="${not empty contractId}">
                    <span class="fs-6 text-muted ms-2">Contract #${contractId}</span>
                </c:if>
            </h4>
        </div>
        <a href="${pageContext.request.contextPath}/deposit?action=form<c:if test='${not empty contractId}'>&amp;contractId=${contractId}</c:if>"
           class="btn btn-primary btn-sm">
            <i class="bi bi-plus-lg me-1"></i>New Transaction
        </a>
    </div>

    <%-- Balance card (shown when viewing a single contract) --%>
    <c:if test="${not empty contractId}">
        <div class="card border-0 shadow-sm mb-4"
             style="background:linear-gradient(135deg,#4f46e5,#7c3aed);color:#fff;border-radius:14px;">
            <div class="card-body py-3">
                <div class="small opacity-75 mb-1">Current Deposit Balance</div>
                <div class="fs-4 fw-bold">
                    <fmt:formatNumber value="${balance}" groupingUsed="true" maxFractionDigits="0"/>&#8363;
                </div>
            </div>
        </div>
    </c:if>

    <div class="card shadow-sm border-0">
        <div class="card-body p-0">
            <table class="table table-hover mb-0 align-middle">
                <thead class="table-light">
                    <tr>
                        <th>#</th>
                        <th>Contract</th>
                        <th>Room</th>
                        <th>Type</th>
                        <th class="text-end">Amount</th>
                        <th>Note</th>
                        <th>Date</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty deposits}">
                            <tr><td colspan="7" class="text-center text-muted py-4">No transactions found.</td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="dt" items="${deposits}">
                                <tr>
                                    <td>${dt.depositId}</td>
                                    <td>#${dt.contractId}</td>
                                    <td>
                                        <span class="badge bg-secondary">
                                            ${not empty dt.roomNumber ? dt.roomNumber : '-'}
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${dt.transactionType == 'deposit'}">
                                                <span class="badge bg-success">Deposit</span>
                                            </c:when>
                                            <c:when test="${dt.transactionType == 'refund'}">
                                                <span class="badge bg-info text-dark">Refund</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-warning text-dark">Deduction</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end fw-semibold">
                                        <c:choose>
                                            <c:when test="${dt.transactionType == 'deposit'}">
                                                <span class="text-success">
                                                    +<fmt:formatNumber value="${dt.amount}" groupingUsed="true" maxFractionDigits="0"/>&#8363;
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-danger">
                                                    -<fmt:formatNumber value="${dt.amount}" groupingUsed="true" maxFractionDigits="0"/>&#8363;
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-muted small">${not empty dt.note ? dt.note : '-'}</td>
                                    <td class="text-muted small">
                                        <c:if test="${not empty dt.createdAt}">
                                            ${dt.createdAt}
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
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
