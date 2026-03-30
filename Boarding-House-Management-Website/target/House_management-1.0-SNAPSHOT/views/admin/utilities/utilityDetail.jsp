<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<t:layout>

    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/utility">Utilities</a>
            </li>
            <li class="breadcrumb-item active">${utility.utilityName}</li>
        </ol>
    </nav>

    <%-- Utility Info Card --%>
    <div class="card border-0 shadow-sm mb-4">
        <div class="card-body">
            <div class="d-flex justify-content-between align-items-start">
                <div class="d-flex align-items-center gap-3">
                    <div class="rounded-circle bg-warning bg-opacity-10 p-3">
                        <i class="bi bi-lightning-charge-fill text-warning fs-4"></i>
                    </div>
                    <div>
                        <h4 class="mb-0 fw-bold">${utility.utilityName}</h4>
                        <span class="badge bg-secondary bg-opacity-10 text-dark border mt-1">
                            Unit: ${utility.unit}
                        </span>
                        <c:if test="${not empty utility.description}">
                            <p class="text-muted mb-0 mt-1 small">${utility.description}</p>
                        </c:if>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/utility?action=edit&id=${utility.utilityId}"
                   class="btn btn-outline-warning btn-sm">
                    <i class="bi bi-pencil me-1"></i>Edit
                </a>
            </div>
        </div>
    </div>

    <div class="row g-4">

        <%-- Price History --%>
        <div class="col-lg-6">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-header bg-white border-bottom py-3 d-flex justify-content-between align-items-center">
                    <h6 class="mb-0 fw-semibold">
                        <i class="bi bi-currency-dollar text-success me-2"></i>Price History
                    </h6>
                    <a href="${pageContext.request.contextPath}/utility?action=addPrice&utilityId=${utility.utilityId}"
                       class="btn btn-sm btn-success">
                        <i class="bi bi-plus me-1"></i>Add Price
                    </a>
                </div>
                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${not empty prices}">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th class="ps-3">Price</th>
                                            <th>Effective From</th>
                                            <th class="text-center">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="p" items="${prices}" varStatus="st">
                                            <tr>
                                                <td class="ps-3">
                                                    <span class="fw-semibold text-success">
                                                        <fmt:formatNumber value="${p.price}" type="number" minFractionDigits="0"/>
                                                    </span>
                                                    <span class="text-muted small"> VND/${utility.unit}</span>
                                                </td>
                                                <td class="text-muted small">${p.effectiveFrom}</td>
                                                        <td class="text-center">
                                                    <div class="d-flex justify-content-center gap-1">
                                                        <a href="${pageContext.request.contextPath}/utility?action=editPrice&id=${p.priceId}"
                                                           class="btn btn-sm btn-outline-warning" title="Edit">
                                                            <i class="bi bi-pencil"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/utility?action=deletePrice&id=${p.priceId}&utilityId=${utility.utilityId}"
                                                           class="btn btn-sm btn-outline-danger" title="Remove"
                                                           onclick="return confirm('Remove this price entry permanently?')">
                                                            <i class="bi bi-trash me-1"></i>Remove
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-4 text-muted">
                                <i class="bi bi-cash-stack fs-3 d-block mb-2 opacity-50"></i>
                                <p class="mb-0 small">No price history yet.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <%-- Usage Records --%>
        <div class="col-lg-6">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-header bg-white border-bottom py-3 d-flex justify-content-between align-items-center">
                    <h6 class="mb-0 fw-semibold">
                        <i class="bi bi-graph-up text-primary me-2"></i>Usage Records
                    </h6>
                    <a href="${pageContext.request.contextPath}/utility?action=addUsage&utilityId=${utility.utilityId}"
                       class="btn btn-sm btn-primary">
                        <i class="bi bi-plus me-1"></i>Add Record
                    </a>
                </div>
                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${not empty usages}">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th class="ps-3">Room</th>
                                            <th>Period</th>
                                            <th class="text-center">Old</th>
                                            <th class="text-center">New</th>
                                            <th class="text-center">Used</th>
                                            <th class="text-center">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="u" items="${usages}">
                                            <tr>
                                                <td class="ps-3 fw-semibold">${u.roomNumber}</td>
                                                <td class="text-muted small">${u.period}</td>
                                                <td class="text-center text-muted">${u.oldValue}</td>
                                                <td class="text-center text-muted">${u.newValue}</td>
                                                <td class="text-center">
                                                    <span class="badge bg-info bg-opacity-10 text-info border border-info-subtle">
                                                        ${u.consumption} ${u.unit}
                                                    </span>
                                                </td>
                                                <td class="text-center">
                                                    <div class="d-flex justify-content-center gap-1">
                                                        <a href="${pageContext.request.contextPath}/utility?action=editUsage&id=${u.usageId}"
                                                           class="btn btn-sm btn-outline-warning" title="Edit">
                                                            <i class="bi bi-pencil"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/utility?action=deleteUsage&id=${u.usageId}&utilityId=${utility.utilityId}"
                                                           class="btn btn-sm btn-outline-danger" title="Remove"
                                                           onclick="return confirm('Remove this usage record permanently?')">
                                                            <i class="bi bi-trash me-1"></i>Remove
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-4 text-muted">
                                <i class="bi bi-bar-chart fs-3 d-block mb-2 opacity-50"></i>
                                <p class="mb-0 small">No usage records yet.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

    </div>

</t:layout>
