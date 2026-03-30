<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Edit Bill - AKDD House</title>
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

<div style="max-width:560px;">

    <c:if test="${empty bill}">
        <div class="alert alert-danger">Bill not found.</div>
    </c:if>

    <c:if test="${not empty bill}">
        <div class="d-flex align-items-center gap-2 mb-4">
            <a href="${pageContext.request.contextPath}/bill?action=detail&id=${bill.billId}"
               class="btn btn-sm btn-outline-secondary">
                <i class="bi bi-arrow-left"></i>
            </a>
            <h4 class="mb-0"><i class="bi bi-pencil-square me-2"></i>Edit Bill #${bill.billId}</h4>
        </div>

        <div class="card shadow-sm border-0">
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/bill" method="post">
                    <input type="hidden" name="action"  value="update">
                    <input type="hidden" name="billId"  value="${bill.billId}">

                    <%-- Contract (read-only — changing contract would break accounting) --%>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Contract</label>
                        <input type="hidden" name="contractId" value="${bill.contractId}">
                        <input type="text" class="form-control" value="Contract #${bill.contractId}" readonly>
                    </div>

                    <%-- Period --%>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Period <span class="text-danger">*</span></label>
                        <input type="month" name="period" class="form-control"
                               value="${bill.period.toString().substring(0, 7)}" required>
                    </div>

                    <%-- Due Date --%>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Due Date <span class="text-danger">*</span></label>
                        <input type="date" name="dueDate" class="form-control"
                               value="${bill.dueDate}" required>
                    </div>

                    <%-- Status --%>
                    <div class="mb-4">
                        <label class="form-label fw-semibold">Status <span class="text-danger">*</span></label>
                        <select name="status" class="form-select" required>
                            <option value="pending" ${bill.status == 'pending' ? 'selected' : ''}>Unpaid</option>
                            <option value="paid"   ${bill.status == 'paid'   ? 'selected' : ''}>Paid</option>
                        </select>
                    </div>

                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-primary px-4">
                            <i class="bi bi-save me-1"></i>Save Changes
                        </button>
                        <a href="${pageContext.request.contextPath}/bill?action=detail&id=${bill.billId}"
                           class="btn btn-outline-secondary">Cancel</a>
                    </div>
                </form>
            </div>
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
