<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Customers - AKDD House</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; }
        .page-header {
            background: linear-gradient(135deg, #11998e, #38ef7d);
            color: white;
            border-radius: 12px;
            padding: 20px 24px;
            margin-bottom: 24px;
        }
        .table-card { border-radius: 14px; border: none; }
        .table thead th {
            background: #f8f9fa;
            color: #6c757d;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: .5px;
            border: none;
        }
        .table tbody tr:hover { background: #f0fff4; }
        .avatar-sm {
            width: 38px; height: 38px;
            border-radius: 50%;
            background: linear-gradient(135deg, #11998e, #38ef7d);
            display: inline-flex; align-items: center; justify-content: center;
            color: white; font-weight: 700; font-size: 14px;
            flex-shrink: 0;
        }
        .avatar-sm.hidden-user { background: linear-gradient(135deg, #adb5bd, #6c757d); }
        .stat-card { border-radius: 12px; border: none; padding: 14px 20px; }
        tr.row-hidden td { opacity: 0.6; }
        tr.row-hidden .customer-name { text-decoration: line-through; }
        .pagination .page-link {
            color: #11998e;
            border-color: #dee2e6;
        }
        .pagination .page-item.active .page-link {
            background-color: #11998e;
            border-color: #11998e;
            color: white;
        }
        .pagination .page-link:hover { background-color: #e8fff8; }
        .pagination .page-item.disabled .page-link { color: #adb5bd; }
    </style>
</head>
<body>
    <%@ include file="../../navbar.jsp" %>

    <div class="container-fluid">
    <div class="row flex-nowrap admin-layout-row">
    <%@ include file="../sidebar.jsp" %>
    <main class="col admin-main px-4 py-4 mb-5">

        <%-- Flash messages --%>
        <c:if test="${not empty sessionScope.customerSuccess}">
            <div class="alert alert-success d-flex align-items-center alert-dismissible fade show">
                <i class="bi bi-check-circle-fill me-2"></i>
                <span>${sessionScope.customerSuccess}</span>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% session.removeAttribute("customerSuccess"); %>
        </c:if>
        <c:if test="${not empty sessionScope.customerError}">
            <div class="alert alert-danger d-flex align-items-center alert-dismissible fade show">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                <span>${sessionScope.customerError}</span>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% session.removeAttribute("customerError"); %>
        </c:if>

        <%-- Page header --%>
        <div class="page-header d-flex justify-content-between align-items-center flex-wrap gap-2">
            <div>
                <h4 class="fw-bold mb-1">
                    <i class="bi bi-person-lines-fill me-2"></i>Manage Customers
                </h4>
                <small class="opacity-75">View, add, edit, and hide/restore tenant accounts</small>
            </div>
            <a href="${pageContext.request.contextPath}/manage-customer?action=create"
               class="btn btn-light fw-semibold">
                <i class="bi bi-person-plus-fill me-1"></i>Add Customer
            </a>
        </div>

        <%-- Stats bar --%>
        <div class="row g-3 mb-4">
            <div class="col-6 col-md-3">
                <div class="card stat-card shadow-sm text-center">
                    <div class="fw-bold fs-4 text-success">${activeCount}</div>
                    <div class="text-muted small">Active</div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="card stat-card shadow-sm text-center">
                    <div class="fw-bold fs-4 text-secondary">${hiddenCount}</div>
                    <div class="text-muted small">Hidden</div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="card stat-card shadow-sm text-center">
                    <div class="fw-bold fs-4 text-dark">${totalItems}</div>
                    <div class="text-muted small">Total</div>
                </div>
            </div>
        </div>

        <%-- Search & filter --%>
        <div class="card table-card shadow-sm mb-4">
            <div class="card-body p-3">
                <form action="${pageContext.request.contextPath}/manage-customer" method="get"
                      class="row g-2 align-items-end">
                    <input type="hidden" name="action" value="list">
                    <div class="col-md-5">
                        <label class="form-label small fw-semibold text-muted mb-1">Search</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-search"></i></span>
                            <input type="text" name="search" class="form-control"
                                   placeholder="Name, username, email, phone..."
                                   value="${search}">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label small fw-semibold text-muted mb-1">Status</label>
                        <select name="status" class="form-select">
                            <option value="">All</option>
                            <option value="active" ${statusFilter == 'active' ? 'selected' : ''}>Active</option>
                            <option value="hidden" ${statusFilter == 'hidden' ? 'selected' : ''}>Hidden</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-success w-100">
                            <i class="bi bi-funnel me-1"></i>Filter
                        </button>
                    </div>
                    <div class="col-md-2">
                        <a href="${pageContext.request.contextPath}/manage-customer"
                           class="btn btn-outline-secondary w-100">
                            <i class="bi bi-x-circle me-1"></i>Clear
                        </a>
                    </div>
                </form>
            </div>
        </div>

        <%-- Table --%>
        <div class="card table-card shadow-sm">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th class="ps-4">#</th>
                                <th>Customer</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th class="text-center">Status</th>
                                <th class="text-center pe-4">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty customers}">
                                    <tr>
                                        <td colspan="6" class="text-center py-5 text-muted">
                                            <i class="bi bi-person-x fs-3 d-block mb-2"></i>
                                            No customers found
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="c" items="${customers}" varStatus="st">
                                        <%-- row number accounts for current page offset --%>
                                        <c:set var="rowNum" value="${(currentPage - 1) * pageSize + st.count}" />
                                        <tr class="${c.isDeleted ? 'row-hidden' : ''}">
                                            <td class="ps-4 text-muted small">${rowNum}</td>
                                            <td>
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="avatar-sm ${c.isDeleted ? 'hidden-user' : ''}">
                                                        ${not empty c.fullName ? c.fullName.substring(0,1).toUpperCase() : c.username.substring(0,1).toUpperCase()}
                                                    </div>
                                                    <div>
                                                        <div class="fw-semibold customer-name">${not empty c.fullName ? c.fullName : '—'}</div>
                                                        <div class="text-muted small">@${c.username}</div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="text-muted small">${not empty c.email ? c.email : '—'}</td>
                                            <td class="text-muted small">${not empty c.phone ? c.phone : '—'}</td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${not c.isDeleted}">
                                                        <span class="badge bg-success-subtle text-success border border-success-subtle rounded-pill px-3">
                                                            <i class="bi bi-circle-fill me-1" style="font-size:8px"></i>Active
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle rounded-pill px-3">
                                                            <i class="bi bi-eye-slash me-1"></i>Hidden
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center pe-4">
                                                <c:choose>
                                                    <c:when test="${not c.isDeleted}">
                                                        <a href="${pageContext.request.contextPath}/manage-customer?action=detail&id=${c.userId}"
                                                           class="btn btn-sm btn-outline-info me-1" title="View Detail">
                                                            <i class="bi bi-eye"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/manage-customer?action=edit&id=${c.userId}"
                                                           class="btn btn-sm btn-outline-primary me-1" title="Edit">
                                                            <i class="bi bi-pencil"></i>
                                                        </a>
                                                        <button class="btn btn-sm btn-outline-secondary"
                                                                title="Hide customer"
                                                                onclick="confirmHide(${c.userId}, '${c.username}')">
                                                            <i class="bi bi-eye-slash"></i>
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="${pageContext.request.contextPath}/manage-customer?action=restore&id=${c.userId}"
                                                           class="btn btn-sm btn-success w-100" title="Restore"
                                                           onclick="return confirm('Restore customer @${c.username}?')">
                                                            <i class="bi bi-arrow-counterclockwise me-1"></i>Restore
                                                        </a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <%-- Pagination footer --%>
                <c:if test="${totalPages > 1}">
                    <div class="d-flex justify-content-between align-items-center px-4 py-3 border-top">
                        <div class="text-muted small">
                            Showing <strong>${(currentPage - 1) * pageSize + 1}</strong>–<strong>${(currentPage - 1) * pageSize + customers.size()}</strong>
                            of <strong>${totalItems}</strong> customers
                        </div>
                        <nav>
                            <ul class="pagination pagination-sm mb-0">

                                <%-- Previous --%>
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/manage-customer?action=list&page=${currentPage - 1}&search=${search}&status=${statusFilter}">
                                        <i class="bi bi-chevron-left"></i>
                                    </a>
                                </li>

                                <%-- Page numbers --%>
                                <c:forEach begin="1" end="${totalPages}" var="p">
                                    <c:choose>
                                        <c:when test="${p == currentPage}">
                                            <li class="page-item active">
                                                <span class="page-link">${p}</span>
                                            </li>
                                        </c:when>
                                        <c:when test="${p == 1 || p == totalPages || (p >= currentPage - 2 && p <= currentPage + 2)}">
                                            <li class="page-item">
                                                <a class="page-link" href="${pageContext.request.contextPath}/manage-customer?action=list&page=${p}&search=${search}&status=${statusFilter}">${p}</a>
                                            </li>
                                        </c:when>
                                        <c:when test="${(p == currentPage - 3 && currentPage > 4) || (p == currentPage + 3 && currentPage < totalPages - 3)}">
                                            <li class="page-item disabled"><span class="page-link">…</span></li>
                                        </c:when>
                                    </c:choose>
                                </c:forEach>

                                <%-- Next --%>
                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/manage-customer?action=list&page=${currentPage + 1}&search=${search}&status=${statusFilter}">
                                        <i class="bi bi-chevron-right"></i>
                                    </a>
                                </li>

                            </ul>
                        </nav>
                    </div>
                </c:if>
            </div>
        </div>

    </main>
    </div>
    </div>

    <%-- Hide confirm modal --%>
    <div class="modal fade" id="hideModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold">
                        <i class="bi bi-eye-slash me-2 text-secondary"></i>Hide Customer
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p class="text-muted mb-0">
                        Are you sure you want to hide customer <strong id="hideUsername"></strong>?
                        You can restore them later.
                    </p>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <a id="hideConfirmBtn" href="#" class="btn btn-secondary">
                        <i class="bi bi-eye-slash me-1"></i>Hide
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmHide(userId, username) {
            document.getElementById('hideUsername').textContent = '@' + username;
            document.getElementById('hideConfirmBtn').href =
                '${pageContext.request.contextPath}/manage-customer?action=hide&id=' + userId;
            new bootstrap.Modal(document.getElementById('hideModal')).show();
        }
    </script>
<%@ include file="../../footer.jsp" %>
</body>
</html>
