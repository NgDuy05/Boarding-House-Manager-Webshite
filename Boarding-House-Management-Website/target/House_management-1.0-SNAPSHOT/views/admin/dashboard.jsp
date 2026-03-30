<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page session="true"%>
<%@taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="t"   tagdir="/WEB-INF/tags"%>

<t:layout>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="mb-0 fw-bold">Admin Dashboard</h4>
            <small class="text-muted">Welcome back, <strong>${sessionScope.user.fullName}</strong></small>
        </div>
        <span class="badge bg-danger text-uppercase">${sessionScope.user.role}</span>
    </div>

    <!-- STAT CARDS -->
    <div class="row g-3 mb-4">
        <div class="col-sm-6 col-xl-3">
            <div class="card border-0 shadow-sm p-3">
                <div class="d-flex align-items-center gap-3">
                    <div class="rounded-circle bg-primary bg-opacity-10 p-3">
                        <i class="bi bi-house-door text-primary fs-5"></i>
                    </div>
                    <div>
                        <div class="text-muted small">Total Rooms</div>
                        <div class="fw-bold fs-5">—</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-sm-6 col-xl-3">
            <div class="card border-0 shadow-sm p-3">
                <div class="d-flex align-items-center gap-3">
                    <div class="rounded-circle bg-success bg-opacity-10 p-3">
                        <i class="bi bi-file-earmark-check text-success fs-5"></i>
                    </div>
                    <div>
                        <div class="text-muted small">Active Contracts</div>
                        <div class="fw-bold fs-5">—</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-sm-6 col-xl-3">
            <div class="card border-0 shadow-sm p-3">
                <div class="d-flex align-items-center gap-3">
                    <div class="rounded-circle bg-danger bg-opacity-10 p-3">
                        <i class="bi bi-receipt text-danger fs-5"></i>
                    </div>
                    <div>
                        <div class="text-muted small">Unpaid Bills</div>
                        <div class="fw-bold fs-5">—</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-sm-6 col-xl-3">
            <div class="card border-0 shadow-sm p-3">
                <div class="d-flex align-items-center gap-3">
                    <div class="rounded-circle bg-warning bg-opacity-10 p-3">
                        <i class="bi bi-people text-warning fs-5"></i>
                    </div>
                    <div>
                        <div class="text-muted small">Customers</div>
                        <div class="fw-bold fs-5">—</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- QUICK ACCESS -->
    <h6 class="text-muted text-uppercase mb-3" style="font-size:0.72rem;letter-spacing:.08em;">Quick Access</h6>
    <div class="row g-3">
        <div class="col-sm-6 col-lg-4">
            <a href="${pageContext.request.contextPath}/bill?action=list" class="text-decoration-none">
                <div class="card border-0 shadow-sm p-3 h-100 d-flex flex-row align-items-center gap-3">
                    <div class="rounded-circle bg-primary bg-opacity-10 p-3">
                        <i class="bi bi-receipt text-primary"></i>
                    </div>
                    <div>
                        <div class="fw-semibold">Bills</div>
                        <div class="text-muted small">View and manage all bills</div>
                    </div>
                </div>
            </a>
        </div>
        <div class="col-sm-6 col-lg-4">
            <a href="${pageContext.request.contextPath}/contract?action=list" class="text-decoration-none">
                <div class="card border-0 shadow-sm p-3 h-100 d-flex flex-row align-items-center gap-3">
                    <div class="rounded-circle bg-success bg-opacity-10 p-3">
                        <i class="bi bi-file-earmark-text text-success"></i>
                    </div>
                    <div>
                        <div class="fw-semibold">Contracts</div>
                        <div class="text-muted small">Manage rental contracts</div>
                    </div>
                </div>
            </a>
        </div>
        <div class="col-sm-6 col-lg-4">
            <a href="${pageContext.request.contextPath}/manage-customer" class="text-decoration-none">
                <div class="card border-0 shadow-sm p-3 h-100 d-flex flex-row align-items-center gap-3">
                    <div class="rounded-circle bg-warning bg-opacity-10 p-3">
                        <i class="bi bi-people text-warning"></i>
                    </div>
                    <div>
                        <div class="fw-semibold">Customers</div>
                        <div class="text-muted small">View and edit tenants</div>
                    </div>
                </div>
            </a>
        </div>
        <div class="col-sm-6 col-lg-4">
            <a href="${pageContext.request.contextPath}/room" class="text-decoration-none">
                <div class="card border-0 shadow-sm p-3 h-100 d-flex flex-row align-items-center gap-3">
                    <div class="rounded-circle bg-info bg-opacity-10 p-3">
                        <i class="bi bi-house-door text-info"></i>
                    </div>
                    <div>
                        <div class="fw-semibold">Rooms</div>
                        <div class="text-muted small">Manage room listings</div>
                    </div>
                </div>
            </a>
        </div>
        <div class="col-sm-6 col-lg-4">
            <a href="${pageContext.request.contextPath}/utility" class="text-decoration-none">
                <div class="card border-0 shadow-sm p-3 h-100 d-flex flex-row align-items-center gap-3">
                    <div class="rounded-circle bg-secondary bg-opacity-10 p-3">
                        <i class="bi bi-lightning-charge text-secondary"></i>
                    </div>
                    <div>
                        <div class="fw-semibold">Utilities</div>
                        <div class="text-muted small">Electricity, water, gas</div>
                    </div>
                </div>
            </a>
        </div>
        <div class="col-sm-6 col-lg-4">
            <a href="${pageContext.request.contextPath}/activity-log" class="text-decoration-none">
                <div class="card border-0 shadow-sm p-3 h-100 d-flex flex-row align-items-center gap-3">
                    <div class="rounded-circle bg-danger bg-opacity-10 p-3">
                        <i class="bi bi-activity text-danger"></i>
                    </div>
                    <div>
                        <div class="fw-semibold">Activity Logs</div>
                        <div class="text-muted small">Audit trail &amp; history</div>
                    </div>
                </div>
            </a>
        </div>
    </div>

</t:layout>
