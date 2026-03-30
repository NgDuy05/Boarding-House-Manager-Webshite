<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Owner Bill List - AKDD House</title>
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
        <h4 class="mb-0"><i class="bi bi-receipt me-2"></i>Owner Bill List</h4>
        <a href="${pageContext.request.contextPath}/bill?action=create" class="btn btn-primary btn-sm">
            <i class="bi bi-plus-lg me-1"></i>Create Bill
        </a>
    </div>

    <div class="card shadow-sm border-0">
        <div class="card-body p-0">
            <table class="table table-hover mb-0 align-middle">
                <thead class="table-light">
                    <tr>
                        <th>#</th>
                        <th>Room</th>
                        <th>Contract</th>
                        <th>Period</th>
                        <th>Due Date</th>
                        <th>Total</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty bills}">
                            <tr><td colspan="8" class="text-center text-muted py-4">No bills found.</td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="b" items="${bills}">
                                <tr>
                                    <td>${b.billId}</td>
                                    <td>
                                        <span class="badge bg-secondary">${not empty b.roomNumber ? b.roomNumber : '-'}</span>
                                    </td>
                                    <td>${b.contractId}</td>
                                    <td><fmt:formatDate value="${b.period}" pattern="MMM yyyy" type="date"/></td>
                                    <td><fmt:formatDate value="${b.dueDate}" pattern="dd/MM/yyyy" type="date"/></td>
                                    <td>
                                        <fmt:formatNumber value="${b.totalAmount}" groupingUsed="true" maxFractionDigits="0"/>&#8363;
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${b.status == 'paid'}">
                                                <span class="badge bg-success">Paid</span>
                                            </c:when>
                                            <c:when test="${b.status == 'pending'}">
                                                <span class="badge bg-danger">Unpaid</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">${b.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/bill?action=detail&id=${b.billId}"
                                           class="btn btn-sm btn-outline-primary">
                                            <i class="bi bi-eye"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/bill?action=edit&id=${b.billId}"
                                           class="btn btn-sm btn-outline-secondary">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/bill?action=delete&id=${b.billId}"
                                           class="btn btn-sm btn-outline-danger"
                                           onclick="return confirm('Delete this bill?')">
                                            <i class="bi bi-trash"></i>
                                        </a>
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
