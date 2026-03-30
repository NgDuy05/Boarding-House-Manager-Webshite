<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Request Service - AKDD House</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { background: #f4f6f9; font-family: 'Inter', sans-serif; }

        .page-hero {
            background: linear-gradient(135deg, #7c3aed, #4f46e5);
            color: #fff; padding: 40px 0 52px; margin-bottom: -28px;
        }
        .page-hero h1 { font-weight: 700; font-size: 1.8rem; }

        .form-card {
            border: none; border-radius: 20px;
            box-shadow: 0 6px 30px rgba(0,0,0,.09);
            background: #fff;
        }
        .form-card .card-header {
            background: transparent; border-bottom: 1px solid #f1f5f9;
            padding: 1.4rem 1.8rem 1rem;
        }

        .svc-option {
            border: 2px solid #e2e8f0; border-radius: 12px;
            padding: 14px 16px; cursor: pointer;
            transition: border-color .2s, background .2s;
            display: flex; align-items: center; gap: 12px;
            margin-bottom: 10px;
        }
        .svc-option:hover { border-color: #7c3aed; background: #faf5ff; }
        .svc-option input[type="radio"] { accent-color: #7c3aed; width: 18px; height: 18px; }
        .svc-option.selected { border-color: #7c3aed; background: #faf5ff; }
        .svc-icon {
            width: 40px; height: 40px; border-radius: 10px;
            background: #ede9fe; color: #7c3aed;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.1rem; flex-shrink: 0;
        }
        .svc-label { font-weight: 600; color: #1e293b; }
        .svc-desc  { font-size: .78rem; color: #94a3b8; }

        .contract-badge {
            background: #d1fae5; color: #065f46;
            border-radius: 50px; padding: 6px 16px;
            font-size: .82rem; font-weight: 600;
            display: inline-flex; align-items: center; gap: .4rem;
        }
        .no-contract {
            background: #fee2e2; color: #991b1b;
            border-radius: 12px; padding: 14px 18px;
            display: flex; align-items: center; gap: 10px;
        }
        .step-number {
            width: 28px; height: 28px; border-radius: 50%;
            background: #7c3aed; color: #fff;
            display: inline-flex; align-items: center; justify-content: center;
            font-size: .8rem; font-weight: 700; flex-shrink: 0;
        }
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
                    <li class="breadcrumb-item active text-white">Request Service</li>
                </ol>
            </nav>
            <h1><i class="bi bi-send me-2"></i>Request a Service</h1>
            <p class="mb-0">Submit a service request — our staff will review and approve it shortly</p>
        </div>
    </div>

    <div class="container pb-5" style="padding-top: 42px;">
        <div class="row justify-content-center">
            <div class="col-lg-7">

                <%-- Alert: URL param errors --%>
                <c:if test="${param.error == 'nocontract'}">
                    <div class="alert alert-danger d-flex align-items-center gap-2 mb-4">
                        <i class="bi bi-exclamation-circle-fill fs-5"></i>
                        <span>Bạn chưa có hợp đồng thuê phòng đang hoạt động. Vui lòng liên hệ quản lý.</span>
                    </div>
                </c:if>
                <c:if test="${param.error == 'failed'}">
                    <div class="alert alert-danger d-flex align-items-center gap-2 mb-4">
                        <i class="bi bi-x-circle-fill fs-5"></i>
                        <span>Gửi yêu cầu thất bại. Vui lòng thử lại.</span>
                    </div>
                </c:if>
                <c:if test="${param.success == 'requested'}">
                    <div class="alert alert-success d-flex align-items-center gap-2 mb-4">
                        <i class="bi bi-check-circle-fill fs-5"></i>
                        <span>Yêu cầu đã được gửi thành công! Chúng tôi sẽ xem xét và phản hồi sớm.</span>
                    </div>
                </c:if>

                <%-- No contract error --%>
                <c:if test="${not empty errorMsg}">
                    <div class="no-contract mb-4">
                        <i class="bi bi-exclamation-triangle-fill text-danger fs-5"></i>
                        <div>
                            <div class="fw-semibold">Không thể đặt dịch vụ</div>
                            <div class="small">${errorMsg}</div>
                        </div>
                    </div>
                </c:if>

                <c:if test="${empty errorMsg}">

                    <%-- Contract info --%>
                    <div class="d-flex align-items-center gap-3 mb-4">
                        <span class="contract-badge">
                            <i class="bi bi-file-earmark-check-fill"></i>
                            Hợp đồng #${contractId} đang hoạt động
                        </span>
                    </div>

                    <%-- Form --%>
                    <div class="form-card">
                        <div class="card-header">
                            <h5 class="fw-bold mb-0">
                                <i class="bi bi-send-fill text-primary me-2"></i>Điền thông tin yêu cầu
                            </h5>
                        </div>
                        <div class="p-4">
                            <form method="post" action="${pageContext.request.contextPath}/services">
                                <input type="hidden" name="action" value="submitRequest">

                                <%-- Step 1: Choose service --%>
                                <div class="d-flex align-items-center gap-2 mb-3">
                                    <span class="step-number">1</span>
                                    <span class="fw-semibold">Chọn dịch vụ <span class="text-danger">*</span></span>
                                </div>

                                <div class="mb-4">
                                    <c:forEach var="svc" items="${services}">
                                        <label class="svc-option w-100" id="label_${svc.serviceId}">
                                            <input type="radio" name="serviceId"
                                                   value="${svc.serviceId}"
                                                   onchange="updateSelected(this)"
                                                   ${svc.serviceId == preselectedId ? 'checked' : ''}
                                                   required>
                                            <div class="svc-icon">
                                                <i class="bi bi-lightning-charge-fill"></i>
                                            </div>
                                            <div>
                                                <div class="svc-label">${svc.serviceName}</div>
                                                <div class="svc-desc">
                                                    <c:choose>
                                                        <c:when test="${not empty svc.description}">${svc.description}</c:when>
                                                        <c:otherwise>—</c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </label>
                                    </c:forEach>
                                </div>

                                <%-- Step 2: Quantity & Date --%>
                                <div class="d-flex align-items-center gap-2 mb-3">
                                    <span class="step-number">2</span>
                                    <span class="fw-semibold">Số lượng & Ngày sử dụng</span>
                                </div>

                                <div class="row g-3 mb-4">
                                    <div class="col-md-6">
                                        <label class="form-label small fw-semibold text-muted">Số lượng</label>
                                        <input type="number" name="quantity" class="form-control form-control-lg"
                                               value="1" min="1" step="1" required>
                                        <div class="form-text">Nhập số lượng sử dụng (mặc định 1 tháng)</div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label small fw-semibold text-muted">Ngày bắt đầu</label>
                                        <input type="date" name="usageDate" class="form-control form-control-lg"
                                               id="usageDateInput" required>
                                    </div>
                                </div>

                                <%-- Step 3: Submit --%>
                                <div class="d-flex align-items-center gap-2 mb-3">
                                    <span class="step-number">3</span>
                                    <span class="fw-semibold">Xác nhận & Gửi</span>
                                </div>

                                <div class="alert alert-light border d-flex gap-2 align-items-start mb-4">
                                    <i class="bi bi-info-circle text-primary mt-1"></i>
                                    <div class="small text-muted">
                                        Yêu cầu sẽ được gửi cho admin xét duyệt. Sau khi được duyệt, chi phí dịch vụ
                                        sẽ được tính vào hóa đơn tháng của bạn.
                                    </div>
                                </div>

                                <div class="d-flex gap-2">
                                    <button type="submit" class="btn btn-primary btn-lg px-5">
                                        <i class="bi bi-send me-2"></i>Gửi yêu cầu
                                    </button>
                                    <a href="${pageContext.request.contextPath}/services"
                                       class="btn btn-outline-secondary btn-lg px-4">
                                        Hủy
                                    </a>
                                </div>
                            </form>
                        </div>
                    </div>

                </c:if>

            </div>

            <%-- Sidebar: My recent requests --%>
            <div class="col-lg-4 d-none d-lg-block">
                <div class="form-card p-4">
                    <h6 class="fw-bold mb-3">
                        <i class="bi bi-info-circle text-primary me-2"></i>Lưu ý
                    </h6>
                    <ul class="list-unstyled small text-muted">
                        <li class="mb-2">
                            <i class="bi bi-check2 text-success me-2"></i>
                            Yêu cầu cần được admin duyệt trước khi có hiệu lực
                        </li>
                        <li class="mb-2">
                            <i class="bi bi-check2 text-success me-2"></i>
                            Chi phí tính theo đơn giá hiện hành của dịch vụ
                        </li>
                        <li class="mb-2">
                            <i class="bi bi-check2 text-success me-2"></i>
                            Có thể theo dõi trạng thái tại "My Service History"
                        </li>
                        <li class="mb-2">
                            <i class="bi bi-clock text-warning me-2"></i>
                            Thời gian duyệt thường trong vòng 1 ngày làm việc
                        </li>
                    </ul>
                    <hr>
                    <a href="${pageContext.request.contextPath}/services?action=myHistory"
                       class="btn btn-outline-primary btn-sm w-100">
                        <i class="bi bi-clock-history me-1"></i>Xem lịch sử của tôi
                    </a>
                </div>
            </div>

        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Set default date to today
        document.getElementById('usageDateInput').valueAsDate = new Date();

        // Highlight selected service option
        function updateSelected(radio) {
            document.querySelectorAll('.svc-option').forEach(function(el) {
                el.classList.remove('selected');
            });
            radio.closest('.svc-option').classList.add('selected');
        }

        // Pre-highlight on load
        document.querySelectorAll('input[name="serviceId"]:checked').forEach(function(r) {
            r.closest('.svc-option').classList.add('selected');
        });
    </script>
        </main>
      </div>
    </div>
</body>
</html>
