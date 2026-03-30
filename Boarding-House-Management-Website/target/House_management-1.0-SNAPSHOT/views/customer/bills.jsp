<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>My Bills - AKDD House</title>
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
    <h4 class="mb-3"><i class="bi bi-receipt me-2"></i>My Bills</h4>

    <div class="card shadow-sm border-0">
        <div class="card-body p-0">
            <table class="table table-hover mb-0 align-middle">
                <thead class="table-light">
                    <tr>
                        <th>#</th>
                        <th>Period</th>
                        <th>Due Date</th>
                        <th class="text-end">Total</th>
                        <th>Status</th>
                        <th>Detail</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty bills}">
                            <tr>
                                <td colspan="6" class="text-center text-muted py-4">
                                    <i class="bi bi-inbox fs-4 d-block mb-2"></i>No bills yet.
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="b" items="${bills}">
                                <tr>
                                    <td class="text-muted small">${b.billId}</td>
                                    <td>${b.period}</td>
                                    <td>${b.dueDate}</td>
                                    <td class="text-end fw-semibold">
                                        <c:if test="${not empty b.totalAmount}">
                                            <fmt:formatNumber value="${b.totalAmount}" groupingUsed="true" maxFractionDigits="0"/>&#8363;
                                        </c:if>
                                        <c:if test="${empty b.totalAmount}">—</c:if>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${b.status == 'paid'}">
                                                <span class="badge bg-success">Paid</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger">Unpaid</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/bill?action=detail&id=${b.billId}"
                                           class="btn btn-sm btn-outline-primary">
                                            <i class="bi bi-eye"></i>
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

    <%-- Pagination --%>
    <c:if test="${totalPages > 1}">
        <div class="d-flex justify-content-between align-items-center mt-3">
            <div class="text-muted small">
                Showing <strong>${(currentPage - 1) * pageSize + 1}</strong>–<strong>${(currentPage - 1) * pageSize + bills.size()}</strong>
                of <strong>${totalItems}</strong> bills
            </div>
            <nav>
                <ul class="pagination pagination-sm mb-0">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/bill?action=mybill&page=${currentPage - 1}">
                            <i class="bi bi-chevron-left"></i>
                        </a>
                    </li>
                    <c:forEach begin="1" end="${totalPages}" var="p">
                        <c:choose>
                            <c:when test="${p == currentPage}">
                                <li class="page-item active"><span class="page-link">${p}</span></li>
                            </c:when>
                            <c:when test="${p == 1 || p == totalPages || (p >= currentPage - 2 && p <= currentPage + 2)}">
                                <li class="page-item">
                                    <a class="page-link" href="${pageContext.request.contextPath}/bill?action=mybill&page=${p}">${p}</a>
                                </li>
                            </c:when>
                            <c:when test="${(p == currentPage - 3 && currentPage > 4) || (p == currentPage + 3 && currentPage < totalPages - 3)}">
                                <li class="page-item disabled"><span class="page-link">…</span></li>
                            </c:when>
                        </c:choose>
                    </c:forEach>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/bill?action=mybill&page=${currentPage + 1}">
                            <i class="bi bi-chevron-right"></i>
                        </a>
                    </li>
                </ul>
            </nav>
        </div>
    </c:if>
    </main>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
