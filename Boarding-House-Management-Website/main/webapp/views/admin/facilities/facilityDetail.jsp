<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<t:layout>

    <div class="d-flex align-items-center gap-2 mb-4">
        <a href="${pageContext.request.contextPath}/facility"
           class="btn btn-sm btn-outline-secondary"><i class="bi bi-arrow-left"></i></a>
        <h4 class="mb-0"><i class="bi bi-wrench me-2"></i>Facility Detail</h4>
    </div>

    <c:if test="${empty facility}">
        <div class="alert alert-danger">Facility not found.</div>
    </c:if>

    <c:if test="${not empty facility}">
        <div class="card shadow-sm border-0 mb-3" style="max-width:640px;">
            <div class="card-header bg-white fw-semibold">
                <i class="bi bi-wrench me-2"></i>${facility.facilityName}
            </div>
            <div class="card-body">
                <c:if test="${not empty facility.image}">
                    <img src="${pageContext.request.contextPath}/${facility.image}"
                         class="img-fluid rounded mb-3" style="max-height:200px; object-fit:cover;"
                         alt="${facility.facilityName}">
                </c:if>
                <div class="row g-3">
                    <div class="col-sm-6">
                        <div class="text-muted small">Facility ID</div>
                        <div class="fw-semibold">${facility.facilityId}</div>
                    </div>
                    <div class="col-sm-6">
                        <div class="text-muted small">Category ID</div>
                        <div class="fw-semibold">${facility.categoryId}</div>
                    </div>
                    <div class="col-12">
                        <div class="text-muted small">Description</div>
                        <div>${not empty facility.description ? facility.description : '—'}</div>
                    </div>
                </div>
            </div>
        </div>

        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/facility?action=edit&id=${facility.facilityId}"
               class="btn btn-primary btn-sm"><i class="bi bi-pencil me-1"></i>Edit</a>
            <a href="${pageContext.request.contextPath}/facility?action=delete&id=${facility.facilityId}"
               class="btn btn-danger btn-sm"
               onclick="return confirm('Delete this facility?')">
                <i class="bi bi-trash me-1"></i>Delete
            </a>
        </div>
    </c:if>

</t:layout>
