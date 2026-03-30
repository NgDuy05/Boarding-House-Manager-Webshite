<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout>

    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/utility">Utilities</a>
            </li>
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/utility?action=detail&id=${utilityPrice.utilityId}">
                    ${utilityPrice.utilityName}
                </a>
            </li>
            <li class="breadcrumb-item active">Edit Price</li>
        </ol>
    </nav>

    <div class="row justify-content-center">
        <div class="col-lg-5">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white border-bottom py-3">
                    <h5 class="mb-0 fw-semibold">
                        <i class="bi bi-pencil text-warning me-2"></i>Edit Price — ${utilityPrice.utilityName}
                    </h5>
                </div>
                <div class="card-body p-4">
                    <form method="post" action="${pageContext.request.contextPath}/utility">
                        <input type="hidden" name="action" value="updatePrice">
                        <input type="hidden" name="priceId" value="${utilityPrice.priceId}">
                        <input type="hidden" name="utilityId" value="${utilityPrice.utilityId}">

                        <div class="mb-3">
                            <label class="form-label fw-semibold">
                                Price (VND) <span class="text-danger">*</span>
                            </label>
                            <input type="number" name="price" class="form-control"
                                   value="${utilityPrice.price}" min="0" step="0.01" required>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-semibold">
                                Effective From <span class="text-danger">*</span>
                            </label>
                            <input type="date" name="effectiveFrom" class="form-control"
                                   value="${utilityPrice.effectiveFrom}" required>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-warning px-4">
                                <i class="bi bi-check-circle me-1"></i>Update
                            </button>
                            <a href="${pageContext.request.contextPath}/utility?action=detail&id=${utilityPrice.utilityId}"
                               class="btn btn-outline-secondary px-4">
                                <i class="bi bi-x-circle me-1"></i>Cancel
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

</t:layout>
