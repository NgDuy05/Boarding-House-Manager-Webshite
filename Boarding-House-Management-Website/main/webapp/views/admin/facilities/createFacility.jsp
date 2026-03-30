<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<t:layout>

    <div class="d-flex align-items-center gap-2 mb-4">
        <a href="${pageContext.request.contextPath}/facility"
           class="btn btn-sm btn-outline-secondary"><i class="bi bi-arrow-left"></i></a>
        <h4 class="mb-0"><i class="bi bi-wrench me-2"></i>Add Facility</h4>
    </div>

    <div class="card shadow-sm border-0" style="max-width:560px;">
        <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/facility">
                <input type="hidden" name="action" value="create">

                <div class="mb-3">
                    <label class="form-label fw-semibold">Facility Name <span class="text-danger">*</span></label>
                    <input type="text" name="facilityName" class="form-control" required
                           placeholder="e.g. Parking lot">
                </div>

                <div class="mb-3">
                    <label class="form-label fw-semibold">Category ID <span class="text-danger">*</span></label>
                    <input type="number" name="categoryId" class="form-control" required min="1">
                </div>

                <div class="mb-3">
                    <label class="form-label fw-semibold">Description</label>
                    <textarea name="description" class="form-control" rows="3"
                              placeholder="Short description…"></textarea>
                </div>

                <div class="mb-4">
                    <label class="form-label fw-semibold">Image URL</label>
                    <input type="text" name="image" class="form-control"
                           placeholder="assets/images/…">
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-plus-lg me-1"></i>Create
                    </button>
                    <a href="${pageContext.request.contextPath}/facility"
                       class="btn btn-outline-secondary">Cancel</a>
                </div>
            </form>
        </div>
    </div>

</t:layout>
