<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Service History - AKDD House</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { background: #f4f6f9; font-family: 'Inter', sans-serif; }
        .page-hero {
            background: linear-gradient(135deg, #0ea5e9, #6366f1);
            color: #fff; padding: 48px 0 56px; margin-bottom: -32px;
        }
        .page-hero h1 { font-weight: 700; font-size: 1.9rem; }
        .page-hero p  { opacity: .85; }

        .stat-chip {
            background: #fff; border-radius: 14px;
            padding: 16px 22px;
            box-shadow: 0 2px 12px rgba(0,0,0,.08);
            display: flex; align-items: center; gap: .85rem;
        }
        .stat-chip .chip-icon {
            width: 44px; height: 44px; border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.3rem; flex-shrink: 0;
        }
        .chip-total   .chip-icon { background: #e0f2fe; color: #0284c7; }
        .chip-pending .chip-icon { background: #fef9c3; color: #ca8a04; }
        .chip-billed  .chip-icon { background: #d1fae5; color: #059669; }
        .stat-chip .chip-num { font-size: 1.5rem; font-weight: 700; color: #1e293b; line-height:1; }
        .stat-chip .chip-lbl { font-size: .78rem; color: #94a3b8; margin-top: 2px; }

        .history-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,.06);
            overflow: hidden;
        }
        .status-badge-billed  { background:#d1fae5; color:#065f46; border-radius:50px; padding:3px 12px; font-size:.75rem; font-weight:600; }
        .status-badge-pending { background:#fef9c3; color:#92400e; border-radius:50px; padding:3px 12px; font-size:.75rem; font-weight:600; }

        .service-tag {
            display: inline-flex; align-items: center; gap: .3rem;
            background: #eff6ff; color: #1d4ed8;
            border-radius: 50px; padding: 3px 12px;
            font-size: .78rem; font-weight: 600;
        }
        .total-cost { font-weight: 700; color: #1e293b; }
        .empty-icon { font-size: 3.5rem; color: #cbd5e1; }
    </style>
</head>
<body>
    <%@ include file="../navbar.jsp" %>

    <div class="container-fluid p-0">
      <div class="row g-0" style="min-height: calc(100vh - 56px);">
        <%@ include file="sidebar.jsp" %>
        <main class="col p-0">

    <%-- Hero --%>
    <div class="page-hero">
        <div class="container">
            <nav aria-label="breadcrumb" class="mb-3">
                <ol class="breadcrumb" style="--bs-breadcrumb-divider-color:rgba(255,255,255,.5)">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/" class="text-white text-opacity-75">Home</a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/services" class="text-white text-opacity-75">Services</a>
                    </li>
                    <li class="breadcrumb-item active text-white">My Service History</li>
                </ol>
            </nav>
            <div class="d-flex align-items-start justify-content-between flex-wrap gap-3">
                <div>
                    <h1><i class="bi bi-clock-history me-2"></i>My Service History</h1>
                    <p class="mb-0">Track all services used in your tenancy period</p>
                </div>
                <a href="${pageContext.request.contextPath}/services?action=requestForm"
                   style="background:rgba(255,255,255,.2);border:1px solid rgba(255,255,255,.4);color:#fff;border-radius:50px;padding:10px 22px;text-decoration:none;font-weight:600;font-size:.9rem;display:inline-flex;align-items:center;gap:.5rem;transition:background .2s"
                   onmouseover="this.style.background='rgba(255,255,255,.3)'"
                   onmouseout="this.style.background='rgba(255,255,255,.2)'">
                    <i class="bi bi-send"></i>Request New Service
                </a>
            </div>
        </div>
    </div>

    <div class="container pb-5" style="padding-top: 48px;">

        <%-- Stats strip --%>
        <div class="row g-3 mb-4">
            <%-- Compute stats --%>
            <c:set var="totalRecords" value="${historyList.size()}" />
            <c:set var="pendingCount" value="0" />
            <c:set var="billedCount"  value="0" />
            <c:set var="grandTotal"   value="0" />
            <c:forEach var="h" items="${historyList}">
                <c:choose>
                    <c:when test="${h.billed}">
                        <c:set var="billedCount" value="${billedCount + 1}" />
                    </c:when>
                    <c:otherwise>
                        <c:set var="pendingCount" value="${pendingCount + 1}" />
                    </c:otherwise>
                </c:choose>
                <c:set var="grandTotal" value="${grandTotal + h.totalCost}" />
            </c:forEach>

            <div class="col-sm-6 col-lg-3">
                <div class="stat-chip chip-total">
                    <div class="chip-icon"><i class="bi bi-grid-3x3-gap-fill"></i></div>
                    <div>
                        <div class="chip-num">${totalRecords}</div>
                        <div class="chip-lbl">Total records</div>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-lg-3">
                <div class="stat-chip chip-pending">
                    <div class="chip-icon"><i class="bi bi-clock-fill"></i></div>
                    <div>
                        <div class="chip-num">${pendingCount}</div>
                        <div class="chip-lbl">Pending billing</div>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-lg-3">
                <div class="stat-chip chip-billed">
                    <div class="chip-icon"><i class="bi bi-check-circle-fill"></i></div>
                    <div>
                        <div class="chip-num">${billedCount}</div>
                        <div class="chip-lbl">Already billed</div>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-lg-3">
                <div class="stat-chip chip-total">
                    <div class="chip-icon"><i class="bi bi-currency-exchange"></i></div>
                    <div>
                        <div class="chip-num" style="font-size:1.1rem">
                            <fmt:formatNumber value="${grandTotal}" groupingUsed="true" maxFractionDigits="0"/>₫
                        </div>
                        <div class="chip-lbl">Estimated total</div>
                    </div>
                </div>
            </div>
        </div>

        <%-- Filter buttons --%>
        <div class="d-flex align-items-center gap-2 mb-3">
            <span class="text-muted small fw-semibold"><i class="bi bi-funnel me-1"></i>Filter:</span>
            <button class="btn btn-sm btn-primary"        onclick="filterHistory('all')">All</button>
            <button class="btn btn-sm btn-outline-warning" onclick="filterHistory('pending')">Pending</button>
            <button class="btn btn-sm btn-outline-success" onclick="filterHistory('billed')">Billed</button>
        </div>

        <%-- History table --%>
        <div class="history-card card">
            <c:choose>
                <c:when test="${not empty historyList}">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0" id="historyTable">
                            <thead style="background:#f8fafc">
                                <tr>
                                    <th class="ps-4">#</th>
                                    <th>Service</th>
                                    <th>Room / Contract</th>
                                    <th>Usage Date</th>
                                    <th class="text-end">Qty</th>
                                    <th class="text-end">Unit Price</th>
                                    <th class="text-end">Amount</th>
                                    <th class="text-center">Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="h" items="${historyList}" varStatus="st">
                                    <tr data-status="${h.billed ? 'billed' : 'pending'}">
                                        <td class="ps-4 text-muted small">${st.count}</td>
                                        <td>
                                            <span class="service-tag">
                                                <i class="bi bi-lightning-charge"></i>
                                                ${h.serviceName}
                                            </span>
                                        </td>
                                        <td>
                                            <div class="fw-semibold small">Room ${h.roomNumber}</div>
                                            <div class="text-muted" style="font-size:.75rem">Contract #${h.contractId}</div>
                                        </td>
                                        <td class="text-muted small">${h.usageDate}</td>
                                        <td class="text-end small">${h.quantity}</td>
                                        <td class="text-end text-muted small">
                                            <fmt:formatNumber value="${h.unitPrice}" groupingUsed="true" maxFractionDigits="0"/>₫
                                        </td>
                                        <td class="text-end">
                                            <span class="total-cost">
                                                <fmt:formatNumber value="${h.totalCost}" groupingUsed="true" maxFractionDigits="0"/>₫
                                            </span>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${h.status == 'pending'}">
                                                    <span class="status-badge-pending">
                                                        <i class="bi bi-hourglass-split me-1"></i>Chờ duyệt
                                                    </span>
                                                </c:when>
                                                <c:when test="${h.status == 'rejected'}">
                                                    <span style="background:#fee2e2;color:#991b1b;border-radius:50px;padding:3px 12px;font-size:.75rem;font-weight:600">
                                                        <i class="bi bi-x-circle me-1"></i>Từ chối
                                                    </span>
                                                </c:when>
                                                <c:when test="${h.billed}">
                                                    <span class="status-badge-billed">
                                                        <i class="bi bi-receipt me-1"></i>Đã tính tiền
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge-billed" style="background:#dbeafe;color:#1e40af">
                                                        <i class="bi bi-check-circle me-1"></i>Đã duyệt
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-5">
                        <div class="empty-icon mb-3">
                            <i class="bi bi-clock-history"></i>
                        </div>
                        <h5 class="fw-semibold text-muted">No service history found</h5>
                        <p class="text-muted small">You haven't used any services yet.</p>
                        <a href="${pageContext.request.contextPath}/services"
                           class="btn btn-primary mt-2">
                            <i class="bi bi-grid me-1"></i>Browse Services
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function filterHistory(status) {
            var rows = document.querySelectorAll('#historyTable tbody tr');
            rows.forEach(function(row) {
                if (status === 'all') {
                    row.style.display = '';
                } else {
                    row.style.display = (row.getAttribute('data-status') === status) ? '' : 'none';
                }
            });
        }
    </script>
        </main>
      </div>
    </div>
</body>
</html>
