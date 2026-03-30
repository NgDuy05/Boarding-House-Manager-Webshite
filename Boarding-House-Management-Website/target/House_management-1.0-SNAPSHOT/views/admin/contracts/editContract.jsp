<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Contract - AKDD House</title>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body { background-color:#f4f6f9; }
        .page-header { background:linear-gradient(135deg,#1a1a2e,#16213e,#0f3460); color:white; border-radius:12px; padding:18px 24px; margin-bottom:24px; }
        .form-card { border-radius:16px; border:none; }
        .section-title { font-size:12px; font-weight:700; text-transform:uppercase; letter-spacing:.5px; color:#6c757d; margin-bottom:12px; }
        .form-control:focus,.form-select:focus { border-color:#0f3460; box-shadow:0 0 0 .2rem rgba(15,52,96,.2); }
        .btn-save { background:linear-gradient(135deg,#1a1a2e,#0f3460); border:none; color:white; }
        .btn-save:hover { opacity:.9; color:white; }
    </style>
</head>
<body>
<%@ include file="../../navbar.jsp" %>

<div class="container-fluid">
<div class="row flex-nowrap admin-layout-row">
<%@ include file="../sidebar.jsp" %>
<main class="col admin-main px-4 py-4"><div style="max-width:680px">

    <div class="page-header d-flex align-items-center gap-3">
        <div class="rounded-circle bg-white bg-opacity-25 d-flex align-items-center justify-content-center" style="width:52px;height:52px;font-size:22px">
            <i class="bi bi-pencil-square"></i>
        </div>
        <div>
            <h4 class="mb-0 fw-bold">Update Contract</h4>
            <small class="opacity-75">Contract #${contract.contractId} &middot; Room ${contract.roomNumber}</small>
        </div>
        <a href="${pageContext.request.contextPath}/contract?action=detail&id=${contract.contractId}" class="btn btn-light btn-sm ms-auto">
            <i class="bi bi-arrow-left me-1"></i>Back
        </a>
    </div>

    <form action="${pageContext.request.contextPath}/contract" method="post">
        <input type="hidden" name="action"     value="update">
        <input type="hidden" name="contractId" value="${contract.contractId}">
        <input type="hidden" name="roomId"     value="${contract.roomId}">

        <div class="card form-card shadow-sm mb-3">
            <div class="card-body p-4">
                <div class="section-title"><i class="bi bi-house me-1"></i>Room Info</div>
                <div class="d-flex gap-3 p-3 bg-light rounded-3">
                    <div>
                        <div class="fw-bold fs-5">Room ${contract.roomNumber}</div>
                        <div class="text-muted small">${contract.categoryName}</div>
                    </div>
                    <div class="ms-auto text-end">
                        <div class="text-success fw-semibold">${contract.basePrice}đ/month</div>
                        <span class="badge bg-${contract.statusColor}-subtle text-${contract.statusColor} border border-${contract.statusColor}-subtle rounded-pill mt-1">${contract.statusLabel}</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="card form-card shadow-sm mb-3">
            <div class="card-body p-4">
                <div class="section-title"><i class="bi bi-calendar3 me-1"></i>Contract Terms</div>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Start Date <span class="text-danger">*</span></label>
                        <input type="date" name="startDate" class="form-control" required value="${contract.startDate}">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">End Date <span class="text-muted fw-normal">(optional)</span></label>
                        <input type="date" name="endDate" class="form-control" value="${contract.endDate}">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Deposit (đ) <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-cash"></i></span>
                            <input type="number" name="deposit" class="form-control" value="${contract.deposit}" min="0" required>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Status</label>
                        <select name="status" class="form-select">
                            <option value="active"     ${contract.status == 'active'     ? 'selected' : ''}>Active</option>
                            <option value="terminated" ${contract.status == 'terminated' ? 'selected' : ''}>Terminated</option>
                            <option value="expired"    ${contract.status == 'expired'    ? 'selected' : ''}>Expired</option>
                        </select>
                    </div>
                </div>
            </div>
        </div>

        <div class="d-flex gap-2">
            <button type="submit" class="btn btn-save flex-fill fw-semibold py-2">
                <i class="bi bi-check-circle me-1"></i>Save Changes
            </button>
            <a href="${pageContext.request.contextPath}/contract?action=detail&id=${contract.contractId}" class="btn btn-outline-secondary flex-fill fw-semibold py-2">
                <i class="bi bi-x-circle me-1"></i>Cancel
            </a>
        </div>
    </form>
</div>
</div>
<%@ include file="../../footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</main>
</div>
</div>
</body>
</html>
