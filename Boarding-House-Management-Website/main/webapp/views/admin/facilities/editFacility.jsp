<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<t:layout>

    <div class="d-flex align-items-center gap-2 mb-4">
        <a href="${pageContext.request.contextPath}/facility"
           class="btn btn-sm btn-outline-secondary"><i class="bi bi-arrow-left"></i></a>
        <h4 class="mb-0"><i class="bi bi-pencil-square me-2"></i>Edit Facility</h4>
    </div>

    <c:if test="${empty facility}">
        <div class="alert alert-danger">Facility not found.</div>
    </c:if>

    <c:if test="${not empty facility}">
        <div class="card shadow-sm border-0" style="max-width:560px;">
            <div class="card-body">
                <form method="post" action="${pageContext.request.contextPath}/facility">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="facilityId" value="${facility.facilityId}">

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Facility Name <span class="text-danger">*</span></label>
                        <input type="text" name="facilityName" class="form-control" required
                               value="${facility.facilityName}">
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Category ID <span class="text-danger">*</span></label>
                        <input type="number" name="categoryId" class="form-control" required
                               value="${facility.categoryId}" min="1">
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Description</label>
                        <textarea name="description" class="form-control" rows="3">${facility.description}</textarea>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-semibold">Image URL</label>
                        <input type="text" name="image" class="form-control"
                               value="${facility.image}">
                    </div>

                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-check-lg me-1"></i>Save Changes
                        </button>
                        <a href="${pageContext.request.contextPath}/facility"
                           class="btn btn-outline-secondary">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </c:if>

</t:layout>
