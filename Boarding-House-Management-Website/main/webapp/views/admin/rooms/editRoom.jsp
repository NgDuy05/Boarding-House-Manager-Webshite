<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<t:layout>

    <div class="d-flex align-items-center gap-2 mb-4">
        <a href="${pageContext.request.contextPath}/room"
           class="btn btn-sm btn-outline-secondary"><i class="bi bi-arrow-left"></i></a>
        <h4 class="mb-0"><i class="bi bi-pencil-square me-2"></i>Edit Room</h4>
    </div>

    <c:if test="${empty room}">
        <div class="alert alert-danger">Room not found.</div>
    </c:if>

    <c:if test="${not empty room}">
        <div class="card shadow-sm border-0" style="max-width:560px;">
            <div class="card-body">
                <form method="post" action="${pageContext.request.contextPath}/room">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="roomId" value="${room.roomId}">

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Room Number <span class="text-danger">*</span></label>
                        <input type="text" name="roomNumber" class="form-control" required
                               value="${room.roomNumber}">
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Category <span class="text-danger">*</span></label>
                        <select name="categoryId" class="form-select" required>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.categoryId}"
                                    ${cat.categoryId == room.categoryId ? 'selected' : ''}>
                                    ${cat.categoryName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Status</label>
                        <select name="status" class="form-select">
                            <option value="available" ${room.status == 'available' ? 'selected' : ''}>Available</option>
                            <option value="occupied"  ${room.status == 'occupied'  ? 'selected' : ''}>Occupied</option>
                            <option value="maintenance" ${room.status == 'maintenance' ? 'selected' : ''}>Maintenance</option>
                        </select>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-semibold">Image URL</label>
                        <input type="text" name="image" class="form-control"
                               value="${room.image}">
                    </div>

                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-check-lg me-1"></i>Save Changes
                        </button>
                        <a href="${pageContext.request.contextPath}/room"
                           class="btn btn-outline-secondary">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </c:if>

</t:layout>
