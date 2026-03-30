<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<t:layout>

    <div class="d-flex align-items-center gap-2 mb-4">
        <a href="${pageContext.request.contextPath}/price?action=categories"
           class="btn btn-sm btn-outline-secondary"><i class="bi bi-arrow-left"></i></a>
        <h4 class="mb-0"><i class="bi bi-pencil-square me-2"></i>Edit Price Category</h4>
    </div>

    <c:if test="${empty category}">
        <div class="alert alert-danger">Price category not found.</div>
    </c:if>

    <c:if test="${not empty category}">
        <div class="card shadow-sm border-0" style="max-width:520px;">
            <div class="card-body">
                <form method="post" action="${pageContext.request.contextPath}/price">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="categoryId" value="${category.categoryId}">

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Category Code <span class="text-danger">*</span></label>
                        <input type="text" name="categoryCode" class="form-control" required
                               value="${category.categoryCode}">
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Category Type <span class="text-danger">*</span></label>
                        <select name="categoryType" class="form-select" required>
                            <option value="rent"     ${category.categoryType == 'rent'     ? 'selected' : ''}>Rent</option>
                            <option value="utility"  ${category.categoryType == 'utility'  ? 'selected' : ''}>Utility</option>
                            <option value="service"  ${category.categoryType == 'service'  ? 'selected' : ''}>Service</option>
                            <option value="facility" ${category.categoryType == 'facility' ? 'selected' : ''}>Facility</option>
                        </select>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-semibold">Unit</label>
                        <input type="text" name="unit" class="form-control"
                               value="${category.unit}" placeholder="e.g. month, kWh, m3">
                    </div>

                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-check-lg me-1"></i>Save Changes
                        </button>
                        <a href="${pageContext.request.contextPath}/price?action=categories"
                           class="btn btn-outline-secondary">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </c:if>

</t:layout>
