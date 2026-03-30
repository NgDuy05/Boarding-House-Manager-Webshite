<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<t:layout>

    <%-- Page header --%>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="mb-0"><i class="bi bi-gear-wide-connected me-2 text-primary"></i>Manage Services</h2>
            <p class="text-muted mb-0 small">Add, edit, or remove services offered to tenants</p>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/services?action=requestList"
               class="btn btn-outline-info">
                <i class="bi bi-list-check me-1"></i>Service Request List
            </a>
            <a href="${pageContext.request.contextPath}/services?action=create"
               class="btn btn-primary">
                <i class="bi bi-plus-circle me-1"></i>Add Service
            </a>
        </div>
    </div>

    <%-- Stats bar --%>
    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="card border-0 shadow-sm">
                <div class="card-body d-flex align-items-center gap-3">
                    <div class="rounded-circle bg-primary bg-opacity-10 p-3">
                        <i class="bi bi-grid-3x3-gap-fill text-primary fs-4"></i>
                    </div>
                    <div>
                        <div class="fs-4 fw-bold">${services.size() - hiddenCount}</div>
                        <div class="text-muted small">Active Services</div>
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
                        <div class="fs-4 fw-bold text-danger">${hiddenCount}</div>
                        <div class="text-muted small">Hidden Services</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- Service table --%>
    <div class="card border-0 shadow-sm">
        <div class="card-header bg-white border-bottom py-3">
            <h6 class="mb-0 fw-semibold"><i class="bi bi-table me-2"></i>Service List</h6>
        </div>
        <div class="card-body p-0">
            <c:choose>
                <c:when test="${not empty services}">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th class="ps-4">#</th>
                                    <th>Service Name</th>
                                    <th>Category</th>
                                    <th>Description</th>
                                    <th class="text-center">Status</th>
                                    <th class="text-center">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="svc" items="${services}" varStatus="st">
                                    <tr class="${svc.isDeleted ? 'table-secondary text-muted' : ''}">
                                        <td class="ps-4 text-muted">${st.count}</td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <div class="rounded-circle p-2
                                                     ${svc.isDeleted
                                                         ? 'bg-secondary bg-opacity-10'
                                                         : 'bg-primary bg-opacity-10'}">
                                                    <i class="bi bi-lightning-charge
                                                       ${svc.isDeleted ? 'text-secondary' : 'text-primary'}"></i>
                                                </div>
                                                <span class="fw-semibold
                                                     ${svc.isDeleted ? 'text-decoration-line-through text-muted' : ''}">
                                                    ${svc.serviceName}
                                                </span>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="badge bg-light text-dark border">
                                                Cat. ${svc.categoryId}
                                            </span>
                                        </td>
                                        <td class="text-muted small">
                                            <c:choose>
                                                <c:when test="${not empty svc.description}">${svc.description}</c:when>
                                                <c:otherwise>—</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${svc.isDeleted}">
                                                    <span class="badge rounded-pill bg-danger bg-opacity-10 text-danger border border-danger-subtle px-3">
                                                        <i class="bi bi-eye-slash me-1"></i>Hidden
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge rounded-pill bg-success bg-opacity-10 text-success border border-success-subtle px-3">
                                                        <i class="bi bi-eye me-1"></i>Active
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <div class="d-flex justify-content-center gap-1">
                                                <c:if test="${not svc.isDeleted}">
                                                    <a href="${pageContext.request.contextPath}/services?action=edit&id=${svc.serviceId}"
                                                       class="btn btn-sm btn-outline-warning" title="Edit">
                                                        <i class="bi bi-pencil"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/services?action=hide&id=${svc.serviceId}"
                                                       class="btn btn-sm btn-outline-danger" title="Hide from customers"
                                                       onclick="return confirm('Hide service \'${svc.serviceName}\' from customers?')">
                                                        <i class="bi bi-eye-slash me-1"></i>Hide
                                                    </a>
                                                </c:if>
                                                <c:if test="${svc.isDeleted}">
                                                    <a href="${pageContext.request.contextPath}/services?action=restore&id=${svc.serviceId}"
                                                       class="btn btn-sm btn-outline-success" title="Restore service"
                                                       onclick="return confirm('Restore service \'${svc.serviceName}\'?')">
                                                        <i class="bi bi-eye me-1"></i>Restore
                                                    </a>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-5 text-muted">
                        <i class="bi bi-inbox fs-1 d-block mb-3 opacity-50"></i>
                        <p class="mb-3">No services found.</p>
                        <a href="${pageContext.request.contextPath}/services?action=create"
                           class="btn btn-primary">
                            <i class="bi bi-plus-circle me-1"></i>Add First Service
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        <c:if test="${totalPages > 1}">
            <div class="card-footer bg-white d-flex justify-content-end">
                <nav>
                    <ul class="pagination pagination-sm mb-0">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="?action=adminList&page=${currentPage - 1}">Previous</a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link" href="?action=adminList&page=${i}">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="?action=adminList&page=${currentPage + 1}">Next</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </c:if>
    </div>

</t:layout>
