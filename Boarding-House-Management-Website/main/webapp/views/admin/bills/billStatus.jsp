<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Bill Payment Status - AKDD House</title>
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
        <h4 class="mb-0"><i class="bi bi-bar-chart-line me-2"></i>Bill Payment Status</h4>
    </div>

    <%-- Filter bar --%>
    <div class="mb-3 d-flex gap-2 flex-wrap">
        <a href="${pageContext.request.contextPath}/bill?action=status"
           class="btn btn-sm ${empty filterStatus ? 'btn-primary' : 'btn-outline-primary'}">All</a>
        <a href="${pageContext.request.contextPath}/bill?action=status&status=pending"
           class="btn btn-sm ${filterStatus == 'pending' ? 'btn-danger' : 'btn-outline-danger'}">
            Unpaid
        </a>
        <a href="${pageContext.request.contextPath}/bill?action=status&status=paid"
           class="btn btn-sm ${filterStatus == 'paid' ? 'btn-success' : 'btn-outline-success'}">
            Paid
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
                        <th>Update Status</th>
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
                                    <td><span class="badge bg-secondary">${not empty b.roomNumber ? b.roomNumber : '-'}</span></td>
                                    <td>${b.contractId}</td>
                                    <td>${b.period}</td>
                                    <td>${b.dueDate}</td>
                                    <td>
                                        <fmt:formatNumber value="${b.totalAmount}" groupingUsed="true" maxFractionDigits="0"/>&#8363;
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
                                        <%-- Quick status toggle form --%>
                                        <form action="${pageContext.request.contextPath}/bill" method="post" class="d-inline">
                                            <input type="hidden" name="action"  value="updateStatus">
                                            <input type="hidden" name="billId"  value="${b.billId}">
                                            <c:choose>
                                                <c:when test="${b.status == 'pending'}">
                                                    <input type="hidden" name="status" value="paid">
                                                    <button type="submit" class="btn btn-sm btn-success">
                                                        <i class="bi bi-check2-circle me-1"></i>Mark Paid
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="hidden" name="status" value="pending">
                                                    <button type="submit" class="btn btn-sm btn-outline-secondary">
                                                        <i class="bi bi-arrow-counterclockwise me-1"></i>Mark Unpaid
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </form>
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
