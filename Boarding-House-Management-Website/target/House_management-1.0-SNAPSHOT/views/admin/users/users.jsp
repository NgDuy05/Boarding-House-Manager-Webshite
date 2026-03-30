<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý người dùng - AKDD House</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; }
        .page-header {
            background: linear-gradient(135deg, #667eea, #764ba2);
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
        .table tbody tr:hover { background: #f8f0ff; }
        .role-badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
        }
        .role-admin    { background: #fff3cd; color: #856404; }
        .role-staff    { background: #cff4fc; color: #0a6071; }
        .role-customer { background: #d1e7dd; color: #0a3622; }
        .avatar-sm {
            width: 36px; height: 36px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea, #764ba2);
            display: inline-flex; align-items: center; justify-content: center;
            color: white; font-weight: 700; font-size: 14px;
            flex-shrink: 0;
        }
    </style>
</head>
<body>
    <%@ include file="../../navbar.jsp" %>

<div class="container-fluid">
<div class="row flex-nowrap admin-layout-row">
<%@ include file="../sidebar.jsp" %>
<main class="col admin-main px-4 py-4">

        <%-- Admin success/error messages --%>
        <c:if test="${not empty sessionScope.adminSuccess}">
            <div class="alert alert-success d-flex align-items-center alert-dismissible fade show">
                <i class="bi bi-check-circle-fill me-2"></i>
                <span>${sessionScope.adminSuccess}</span>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% session.removeAttribute("adminSuccess"); %>
        </c:if>
        <c:if test="${not empty sessionScope.adminError}">
            <div class="alert alert-danger d-flex align-items-center alert-dismissible fade show">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                <span>${sessionScope.adminError}</span>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% session.removeAttribute("adminError"); %>
        </c:if>

        <%-- Page header --%>
        <div class="page-header d-flex justify-content-between align-items-center">
            <div>
                <h4 class="fw-bold mb-1">
                    <i class="bi bi-people-fill me-2"></i>Quản lý người dùng
                </h4>
                <small class="opacity-75">Xem và chỉnh sửa hồ sơ tất cả người dùng</small>
            </div>
            <div class="badge bg-white text-dark fs-6 px-3 py-2">
                Tổng: <strong>${totalItems} người</strong>
            </div>
        </div>

        <%-- Search & filter --%>
        <div class="card table-card shadow-sm mb-4">
            <div class="card-body p-3">
                <form action="${pageContext.request.contextPath}/user" method="get"
                      class="row g-2 align-items-end">
                    <input type="hidden" name="action" value="list">

                    <div class="col-md-5">
                        <label class="form-label small fw-semibold text-muted mb-1">Tìm kiếm</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-search"></i></span>
                            <input type="text" name="search" class="form-control"
                                   placeholder="Tên, username, email..."
                                   value="${search}">
                        </div>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label small fw-semibold text-muted mb-1">Vai trò</label>
                        <select name="role" class="form-select">
                            <option value="">Tất cả vai trò</option>
                            <option value="admin"    ${roleFilter == 'admin'    ? 'selected' : ''}>Quản trị viên</option>
                            <option value="staff"    ${roleFilter == 'staff'    ? 'selected' : ''}>Nhân viên</option>
                            <option value="customer" ${roleFilter == 'customer' ? 'selected' : ''}>Khách thuê</option>
                        </select>
                    </div>

                    <div class="col-md-2">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="bi bi-funnel me-1"></i> Lọc
                        </button>
                    </div>

                    <div class="col-md-2">
                        <a href="${pageContext.request.contextPath}/user?action=list"
                           class="btn btn-outline-secondary w-100">
                            <i class="bi bi-x-circle me-1"></i> Xóa lọc
                        </a>
                    </div>
                </form>
            </div>
        </div>

        <%-- Users table --%>
        <div class="card table-card shadow-sm">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th class="ps-4">#</th>
                                <th>Người dùng</th>
                                <th>Email</th>
                                <th>Điện thoại</th>
                                <th>Vai trò</th>
                                <th class="text-center pe-4">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty users}">
                                    <tr>
                                        <td colspan="6" class="text-center py-5 text-muted">
                                            <i class="bi bi-people fs-3 d-block mb-2"></i>
                                            Không tìm thấy người dùng nào
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="u" items="${users}" varStatus="st">
                                        <tr>
                                            <td class="ps-4 text-muted small">${st.count}</td>
                                            <td>
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="avatar-sm">
                                                        ${not empty u.fullName ? u.fullName.substring(0,1).toUpperCase() : u.username.substring(0,1).toUpperCase()}
                                                    </div>
                                                    <div>
                                                        <div class="fw-semibold">${u.fullName}</div>
                                                        <div class="text-muted small">@${u.username}</div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="text-muted small">
                                                    ${not empty u.email ? u.email : '—'}
                                                </span>
                                            </td>
                                            <td>
                                                <span class="text-muted small">
                                                    ${not empty u.phone ? u.phone : '—'}
                                                </span>
                                            </td>
                                            <td>
                                                <span class="role-badge
                                                    ${u.role == 'admin' ? 'role-admin' :
                                                      u.role == 'staff' ? 'role-staff' : 'role-customer'}">
                                                    ${u.role == 'admin' ? 'Quản trị viên' :
                                                      u.role == 'staff' ? 'Nhân viên' : 'Khách thuê'}
                                                </span>
                                            </td>
                                            <td class="text-center pe-4">
                                                <a href="${pageContext.request.contextPath}/user?action=edit&id=${u.userId}"
                                                   class="btn btn-sm btn-outline-primary me-1"
                                                   title="Chỉnh sửa">
                                                    <i class="bi bi-pencil"></i>
                                                </a>
                                                <button class="btn btn-sm btn-outline-danger"
                                                        title="Xóa"
                                                        onclick="confirmDelete(${u.userId}, '${u.username}')">
                                                    <i class="bi bi-trash"></i>
                                                </button>
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

    <%-- Pagination --%>
    <c:if test="${totalPages > 1}">
        <div class="d-flex justify-content-between align-items-center mt-3 px-1">
            <div class="text-muted small">
                Showing <strong>${(currentPage - 1) * pageSize + 1}</strong>–<strong>${(currentPage - 1) * pageSize + users.size()}</strong>
                of <strong>${totalItems}</strong>
            </div>
            <nav>
                <ul class="pagination pagination-sm mb-0">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/user?action=list&page=${currentPage - 1}&search=${search}&role=${roleFilter}">
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
                                    <a class="page-link" href="${pageContext.request.contextPath}/user?action=list&page=${p}&search=${search}&role=${roleFilter}">${p}</a>
                                </li>
                            </c:when>
                            <c:when test="${(p == currentPage - 3 && currentPage > 4) || (p == currentPage + 3 && currentPage < totalPages - 3)}">
                                <li class="page-item disabled"><span class="page-link">…</span></li>
                            </c:when>
                        </c:choose>
                    </c:forEach>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/user?action=list&page=${currentPage + 1}&search=${search}&role=${roleFilter}">
                            <i class="bi bi-chevron-right"></i>
                        </a>
                    </li>
                </ul>
            </nav>
        </div>
    </c:if>

    </div>

    <%-- Delete confirm modal --%>
    <div class="modal fade" id="deleteModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold">Xác nhận xóa</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body pt-2">
                    <p class="text-muted">Bạn có chắc muốn xóa người dùng
                        <strong id="deleteUsername"></strong>?
                        Hành động này không thể hoàn tác.
                    </p>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy</button>
                    <a id="deleteConfirmBtn" href="#" class="btn btn-danger">
                        <i class="bi bi-trash me-1"></i> Xóa
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script>
        function confirmDelete(userId, username) {
            document.getElementById('deleteUsername').textContent = username;
            document.getElementById('deleteConfirmBtn').href =
                '${pageContext.request.contextPath}/user?action=delete&id=' + userId;
            new bootstrap.Modal(document.getElementById('deleteModal')).show();
        }
    </script>
<%@ include file="../../footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</main>
</div>
</div>
</body>
</html>
