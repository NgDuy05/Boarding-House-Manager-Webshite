<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<t:layout>

    <div class="d-flex align-items-center gap-2 mb-4">
        <a href="${pageContext.request.contextPath}/room"
           class="btn btn-sm btn-outline-secondary"><i class="bi bi-arrow-left"></i></a>
        <h4 class="mb-0"><i class="bi bi-house-door me-2"></i>Room Detail</h4>
    </div>

    <c:if test="${empty room}">
        <div class="alert alert-danger">Room not found.</div>
    </c:if>

    <c:if test="${not empty room}">
        <div class="card shadow-sm border-0 mb-3" style="max-width:640px;">
            <div class="card-header bg-white fw-semibold">
                <i class="bi bi-house-door me-2"></i>Room ${room.roomNumber}
                <c:choose>
                    <c:when test="${room.status == 'available'}">
                        <span class="badge bg-success float-end">Available</span>
                    </c:when>
                    <c:when test="${room.status == 'occupied'}">
                        <span class="badge bg-danger float-end">Occupied</span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge bg-warning text-dark float-end">Maintenance</span>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="card-body">
                <c:if test="${not empty room.image}">
                    <img src="${pageContext.request.contextPath}/${room.image}"
                         class="img-fluid rounded mb-3" style="max-height:220px; object-fit:cover;"
                         alt="Room ${room.roomNumber}">
                </c:if>
                <div class="row g-3">
                    <div class="col-sm-6">
                        <div class="text-muted small">Room ID</div>
                        <div class="fw-semibold">${room.roomId}</div>
                    </div>
                    <div class="col-sm-6">
                        <div class="text-muted small">Category</div>
                        <div class="fw-semibold">${not empty room.categoryName ? room.categoryName : '#'.concat(room.categoryId)}</div>
                    </div>
                    <div class="col-sm-6">
                        <div class="text-muted small">Base Price</div>
                        <div class="fw-semibold text-primary">
                            <c:if test="${not empty room.basePrice}">
                                <fmt:formatNumber value="${room.basePrice}" groupingUsed="true" maxFractionDigits="0"/>&#8363;
                            </c:if>
                            <c:if test="${empty room.basePrice}">—</c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/room?action=edit&id=${room.roomId}"
               class="btn btn-primary btn-sm"><i class="bi bi-pencil me-1"></i>Edit</a>
            <a href="${pageContext.request.contextPath}/room?action=delete&id=${room.roomId}"
               class="btn btn-danger btn-sm"
               onclick="return confirm('Delete room ${room.roomNumber}?')">
                <i class="bi bi-trash me-1"></i>Delete
            </a>
        </div>

        <%-- Resident history --%>
        <div class="card shadow-sm border-0 mt-4" style="max-width:800px;">
            <div class="card-header bg-white fw-semibold">
                <i class="bi bi-clock-history me-2"></i>Resident History
                <span class="badge bg-secondary ms-1">${not empty tenantHistory ? tenantHistory.size() : 0}</span>
            </div>
            <div class="card-body p-0">
                <c:choose>
                    <c:when test="${empty tenantHistory}">
                        <div class="text-center text-muted py-4">
                            <i class="bi bi-person-slash fs-4 d-block mb-2"></i>No residents on record
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0 small">
                                <thead class="table-light">
                                    <tr>
                                        <th class="ps-3">Full Name</th>
                                        <th>CCCD</th>
                                        <th>Phone</th>
                                        <th>Role</th>
                                        <th>Contract From</th>
                                        <th>To</th>
                                        <th>Contract Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="t" items="${tenantHistory}">
                                        <tr>
                                            <td class="ps-3 fw-semibold">${t.fullName}</td>
                                            <td class="text-muted">${not empty t.cccd ? t.cccd : '—'}</td>
                                            <td class="text-muted">${not empty t.phone ? t.phone : '—'}</td>
                                            <td>
                                                <span class="badge ${t.primary ? 'bg-primary' : 'bg-secondary'} rounded-pill">
                                                    ${t.primary ? 'Primary' : 'Co-tenant'}
                                                </span>
                                            </td>
                                            <td class="text-muted">${not empty t.contractStartDate ? t.contractStartDate : '—'}</td>
                                            <td class="text-muted">${not empty t.contractEndDate ? t.contractEndDate : 'Ongoing'}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${t.contractStatus == 'active'}">
                                                        <span class="badge bg-success-subtle text-success border border-success-subtle rounded-pill">Active</span>
                                                    </c:when>
                                                    <c:when test="${t.contractStatus == 'terminated'}">
                                                        <span class="badge bg-danger-subtle text-danger border border-danger-subtle rounded-pill">Terminated</span>
                                                    </c:when>
                                                    <c:when test="${t.contractStatus == 'expired'}">
                                                        <span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle rounded-pill">Expired</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-light text-dark border rounded-pill">${t.contractStatus}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </c:if>

</t:layout>
