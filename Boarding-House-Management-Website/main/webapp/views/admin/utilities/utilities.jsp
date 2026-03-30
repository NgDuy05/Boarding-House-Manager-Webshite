<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<t:layout>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="mb-0"><i class="bi bi-lightning-charge-fill me-2 text-warning"></i>Utilities</h2>
            <p class="text-muted mb-0 small">Manage usage-based services: Electricity, Water, Gas, etc.</p>
        </div>
        <a href="${pageContext.request.contextPath}/utility?action=create" class="btn btn-primary">
            <i class="bi bi-plus-circle me-1"></i>Add Utility
        </a>
    </div>

    <%-- Stats bar --%>
    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="card border-0 shadow-sm">
                <div class="card-body d-flex align-items-center gap-3">
                    <div class="rounded-circle bg-warning bg-opacity-10 p-3">
                        <i class="bi bi-lightning-charge-fill text-warning fs-4"></i>
                    </div>
                    <div>
                        <div class="fs-4 fw-bold">
                            <c:set var="activeCount" value="0"/>
                            <c:forEach var="u" items="${utilities}">
                                <c:if test="${not u.isDeleted}">
                                    <c:set var="activeCount" value="${activeCount + 1}"/>
                                </c:if>
                            </c:forEach>
                            ${activeCount}
                        </div>
                        <div class="text-muted small">Active Utilities</div>
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
                        <div class="fs-4 fw-bold text-danger">${utilities.size() - activeCount}</div>
                        <div class="text-muted small">Hidden Utilities</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="card border-0 shadow-sm">
        <div class="card-header bg-white border-bottom py-3">
            <h6 class="mb-0 fw-semibold"><i class="bi bi-table me-2"></i>Utility List</h6>
        </div>
        <div class="card-body p-0">
            <c:choose>
                <c:when test="${not empty utilities}">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th class="ps-4">#</th>
                                    <th>Name</th>
                                    <th>Unit</th>
                                    <th>Description</th>
                                    <th class="text-center">Status</th>
                                    <th class="text-center">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="u" items="${utilities}" varStatus="st">
                                    <tr class="${u.isDeleted ? 'table-secondary text-muted' : ''}">
                                        <td class="ps-4 text-muted">${st.count}</td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <div class="rounded-circle p-2
                                                     ${u.isDeleted ? 'bg-secondary bg-opacity-10' : 'bg-warning bg-opacity-10'}">
                                                    <i class="bi bi-lightning-charge
                                                       ${u.isDeleted ? 'text-secondary' : 'text-warning'}"></i>
                                                </div>
                                                <span class="fw-semibold
                                                     ${u.isDeleted ? 'text-decoration-line-through text-muted' : ''}">
                                                    ${u.utilityName}
                                                </span>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="badge bg-secondary bg-opacity-10 text-dark border">
                                                ${u.unit}
                                            </span>
                                        </td>
                                        <td class="text-muted small">
                                            <c:choose>
                                                <c:when test="${not empty u.description}">${u.description}</c:when>
                                                <c:otherwise>—</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${u.isDeleted}">
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
                                                <c:if test="${not u.isDeleted}">
                                                    <a href="${pageContext.request.contextPath}/utility?action=detail&id=${u.utilityId}"
                                                       class="btn btn-sm btn-outline-info" title="View Detail">
                                                        <i class="bi bi-eye"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/utility?action=edit&id=${u.utilityId}"
                                                       class="btn btn-sm btn-outline-warning" title="Edit">
                                                        <i class="bi bi-pencil"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/utility?action=hide&id=${u.utilityId}"
                                                       class="btn btn-sm btn-outline-secondary" title="Hide"
                                                       onclick="return confirm('Hide utility \'${u.utilityName}\'?')">
                                                        <i class="bi bi-eye-slash me-1"></i>Hide
                                                    </a>
                                                </c:if>
                                                <c:if test="${u.isDeleted}">
                                                    <a href="${pageContext.request.contextPath}/utility?action=restore&id=${u.utilityId}"
                                                       class="btn btn-sm btn-outline-success" title="Restore"
                                                       onclick="return confirm('Restore utility \'${u.utilityName}\'?')">
                                                        <i class="bi bi-arrow-counterclockwise me-1"></i>Restore
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
                        <i class="bi bi-lightning-charge fs-1 d-block mb-3 opacity-50"></i>
                        <p class="mb-3">No utilities found.</p>
                        <a href="${pageContext.request.contextPath}/utility?action=create" class="btn btn-primary">
                            <i class="bi bi-plus-circle me-1"></i>Add First Utility
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
                            <a class="page-link" href="?page=${currentPage - 1}">Previous</a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link" href="?page=${i}">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="?page=${currentPage + 1}">Next</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </c:if>
    </div>

</t:layout>
