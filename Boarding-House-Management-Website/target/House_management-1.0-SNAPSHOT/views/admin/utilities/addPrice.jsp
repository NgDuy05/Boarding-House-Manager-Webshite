<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout>

    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/utility">Utilities</a>
            </li>
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/utility?action=detail&id=${utility.utilityId}">
                    ${utility.utilityName}
                </a>
            </li>
            <li class="breadcrumb-item active">Add Price</li>
        </ol>
    </nav>

    <div class="row justify-content-center">
        <div class="col-lg-5">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white border-bottom py-3">
                    <h5 class="mb-0 fw-semibold">
                        <i class="bi bi-plus-circle text-success me-2"></i>Add Price — ${utility.utilityName}
                    </h5>
                </div>
                <div class="card-body p-4">
                    <form method="post" action="${pageContext.request.contextPath}/utility">
                        <input type="hidden" name="action" value="insertPrice">
                        <input type="hidden" name="utilityId" value="${utility.utilityId}">

                        <div class="mb-3">
                            <label class="form-label fw-semibold">
                                Price (VND / ${utility.unit}) <span class="text-danger">*</span>
                            </label>
                            <input type="number" name="price" class="form-control"
                                   placeholder="e.g. 3500" min="0" step="0.01" required>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-semibold">
                                Effective From <span class="text-danger">*</span>
                            </label>
                            <input type="date" name="effectiveFrom" class="form-control" required>
                            <div class="form-text">The date from which this price takes effect.</div>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-success px-4">
                                <i class="bi bi-check-circle me-1"></i>Save Price
                            </button>
                            <a href="${pageContext.request.contextPath}/utility?action=detail&id=${utility.utilityId}"
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
