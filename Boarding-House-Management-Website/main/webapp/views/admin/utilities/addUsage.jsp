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
                <a href="${pageContext.request.contextPath}/utility?action=detail&id=${utility.utilityId}">
                    ${utility.utilityName}
                </a>
            </li>
            <li class="breadcrumb-item active">Add Usage Record</li>
        </ol>
    </nav>

    <div class="row justify-content-center">
        <div class="col-lg-6">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white border-bottom py-3">
                    <h5 class="mb-0 fw-semibold">
                        <i class="bi bi-plus-circle text-primary me-2"></i>
                        Add Usage Record — ${utility.utilityName}
                    </h5>
                </div>
                <div class="card-body p-4">
                    <form method="post" action="${pageContext.request.contextPath}/utility">
                        <input type="hidden" name="action" value="insertUsage">
                        <input type="hidden" name="utilityId" value="${utility.utilityId}">

                        <div class="mb-3">
                            <label class="form-label fw-semibold">
                                Room <span class="text-danger">*</span>
                            </label>
                            <select name="roomId" class="form-select" required>
                                <option value="">-- Select Room --</option>
                                <c:forEach var="room" items="${rooms}">
                                    <option value="${room.roomId}">Room ${room.roomNumber}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">
                                Period <span class="text-danger">*</span>
                            </label>
                            <input type="date" name="period" class="form-control" required>
                            <div class="form-text">First day of the billing month (e.g. 2026-01-01).</div>
                        </div>

                        <div class="row g-3 mb-4">
                            <div class="col-6">
                                <label class="form-label fw-semibold">
                                    Old Reading (${utility.unit}) <span class="text-danger">*</span>
                                </label>
                                <input type="number" name="oldValue" class="form-control"
                                       placeholder="0" min="0" required>
                            </div>
                            <div class="col-6">
                                <label class="form-label fw-semibold">
                                    New Reading (${utility.unit}) <span class="text-danger">*</span>
                                </label>
                                <input type="number" name="newValue" class="form-control"
                                       placeholder="0" min="0" required>
                            </div>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary px-4">
                                <i class="bi bi-check-circle me-1"></i>Save Record
                            </button>
                            <a href="${pageContext.request.contextPath}/utility?action=detail&id=${utility.utilityId}"
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
