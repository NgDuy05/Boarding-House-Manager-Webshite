<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="t"   tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<t:layout>

    <%-- Page header --%>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="mb-0"><i class="bi bi-list-check me-2 text-info"></i>Service Request List</h2>
            <p class="text-muted mb-0 small">All service usage records across all tenants</p>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/services?action=adminList"
               class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left me-1"></i>Back to Services
            </a>
        </div>
    </div>

    <%-- Add Usage Form --%>
    <div class="card border-0 shadow-sm mb-4">
        <div class="card-header bg-white border-bottom py-3">
            <h6 class="mb-0 fw-semibold">
                <i class="bi bi-plus-circle text-success me-2"></i>Record New Service Usage
            </h6>
        </div>
        <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/services"
                  class="row g-3 align-items-end">
                <input type="hidden" name="action" value="addUsage">

                <div class="col-md-3">
                    <label class="form-label fw-semibold small">Contract ID</label>
                    <input type="number" name="contractId" class="form-control"
                           placeholder="e.g. 1" min="1" required>
                </div>

                <div class="col-md-3">
                    <label class="form-label fw-semibold small">Service</label>
                    <select name="serviceId" class="form-select" required>
                        <option value="">-- Select Service --</option>
                        <c:forEach var="svc" items="${services}">
                            <option value="${svc.serviceId}">${svc.serviceName}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-md-2">
                    <label class="form-label fw-semibold small">Quantity</label>
                    <input type="number" name="quantity" class="form-control"
                           placeholder="1" min="1" step="0.01" value="1" required>
                </div>

                <div class="col-md-2">
                    <label class="form-label fw-semibold small">Usage Date</label>
                    <input type="date" name="usageDate" class="form-control" required>
                </div>

                <div class="col-md-2">
                    <button type="submit" class="btn btn-success w-100">
                        <i class="bi bi-plus-circle me-1"></i>Add
                    </button>
                </div>
            </form>
        </div>
    </div>

    <%-- Stats --%>
    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="card border-0 shadow-sm text-center py-3">
                <div class="fs-3 fw-bold text-primary">${usageList.size()}</div>
                <div class="text-muted small">Total Records</div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card border-0 shadow-sm text-center py-3">
                <div class="fs-3 fw-bold text-warning">
                    <c:set var="unbilledCount" value="0" />
                    <c:forEach var="u" items="${usageList}">
                        <c:if test="${!u.billed}">
                            <c:set var="unbilledCount" value="${unbilledCount + 1}" />
                        </c:if>
                    </c:forEach>
                    ${unbilledCount}
                </div>
                <div class="text-muted small">Pending Billing</div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card border-0 shadow-sm text-center py-3">
                <div class="fs-3 fw-bold text-success">
                    ${usageList.size() - unbilledCount}
                </div>
                <div class="text-muted small">Already Billed</div>
            </div>
        </div>
    </div>

    <%-- Filter bar --%>
    <div class="card border-0 shadow-sm mb-3">
        <div class="card-body py-2 d-flex align-items-center gap-3">
            <span class="fw-semibold small text-muted">
                <i class="bi bi-funnel me-1"></i>Filter:
            </span>
            <a href="${pageContext.request.contextPath}/services?action=requestList"
               class="btn btn-sm btn-outline-primary">All</a>
            <a href="#" onclick="filterTable('all')"       class="btn btn-sm btn-outline-secondary">All Status</a>
            <a href="#" onclick="filterTable('pending')"   class="btn btn-sm btn-outline-warning">Pending</a>
            <a href="#" onclick="filterTable('billed')"    class="btn btn-sm btn-outline-success">Billed</a>
        </div>
    </div>

    <%-- Usage table --%>
    <div class="card border-0 shadow-sm">
        <div class="card-body p-0">
            <c:choose>
                <c:when test="${not empty usageList}">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0" id="usageTable">
                            <thead class="table-light">
                                <tr>
                                    <th class="ps-4">#</th>
                                    <th>Contract / Room</th>
                                    <th>Service</th>
                                    <th>Usage Date</th>
                                    <th class="text-end">Qty</th>
                                    <th class="text-end">Unit Price</th>
                                    <th class="text-end">Total</th>
                                    <th class="text-center">Status</th>
                                    <th class="text-center">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="u" items="${usageList}" varStatus="st">
                                    <tr data-status="${u.billed ? 'billed' : 'pending'}">
                                        <td class="ps-4 text-muted">${st.count}</td>
                                        <td>
                                            <div class="fw-semibold">Contract #${u.contractId}</div>
                                            <div class="text-muted small">
                                                <i class="bi bi-door-closed me-1"></i>Room ${u.roomNumber}
                                            </div>
                                        </td>
                                        <td>
                                            <span class="badge bg-info bg-opacity-10 text-info border border-info-subtle px-2 py-1">
                                                <i class="bi bi-lightning-charge me-1"></i>${u.serviceName}
                                            </span>
                                        </td>
                                        <td class="text-muted small">${u.usageDate}</td>
                                        <td class="text-end">${u.quantity}</td>
                                        <td class="text-end text-muted small">
                                            <fmt:formatNumber value="${u.unitPrice}" groupingUsed="true" maxFractionDigits="0"/>₫
                                        </td>
                                        <td class="text-end fw-semibold">
                                            <fmt:formatNumber value="${u.totalCost}" groupingUsed="true" maxFractionDigits="0"/>₫
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${u.billed}">
                                                    <span class="badge bg-success">
                                                        <i class="bi bi-check-circle me-1"></i>Billed
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-warning text-dark">
                                                        <i class="bi bi-clock me-1"></i>Pending
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <c:if test="${!u.billed}">
                                                <a href="${pageContext.request.contextPath}/services?action=markBilled&contractId=${u.contractId}"
                                                   class="btn btn-sm btn-outline-success"
                                                   onclick="return confirm('Mark all usage for Contract #${u.contractId} as billed?')"
                                                   title="Mark contract as billed">
                                                    <i class="bi bi-check2-all"></i>
                                                </a>
                                            </c:if>
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
                        <p>No service usage records found.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        <c:if test="${totalPages > 1}">
            <div class="card-footer bg-white d-flex justify-content-end">
                <nav>
                    <ul class="pagination pagination-sm mb-0">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="?action=requestList&page=${currentPage - 1}">Previous</a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link" href="?action=requestList&page=${i}">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="?action=requestList&page=${currentPage + 1}">Next</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </c:if>
    </div>

    <script>
        function filterTable(status) {
            var rows = document.querySelectorAll('#usageTable tbody tr');
            rows.forEach(function(row) {
                if (status === 'all') {
                    row.style.display = '';
                } else {
                    row.style.display = (row.getAttribute('data-status') === status) ? '' : 'none';
                }
            });
        }
    </script>

</t:layout>
