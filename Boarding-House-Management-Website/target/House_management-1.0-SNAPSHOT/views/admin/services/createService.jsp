<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<t:layout>

    <%-- Breadcrumb --%>
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/services?action=adminList">Services</a>
            </li>
            <li class="breadcrumb-item active">Add New Service</li>
        </ol>
    </nav>

    <div class="row justify-content-center">
        <div class="col-lg-7">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white border-bottom py-3">
                    <h5 class="mb-0 fw-semibold">
                        <i class="bi bi-plus-circle text-primary me-2"></i>Add New Service
                    </h5>
                </div>
                <div class="card-body p-4">
                    <form method="post" action="${pageContext.request.contextPath}/services">
                        <input type="hidden" name="action" value="insert">

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Service Name <span class="text-danger">*</span></label>
                            <input type="text" name="serviceName" class="form-control"
                                   placeholder="e.g. Wifi Internet" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Price Category <span class="text-danger">*</span></label>
                            <select name="categoryId" class="form-select" required>
                                <option value="">-- Select Category --</option>
                                <c:forEach var="cat" items="${priceCategories}">
                                    <option value="${cat.categoryId}">
                                        ${cat.categoryCode} (${cat.unit})
                                    </option>
                                </c:forEach>
                            </select>
                            <div class="form-text">Link to the pricing category for billing purposes.</div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Description</label>
                            <textarea name="description" class="form-control" rows="3"
                                      placeholder="Short description of the service..."></textarea>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-semibold">Image filename</label>
                            <input type="text" name="image" class="form-control"
                                   placeholder="service.jpg" value="service.jpg">
                            <div class="form-text">Leave default or enter a filename from <code>assets/images/service/</code>.</div>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary px-4">
                                <i class="bi bi-check-circle me-1"></i>Save Service
                            </button>
                            <a href="${pageContext.request.contextPath}/services?action=adminList"
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
