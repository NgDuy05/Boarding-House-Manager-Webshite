<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<t:layout>

    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/utility">Utilities</a>
            </li>
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/utility?action=detail&id=${usage.utilityId}">
                    ${usage.utilityName}
                </a>
            </li>
            <li class="breadcrumb-item active">Edit Usage Record</li>
        </ol>
    </nav>

    <div class="row justify-content-center">
        <div class="col-lg-6">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white border-bottom py-3">
                    <h5 class="mb-0 fw-semibold">
                        <i class="bi bi-pencil text-warning me-2"></i>Edit Usage Record
                    </h5>
                </div>
                <div class="card-body p-4">
                    <form method="post" action="${pageContext.request.contextPath}/utility">
                        <input type="hidden" name="action" value="updateUsage">
                        <input type="hidden" name="usageId" value="${usage.usageId}">
                        <input type="hidden" name="utilityId" value="${usage.utilityId}">

                        <div class="mb-3">
                            <label class="form-label fw-semibold">
                                Utility <span class="text-danger">*</span>
                            </label>
                            <select name="utilityId" class="form-select" required
                                    onchange="document.querySelector('[name=utilityId]').value = this.value">
                                <c:forEach var="u" items="${utilities}">
                                    <option value="${u.utilityId}"
                                            ${u.utilityId == usage.utilityId ? 'selected' : ''}>
                                        ${u.utilityName} (${u.unit})
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">
                                Room <span class="text-danger">*</span>
                            </label>
                            <select name="roomId" class="form-select" required>
                                <c:forEach var="room" items="${rooms}">
                                    <option value="${room.roomId}"
                                            ${room.roomId == usage.roomId ? 'selected' : ''}>
                                        Room ${room.roomNumber}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">
                                Period <span class="text-danger">*</span>
                            </label>
                            <input type="date" name="period" class="form-control"
                                   value="${usage.period}" required>
                        </div>

                        <div class="row g-3 mb-4">
                            <div class="col-6">
                                <label class="form-label fw-semibold">Old Reading</label>
                                <input type="number" name="oldValue" class="form-control"
                                       value="${usage.oldValue}" min="0" required>
                            </div>
                            <div class="col-6">
                                <label class="form-label fw-semibold">New Reading</label>
                                <input type="number" name="newValue" class="form-control"
                                       value="${usage.newValue}" min="0" required>
                            </div>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-warning px-4">
                                <i class="bi bi-check-circle me-1"></i>Update
                            </button>
                            <a href="${pageContext.request.contextPath}/utility?action=detail&id=${usage.utilityId}"
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
