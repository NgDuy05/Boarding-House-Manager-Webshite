<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<t:layout>

    <div class="d-flex align-items-center gap-2 mb-4">
        <a href="${pageContext.request.contextPath}/notification?action=list"
           class="btn btn-sm btn-outline-secondary"><i class="bi bi-arrow-left"></i></a>
        <h4 class="mb-0"><i class="bi bi-pencil-square me-2"></i>Edit Notification</h4>
    </div>

    <c:if test="${empty notification}">
        <div class="alert alert-danger">Notification not found.</div>
    </c:if>

    <c:if test="${not empty notification}">
        <div class="card shadow-sm border-0" style="max-width:600px;">
            <div class="card-body">
                <form method="post" action="${pageContext.request.contextPath}/notification">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="notificationId" value="${notification.notificationId}">

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Title <span class="text-danger">*</span></label>
                        <input type="text" name="title" class="form-control" required
                               value="${notification.title}">
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Content <span class="text-danger">*</span></label>
                        <textarea name="content" class="form-control" rows="4" required>${notification.content}</textarea>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-semibold">Target Contract ID
                            <span class="text-muted small fw-normal">(blank = broadcast)</span>
                        </label>
                        <input type="number" name="targetContractId" class="form-control"
                               value="${notification.targetContractId}">
                    </div>

                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-check-lg me-1"></i>Save Changes
                        </button>
                        <a href="${pageContext.request.contextPath}/notification?action=list"
                           class="btn btn-outline-secondary">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </c:if>

</t:layout>
