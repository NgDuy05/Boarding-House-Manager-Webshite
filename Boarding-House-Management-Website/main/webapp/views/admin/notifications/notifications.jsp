<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<t:layout>

    <div class="d-flex align-items-center justify-content-between mb-4">
        <h4 class="mb-0"><i class="bi bi-bell me-2"></i>Notifications</h4>
        <a href="${pageContext.request.contextPath}/notification?action=create"
           class="btn btn-primary btn-sm">
            <i class="bi bi-plus-lg me-1"></i>New Notification
        </a>
    </div>

    <%-- Filter tabs: All / General / Private --%>
    <ul class="nav nav-tabs mb-3">
        <li class="nav-item">
            <a class="nav-link ${empty param.type ? 'active' : ''}"
               href="${pageContext.request.contextPath}/notification?action=list">
                <i class="bi bi-grid me-1"></i>All
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${param.type == 'broadcast' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/notification?action=list&type=broadcast">
                <i class="bi bi-megaphone me-1"></i>General
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${param.type == 'targeted' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/notification?action=list&type=targeted">
                <i class="bi bi-person-lines-fill me-1"></i>Private
            </a>
        </li>
    </ul>

    <%-- Search / filter bar --%>
    <form method="get" action="${pageContext.request.contextPath}/notification" class="row g-2 mb-3">
        <input type="hidden" name="action" value="list">
        <c:if test="${not empty param.type}">
            <input type="hidden" name="type" value="${param.type}">
        </c:if>
        <div class="col-md-5">
            <input type="text" name="keyword" value="${param.keyword}" placeholder="Search title / content…"
                   class="form-control form-control-sm">
        </div>
        <div class="col-auto">
            <button class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-search me-1"></i>Search
            </button>
            <a href="${pageContext.request.contextPath}/notification?action=list${not empty param.type ? '&type='.concat(param.type) : ''}"
               class="btn btn-outline-danger btn-sm ms-1">Clear</a>
        </div>
    </form>

    <div class="card shadow-sm border-0">
        <div class="card-body p-0">
            <table class="table table-hover mb-0 align-middle">
                <thead class="table-light">
                    <tr>
                        <th>#</th>
                        <th>Title</th>
                        <th>Type</th>
                        <th>Created By</th>
                        <th>Date</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty notifications}">
                            <tr>
                                <td colspan="6" class="text-center text-muted py-4">
                                    <i class="bi bi-inbox fs-4 d-block mb-2"></i>No notifications found.
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="n" items="${notifications}">
                                <tr>
                                    <td class="text-muted small">${n.notificationId}</td>
                                    <td class="fw-semibold">${n.title}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${n.broadcast}">
                                                <span class="badge bg-info text-dark">
                                                    <i class="bi bi-megaphone me-1"></i>General
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-primary">
                                                    <i class="bi bi-person me-1"></i>Private #${n.targetContractId}
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${n.createdByName}</td>
                                    <td class="small text-muted">${n.createdAt}</td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/notification?action=detail&id=${n.notificationId}"
                                           class="btn btn-sm btn-outline-primary" title="View">
                                            <i class="bi bi-eye"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/notification?action=edit&id=${n.notificationId}"
                                           class="btn btn-sm btn-outline-secondary" title="Edit">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                        <form method="post" action="${pageContext.request.contextPath}/notification"
                                              class="d-inline"
                                              onsubmit="return confirm('Delete this notification?')">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="notificationId" value="${n.notificationId}">
                                            <button class="btn btn-sm btn-outline-danger" title="Delete">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

</t:layout>
