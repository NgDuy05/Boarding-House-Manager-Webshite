<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<t:layout>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="mb-0"><i class="bi bi-stars me-2 text-info"></i>Amenities</h2>
            <p class="text-muted mb-0 small">Room features that improve comfort — Balcony, Private Bathroom, Kitchen, etc.</p>
        </div>
        <a href="${pageContext.request.contextPath}/amenity?action=create" class="btn btn-primary">
            <i class="bi bi-plus-circle me-1"></i>Add Amenity
        </a>
    </div>

    <%-- Stats bar --%>
    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="card border-0 shadow-sm">
                <div class="card-body d-flex align-items-center gap-3">
                    <div class="rounded-circle bg-info bg-opacity-10 p-3">
                        <i class="bi bi-check-circle-fill text-info fs-4"></i>
                    </div>
                    <div>
                        <div class="fs-4 fw-bold">
                            <c:set var="activeCount" value="0"/>
                            <c:forEach var="a" items="${amenities}">
                                <c:if test="${not a.isDeleted}">
                                    <c:set var="activeCount" value="${activeCount + 1}"/>
                                </c:if>
                            </c:forEach>
                            ${activeCount}
                        </div>
                        <div class="text-muted small">Active Amenities</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card border-0 shadow-sm">
                <div class="card-body d-flex align-items-center gap-3">
                    <div class="rounded-circle p-3" style="background:#fee2e2">
                        <i class="bi bi-eye-slash-fill fs-4" style="color:#dc2626"></i>
                    </div>
                    <div>
                        <div class="fs-4 fw-bold text-danger">${amenities.size() - activeCount}</div>
                        <div class="text-muted small">Hidden Amenities</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <c:choose>
        <c:when test="${not empty amenities}">
            <div class="row row-cols-1 row-cols-md-3 g-4">
                <c:forEach var="a" items="${amenities}">
                    <div class="col">
                        <div class="card h-100 border-0 shadow-sm ${a.isDeleted ? 'opacity-75' : ''}">
                            <div class="card-body">
                                <div class="d-flex align-items-center justify-content-between mb-2">
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="rounded-circle p-3
                                             ${a.isDeleted ? 'bg-secondary bg-opacity-10' : 'bg-info bg-opacity-10'}">
                                            <i class="bi bi-check-circle-fill fs-5
                                               ${a.isDeleted ? 'text-secondary' : 'text-info'}"></i>
                                        </div>
                                        <h5 class="card-title mb-0 fw-semibold
                                             ${a.isDeleted ? 'text-decoration-line-through text-muted' : ''}">
                                            ${a.amenityName}
                                        </h5>
                                    </div>
                                    <c:choose>
                                        <c:when test="${a.isDeleted}">
                                            <span class="badge bg-danger bg-opacity-10 text-danger border border-danger-subtle">
                                                <i class="bi bi-eye-slash me-1"></i>Hidden
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-success bg-opacity-10 text-success border border-success-subtle">
                                                <i class="bi bi-eye me-1"></i>Active
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <p class="card-text text-muted small mt-2">
                                    <c:choose>
                                        <c:when test="${not empty a.description}">${a.description}</c:when>
                                        <c:otherwise><em>No description</em></c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                            <div class="card-footer bg-transparent border-top-0 d-flex gap-2">
                                <c:if test="${not a.isDeleted}">
                                    <a href="${pageContext.request.contextPath}/amenity?action=edit&id=${a.amenityId}"
                                       class="btn btn-sm btn-outline-warning flex-fill">
                                        <i class="bi bi-pencil me-1"></i>Edit
                                    </a>
                                    <a href="${pageContext.request.contextPath}/amenity?action=hide&id=${a.amenityId}"
                                       class="btn btn-sm btn-outline-secondary flex-fill"
                                       onclick="return confirm('Hide amenity \'${a.amenityName}\'?')">
                                        <i class="bi bi-eye-slash me-1"></i>Hide
                                    </a>
                                </c:if>
                                <c:if test="${a.isDeleted}">
                                    <a href="${pageContext.request.contextPath}/amenity?action=restore&id=${a.amenityId}"
                                       class="btn btn-sm btn-outline-success w-100"
                                       onclick="return confirm('Restore amenity \'${a.amenityName}\'?')">
                                        <i class="bi bi-arrow-counterclockwise me-1"></i>Restore
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
            <div class="mt-3 text-muted small">
                Total: <strong>${amenities.size()}</strong> amenity(ies)
                (<strong>${activeCount}</strong> active,
                <strong>${amenities.size() - activeCount}</strong> hidden)
            </div>
        </c:when>
        <c:otherwise>
            <div class="text-center text-muted py-5">
                <i class="bi bi-stars fs-1 d-block mb-3 opacity-50"></i>
                <p class="mb-3">No amenities found.</p>
                <a href="${pageContext.request.contextPath}/amenity?action=create" class="btn btn-primary">
                    <i class="bi bi-plus-circle me-1"></i>Add First Amenity
                </a>
            </div>
        </c:otherwise>
    </c:choose>

</t:layout>
