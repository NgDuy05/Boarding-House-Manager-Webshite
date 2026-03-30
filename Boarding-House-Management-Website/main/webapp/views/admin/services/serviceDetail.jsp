<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<t:layout>

    <div class="d-flex align-items-center gap-2 mb-4">
        <a href="${pageContext.request.contextPath}/services?action=adminList"
           class="btn btn-sm btn-outline-secondary"><i class="bi bi-arrow-left"></i></a>
        <h4 class="mb-0"><i class="bi bi-grid me-2"></i>Service Detail</h4>
    </div>

    <c:if test="${empty service}">
        <div class="alert alert-danger">Service not found.</div>
    </c:if>

    <c:if test="${not empty service}">
        <div class="card shadow-sm border-0 mb-3" style="max-width:640px;">
            <div class="card-header bg-white fw-semibold">
                <i class="bi bi-grid me-2"></i>${service.serviceName}
            </div>
            <div class="card-body">
                <c:if test="${not empty service.image}">
                    <img src="${pageContext.request.contextPath}/${service.image}"
                         class="img-fluid rounded mb-3" style="max-height:200px; object-fit:cover;"
                         alt="${service.serviceName}">
                </c:if>
                <div class="row g-3">
                    <div class="col-sm-6">
                        <div class="text-muted small">Service ID</div>
                        <div class="fw-semibold">${service.serviceId}</div>
                    </div>
                    <div class="col-sm-6">
                        <div class="text-muted small">Category ID</div>
                        <div class="fw-semibold">${service.categoryId}</div>
                    </div>
                    <div class="col-sm-6">
                        <div class="text-muted small">Price</div>
                        <div class="fw-semibold text-primary">
                            <c:if test="${not empty service.price}">
                                <fmt:formatNumber value="${service.price}" groupingUsed="true" maxFractionDigits="0"/>&#8363;
                            </c:if>
                        </div>
                    </div>
                    <div class="col-12">
                        <div class="text-muted small">Description</div>
                        <div>${not empty service.description ? service.description : '—'}</div>
                    </div>
                </div>
            </div>
        </div>

        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/services?action=edit&id=${service.serviceId}"
               class="btn btn-primary btn-sm"><i class="bi bi-pencil me-1"></i>Edit</a>
            <a href="${pageContext.request.contextPath}/services?action=delete&id=${service.serviceId}"
               class="btn btn-danger btn-sm"
               onclick="return confirm('Delete this service?')">
                <i class="bi bi-trash me-1"></i>Delete
            </a>
        </div>
    </c:if>

</t:layout>
