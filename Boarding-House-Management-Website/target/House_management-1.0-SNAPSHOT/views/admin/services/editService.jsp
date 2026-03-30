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
            <li class="breadcrumb-item active">Edit Service</li>
        </ol>
    </nav>

    <div class="row justify-content-center">
        <div class="col-lg-7">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white border-bottom py-3">
                    <h5 class="mb-0 fw-semibold">
                        <i class="bi bi-pencil text-warning me-2"></i>Edit Service — ${service.serviceName}
                    </h5>
                </div>
                <div class="card-body p-4">
                    <form method="post" action="${pageContext.request.contextPath}/services">
                        <input type="hidden" name="action"    value="update">
                        <input type="hidden" name="serviceId" value="${service.serviceId}">

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Service Name <span class="text-danger">*</span></label>
                            <input type="text" name="serviceName" class="form-control"
                                   value="${service.serviceName}" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Price Category <span class="text-danger">*</span></label>
                            <select name="categoryId" class="form-select" required>
                                <option value="">-- Select Category --</option>
                                <c:forEach var="cat" items="${priceCategories}">
                                    <option value="${cat.categoryId}"
                                        ${cat.categoryId == service.categoryId ? 'selected' : ''}>
                                        ${cat.categoryCode} (${cat.unit})
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Description</label>
                            <textarea name="description" class="form-control" rows="3">${service.description}</textarea>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-semibold">Image filename</label>
                            <input type="text" name="image" class="form-control"
                                   value="${service.image}">
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-warning px-4">
                                <i class="bi bi-check-circle me-1"></i>Update Service
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
