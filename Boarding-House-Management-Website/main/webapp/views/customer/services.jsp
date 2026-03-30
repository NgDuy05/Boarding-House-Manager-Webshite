<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- Redirect to servlet if accessed directly (no data) --%>
<c:if test="${empty services}">
    <c:redirect url="/services"/>
</c:if>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Services - AKDD House</title>
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

        .svc-card {
            border: none; border-radius: 18px;
            box-shadow: 0 4px 20px rgba(0,0,0,.07);
            transition: transform .2s, box-shadow .2s;
            overflow: hidden; background: #fff;
        }
        .svc-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 36px rgba(0,0,0,.13);
        }
        .svc-img {
            height: 140px; object-fit: cover; width: 100%;
        }
        .svc-img-placeholder {
            height: 140px;
            background: linear-gradient(135deg, #e0f2fe, #dbeafe);
            display: flex; align-items: center; justify-content: center;
            font-size: 2.8rem; color: #3b82f6;
        }
        .svc-name { font-weight: 700; font-size: 1.05rem; color: #1e293b; }
        .svc-desc { font-size: .83rem; color: #64748b; min-height: 36px; }
        .btn-history {
            background: linear-gradient(135deg, #0ea5e9, #6366f1);
            color: #fff; border: none; border-radius: 50px;
            padding: 10px 28px; font-weight: 600;
            text-decoration: none; transition: opacity .2s;
        }
        .btn-history:hover { opacity: .88; color: #fff; }
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
                    <li class="breadcrumb-item active text-white">Services</li>
                </ol>
            </nav>
            <h1><i class="bi bi-grid-3x3-gap me-2"></i>Available Services</h1>
            <p class="mb-0">Explore services available for tenants in AKDD House</p>
        </div>
    </div>

    <div class="container pb-5" style="padding-top: 48px;">

        <%-- Actions bar --%>
        <div class="d-flex align-items-center justify-content-between mb-4">
            <h5 class="fw-bold mb-0" style="color:#1e293b">
                All Services
                <span class="badge bg-primary ms-2 fs-6">${services.size()}</span>
            </h5>
            <c:if test="${not empty sessionScope.user}">
                <a href="${pageContext.request.contextPath}/services?action=myHistory"
                   class="btn-history">
                    <i class="bi bi-clock-history me-1"></i>My Service History
                </a>
            </c:if>
        </div>

        <c:choose>
            <c:when test="${not empty services}">
                <div class="row g-4">
                    <c:forEach var="svc" items="${services}">
                        <div class="col-sm-6 col-lg-4">
                            <div class="svc-card">
                                <c:choose>
                                    <c:when test="${not empty svc.image}">
                                        <img src="${pageContext.request.contextPath}/assets/images/service/${svc.image}"
                                             class="svc-img" alt="${svc.serviceName}"
                                             onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
                                        <div class="svc-img-placeholder" style="display:none">
                                            <i class="bi bi-lightning-charge-fill"></i>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="svc-img-placeholder">
                                            <i class="bi bi-lightning-charge-fill"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                    <div class="p-4">
                                    <div class="svc-name mb-1">${svc.serviceName}</div>
                                    <div class="svc-desc mb-3">
                                        <c:choose>
                                            <c:when test="${not empty svc.description}">${svc.description}</c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="d-flex align-items-center justify-content-between">
                                        <span class="badge bg-light text-dark border small">
                                            <i class="bi bi-tag me-1"></i>Cat. ${svc.categoryId}
                                        </span>
                                        <c:if test="${not empty sessionScope.user}">
                                            <a href="${pageContext.request.contextPath}/services?action=requestForm&serviceId=${svc.serviceId}"
                                               class="btn btn-sm btn-primary">
                                                <i class="bi bi-send me-1"></i>Request
                                            </a>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center py-5 text-muted">
                    <i class="bi bi-inbox fs-1 d-block mb-3 opacity-50"></i>
                    <h5>No services available</h5>
                    <p>Please check back later.</p>
                </div>
            </c:otherwise>
        </c:choose>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        </main>
      </div>
    </div>
</body>
</html>
