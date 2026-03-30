<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<t:layout>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2><i class="bi bi-shield-check me-2"></i>Room Amenities</h2>
        <a href="${pageContext.request.contextPath}/facility?action=create"
           class="btn btn-primary">
            <i class="bi bi-plus-circle me-1"></i> Add Amenity
        </a>
    </div>

    <c:choose>
        <c:when test="${not empty facilities}">
            <div class="row row-cols-1 row-cols-md-3 g-4">
                <c:forEach var="facility" items="${facilities}">
                    <div class="col">
                        <div class="card h-100 shadow-sm">

                            <c:choose>
                                <c:when test="${not empty facility.image}">
                                    <img src="${pageContext.request.contextPath}/${facility.image}"
                                         class="card-img-top"
                                         alt="${facility.facilityName}"
                                         style="height: 180px; object-fit: cover;">
                                </c:when>
                                <c:otherwise>
                                    <div class="card-img-top bg-light d-flex align-items-center justify-content-center"
                                         style="height: 180px;">
                                        <i class="bi bi-image text-secondary fs-1"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>

                            <div class="card-body">
                                <h5 class="card-title">${facility.facilityName}</h5>
                                <p class="card-text text-muted small">
                                    <c:choose>
                                        <c:when test="${not empty facility.description}">
                                            ${facility.description}
                                        </c:when>
                                        <c:otherwise>
                                            <em>No description</em>
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                                <p class="card-text">
                                    <small class="text-secondary">
                                        <i class="bi bi-tag me-1"></i>Category ID: ${facility.categoryId}
                                    </small>
                                </p>
                            </div>

                            <div class="card-footer bg-transparent d-flex gap-2">
                                <a href="${pageContext.request.contextPath}/facility?action=detail&id=${facility.facilityId}"
                                   class="btn btn-sm btn-info flex-fill">
                                    <i class="bi bi-eye"></i> Detail
                                </a>
                                <a href="${pageContext.request.contextPath}/facility?action=edit&id=${facility.facilityId}"
                                   class="btn btn-sm btn-warning flex-fill">
                                    <i class="bi bi-pencil"></i> Edit
                                </a>
                                <a href="${pageContext.request.contextPath}/facility?action=delete&id=${facility.facilityId}"
                                   class="btn btn-sm btn-danger flex-fill"
                                   onclick="return confirm('Delete this amenity?')">
                                    <i class="bi bi-trash"></i> Delete
                                </a>
                            </div>

                        </div>
                    </div>
                </c:forEach>
            </div>

            <div class="mt-3 text-muted">
                Total: <strong>${facilities.size()}</strong> amenity(ies)
            </div>
        </c:when>

        <c:otherwise>
            <div class="text-center text-muted py-5">
                <i class="bi bi-inbox fs-1 d-block mb-3"></i>
                <p>No amenities found.</p>
                <a href="${pageContext.request.contextPath}/facility?action=create"
                   class="btn btn-primary">
                    <i class="bi bi-plus-circle me-1"></i> Add First Amenity
                </a>
            </div>
        </c:otherwise>
    </c:choose>

</t:layout>
