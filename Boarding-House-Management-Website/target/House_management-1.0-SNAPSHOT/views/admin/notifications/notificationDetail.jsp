<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<t:layout>

    <div class="d-flex align-items-center gap-2 mb-4">
        <a href="${pageContext.request.contextPath}/notification?action=list"
           class="btn btn-sm btn-outline-secondary"><i class="bi bi-arrow-left"></i></a>
        <h4 class="mb-0"><i class="bi bi-bell me-2"></i>Notification Detail</h4>
    </div>

    <c:if test="${empty notification}">
        <div class="alert alert-danger">Notification not found.</div>
    </c:if>

    <c:if test="${not empty notification}">
        <div class="card shadow-sm border-0 mb-3" style="max-width:700px;">
            <div class="card-header bg-white fw-semibold">
                <i class="bi bi-bell me-2"></i>${notification.title}
                <c:choose>
                    <c:when test="${notification.broadcast}">
                        <span class="badge bg-info text-dark float-end">Broadcast</span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge bg-secondary float-end">Targeted #${notification.targetContractId}</span>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-sm-6">
                        <div class="text-muted small">Created By</div>
                        <div class="fw-semibold">${notification.createdByName}</div>
                    </div>
                    <div class="col-sm-6">
                        <div class="text-muted small">Date</div>
                        <div class="fw-semibold">${notification.createdAt}</div>
                    </div>
                    <div class="col-12">
                        <div class="text-muted small mb-1">Content</div>
                        <p class="mb-0">${notification.content}</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/notification?action=edit&id=${notification.notificationId}"
               class="btn btn-primary btn-sm"><i class="bi bi-pencil me-1"></i>Edit</a>
            <form method="post" action="${pageContext.request.contextPath}/notification"
                  class="d-inline" onsubmit="return confirm('Delete this notification?')">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="notificationId" value="${notification.notificationId}">
                <button class="btn btn-danger btn-sm"><i class="bi bi-trash me-1"></i>Delete</button>
            </form>
        </div>
    </c:if>

</t:layout>
