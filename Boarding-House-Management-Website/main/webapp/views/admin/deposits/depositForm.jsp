<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Record Deposit - AKDD House</title>
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
<main class="col admin-main px-4 py-4"><div style="max-width:560px;">
    <div class="d-flex align-items-center gap-2 mb-4">
        <a href="${pageContext.request.contextPath}/deposit?action=all" class="btn btn-sm btn-outline-secondary">
            <i class="bi bi-arrow-left"></i>
        </a>
        <h4 class="mb-0"><i class="bi bi-wallet2 me-2"></i>Record Deposit Transaction</h4>
    </div>

    <%-- Current balance card --%>
    <c:if test="${not empty contractId and not empty balance}">
        <div class="card border-0 shadow-sm mb-4 text-white"
             style="background:linear-gradient(135deg,#4f46e5,#7c3aed);border-radius:12px;">
            <div class="card-body py-3">
                <div class="small opacity-75 mb-1">Current Balance — Contract #${contractId}</div>
                <div class="fs-5 fw-bold">
                    <fmt:formatNumber value="${balance}" groupingUsed="true" maxFractionDigits="0"/>&#8363;
                </div>
            </div>
        </div>
    </c:if>

    <div class="card shadow-sm border-0">
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/deposit" method="post">
                <input type="hidden" name="action" value="record">

                <%-- Contract selection --%>
                <div class="mb-3">
                    <label class="form-label fw-semibold">Contract <span class="text-danger">*</span></label>
                    <c:choose>
                        <c:when test="${not empty contractId}">
                            <%-- Pre-selected, show read-only --%>
                            <input type="hidden" name="contractId" value="${contractId}">
                            <input type="text" class="form-control" value="Contract #${contractId}" readonly>
                        </c:when>
                        <c:otherwise>
                            <select name="contractId" class="form-select" required>
                                <option value="">-- Select Contract --</option>
                                <c:forEach var="c" items="${contracts}">
                                    <option value="${c.contractId}">Contract #${c.contractId} — Room ${c.roomId}</option>
                                </c:forEach>
                            </select>
                        </c:otherwise>
                    </c:choose>
                </div>

                <%-- Transaction type --%>
                <div class="mb-3">
                    <label class="form-label fw-semibold">Transaction Type <span class="text-danger">*</span></label>
                    <select name="transactionType" class="form-select" required>
                        <option value="deposit">Deposit — tenant pays deposit</option>
                        <option value="refund">Refund — return deposit to tenant</option>
                        <option value="deduction">Deduction — deduct from deposit</option>
                    </select>
                </div>

                <%-- Amount --%>
                <div class="mb-3">
                    <label class="form-label fw-semibold">Amount (&#8363;) <span class="text-danger">*</span></label>
                    <input type="number" name="amount" class="form-control"
                           placeholder="e.g. 2000000" min="1" step="any" required>
                </div>

                <%-- Note --%>
                <div class="mb-4">
                    <label class="form-label fw-semibold">Note</label>
                    <textarea name="note" class="form-control" rows="2"
                              placeholder="Optional note about this transaction"></textarea>
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary px-4">
                        <i class="bi bi-save me-1"></i>Save
                    </button>
                    <a href="${pageContext.request.contextPath}/deposit?action=all" class="btn btn-outline-secondary">
                        Cancel
                    </a>
                </div>
            </form>
        </div>
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
