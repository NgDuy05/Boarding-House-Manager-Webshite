<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<t:layout>

    <div class="d-flex align-items-center gap-2 mb-4">
        <a href="${pageContext.request.contextPath}/room"
           class="btn btn-sm btn-outline-secondary"><i class="bi bi-arrow-left"></i></a>
        <h4 class="mb-0"><i class="bi bi-house-door me-2"></i>Add Room</h4>
    </div>

    <div class="card shadow-sm border-0" style="max-width:560px;">
        <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/room">
                <input type="hidden" name="action" value="create">

                <div class="mb-3">
                    <label class="form-label fw-semibold">Room Number <span class="text-danger">*</span></label>
                    <input type="text" name="roomNumber" class="form-control" required
                           placeholder="e.g. 101">
                </div>

                <div class="mb-3">
                    <label class="form-label fw-semibold">Category <span class="text-danger">*</span></label>
                    <select name="categoryId" class="form-select" required>
                        <option value="">-- Select category --</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat.categoryId}">${cat.categoryName}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-semibold">Status</label>
                    <select name="status" class="form-select">
                        <option value="available">Available</option>
                        <option value="occupied">Occupied</option>
                        <option value="maintenance">Maintenance</option>
                    </select>
                </div>

                <div class="mb-4">
                    <label class="form-label fw-semibold">Image URL</label>
                    <input type="text" name="image" class="form-control"
                           placeholder="assets/images/room/…">
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-plus-lg me-1"></i>Create
                    </button>
                    <a href="${pageContext.request.contextPath}/room"
                       class="btn btn-outline-secondary">Cancel</a>
                </div>
            </form>
        </div>
    </div>

</t:layout>
