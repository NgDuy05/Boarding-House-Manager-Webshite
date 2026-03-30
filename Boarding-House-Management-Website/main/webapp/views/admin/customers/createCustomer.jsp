<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add Customer - AKDD House</title>
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
            padding: 18px 24px;
            margin-bottom: 24px;
        }
        .form-control:focus, .form-select:focus {
            border-color: #11998e;
            box-shadow: 0 0 0 0.2rem rgba(17,153,142,0.2);
        }
        .btn-save {
            background: linear-gradient(135deg, #11998e, #38ef7d);
            border: none; color: white;
        }
        .btn-save:hover { opacity: 0.9; color: white; }
        .form-card { border-radius: 16px; border: none; }
        .section-title {
            font-size: 12px; font-weight: 700;
            text-transform: uppercase; letter-spacing: .5px;
            color: #6c757d; margin-bottom: 12px;
        }
    </style>
</head>
<body>
    <%@ include file="../../navbar.jsp" %>

<div class="container-fluid">
<div class="row flex-nowrap admin-layout-row">
<%@ include file="../sidebar.jsp" %>
<main class="col admin-main px-4 py-4"><div style="max-width:660px">

        <c:if test="${not empty sessionScope.customerError}">
            <div class="alert alert-danger alert-dismissible fade show">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${sessionScope.customerError}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% session.removeAttribute("customerError"); %>
        </c:if>

        <div class="page-header d-flex align-items-center gap-3">
            <div class="rounded-circle bg-white bg-opacity-25 d-flex align-items-center justify-content-center"
                 style="width:56px;height:56px;font-size:24px">
                <i class="bi bi-person-plus-fill"></i>
            </div>
            <div>
                <h4 class="mb-0 fw-bold">Add New Customer</h4>
                <small class="opacity-75">Create a new tenant account</small>
            </div>
            <a href="${pageContext.request.contextPath}/manage-customer"
               class="btn btn-light btn-sm ms-auto">
                <i class="bi bi-arrow-left me-1"></i>Back
            </a>
        </div>

        <form action="${pageContext.request.contextPath}/manage-customer" method="post" novalidate>
            <input type="hidden" name="action" value="insert">

            <div class="card form-card shadow-sm mb-3">
                <div class="card-body p-4">
                    <div class="section-title"><i class="bi bi-person me-1"></i>Basic Information</div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Username <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-at"></i></span>
                            <input type="text" name="username" class="form-control"
                                   placeholder="Enter username" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Password <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-lock"></i></span>
                            <input type="password" name="password" id="pwdInput" class="form-control"
                                   placeholder="Enter password" required>
                            <button class="btn btn-outline-secondary" type="button" onclick="togglePwd()">
                                <i class="bi bi-eye" id="eyeIcon"></i>
                            </button>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Full Name <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-person"></i></span>
                            <input type="text" name="fullName" class="form-control"
                                   placeholder="Enter full name" required>
                        </div>
                    </div>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Email</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                                <input type="email" name="email" class="form-control" placeholder="Email address">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Phone</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                                <input type="tel" name="phone" class="form-control" placeholder="Phone number">
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="d-flex gap-2">
                <button type="submit" class="btn btn-save flex-fill fw-semibold">
                    <i class="bi bi-check-circle me-1"></i>Create Account
                </button>
                <a href="${pageContext.request.contextPath}/manage-customer"
                   class="btn btn-outline-secondary flex-fill fw-semibold">
                    <i class="bi bi-x-circle me-1"></i>Cancel
                </a>
            </div>
        </form>
    </div>

    <script>
        function togglePwd() {
            var input = document.getElementById('pwdInput');
            var icon  = document.getElementById('eyeIcon');
            input.type = input.type === 'password' ? 'text' : 'password';
            icon.classList.toggle('bi-eye');
            icon.classList.toggle('bi-eye-slash');
        }
    </script>
</div>
<%@ include file="../../footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</main>
</div>
</div>
</body>
</html>
