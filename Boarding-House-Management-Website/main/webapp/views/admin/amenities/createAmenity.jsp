<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout>

    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/amenity">Amenities</a>
            </li>
            <li class="breadcrumb-item active">Add New Amenity</li>
        </ol>
    </nav>

    <div class="row justify-content-center">
        <div class="col-lg-6">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white border-bottom py-3">
                    <h5 class="mb-0 fw-semibold">
                        <i class="bi bi-plus-circle text-info me-2"></i>Add New Amenity
                    </h5>
                </div>
                <div class="card-body p-4">
                    <div class="alert alert-light border-info border-start border-4 mb-4">
                        <small class="text-muted">
                            <i class="bi bi-info-circle me-1 text-info"></i>
                            <strong>Amenities</strong> are room features that improve comfort but are
                            <strong>NOT billed by usage</strong> — e.g. Balcony, Private Bathroom, Kitchen, Hot Water.
                        </small>
                    </div>

                    <form method="post" action="${pageContext.request.contextPath}/amenity">
                        <input type="hidden" name="action" value="insert">

                        <div class="mb-3">
                            <label class="form-label fw-semibold">
                                Amenity Name <span class="text-danger">*</span>
                            </label>
                            <input type="text" name="amenityName" class="form-control"
                                   placeholder="e.g. Balcony" required>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-semibold">Description</label>
                            <textarea name="description" class="form-control" rows="3"
                                      placeholder="Short description of this amenity..."></textarea>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary px-4">
                                <i class="bi bi-check-circle me-1"></i>Save
                            </button>
                            <a href="${pageContext.request.contextPath}/amenity"
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
