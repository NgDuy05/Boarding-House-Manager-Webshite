<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<t:layout>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2><i class="bi bi-tags me-2"></i>Room Price Categories</h2>
        <a href="${pageContext.request.contextPath}/price?action=create"
           class="btn btn-primary">
            <i class="bi bi-plus-circle me-1"></i> Add Category
        </a>
    </div>

    <%-- Filter tabs by category type --%>
    <ul class="nav nav-tabs mb-3" id="categoryTab">
        <li class="nav-item">
            <a class="nav-link active" href="${pageContext.request.contextPath}/price?action=categories">
                All
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/price?action=categories&type=rent">
                <span class="badge bg-primary me-1">Rent</span>
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/price?action=categories&type=utility">
                <span class="badge bg-info text-dark me-1">Utility</span>
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/price?action=categories&type=service">
                <span class="badge bg-success me-1">Service</span>
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/price?action=categories&type=facility">
                <span class="badge bg-secondary me-1">Facility</span>
            </a>
        </li>
    </ul>

    <div class="card shadow-sm">
        <div class="card-body p-0">
            <table class="table table-hover table-striped mb-0 align-middle">
                <thead class="table-dark">
                    <tr>
                        <th style="width: 60px;">#</th>
                        <th>Category Code</th>
                        <th>Type</th>
                        <th>Unit</th>
                        <th style="width: 150px; text-align: center;">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="cat" items="${categories}" varStatus="s">
                        <tr>
                            <td>${s.index + 1}</td>
                            <td>
                                <i class="bi bi-tag me-1 text-secondary"></i>
                                <strong>${cat.categoryCode}</strong>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${cat.categoryType == 'rent'}">
                                        <span class="badge bg-primary">Rent</span>
                                    </c:when>
                                    <c:when test="${cat.categoryType == 'utility'}">
                                        <span class="badge bg-info text-dark">Utility</span>
                                    </c:when>
                                    <c:when test="${cat.categoryType == 'service'}">
                                        <span class="badge bg-success">Service</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">Facility</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${cat.unit}</td>
                            <td class="text-center">
                                <a href="${pageContext.request.contextPath}/price?action=edit&id=${cat.categoryId}"
                                   class="btn btn-sm btn-warning">
                                    <i class="bi bi-pencil"></i> Edit
                                </a>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty categories}">
                        <tr>
                            <td colspan="5" class="text-center text-muted py-5">
                                <i class="bi bi-inbox fs-2 d-block mb-2"></i>
                                No price categories found.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <div class="card-footer text-muted">
            Total: <strong>${categories.size()}</strong> category(ies)
        </div>
    </div>

</t:layout>
