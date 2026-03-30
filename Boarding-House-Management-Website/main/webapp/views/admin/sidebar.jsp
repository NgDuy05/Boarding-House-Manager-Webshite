<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- Admin Sidebar — included in all admin management pages --%>
<style>
    .admin-sidebar {
        min-height: calc(100vh - 56px);
        background: #212529;
        position: sticky;
        top: 56px;
        height: calc(100vh - 56px);
        overflow-y: auto;
    }
    .admin-sidebar .nav-link {
        color: #adb5bd;
        border-radius: 6px;
        margin-bottom: 2px;
        padding: 0.45rem 1rem;
        font-size: 0.875rem;
    }
    .admin-sidebar .nav-link:hover,
    .admin-sidebar .nav-link.active {
        color: #fff;
        background-color: #343a40;
    }
    .admin-sidebar .nav-link i { width: 20px; }
    .sidebar-heading {
        color: #6c757d;
        font-size: 0.68rem;
        text-transform: uppercase;
        letter-spacing: 0.08em;
        padding: 0.75rem 1rem 0.2rem;
    }
    /* Make the row containing the sidebar fill the remaining height */
    .admin-layout-row { flex: 1; }
    .admin-main {
        flex: 1;
        min-width: 0;
        display: flex;
        flex-direction: column;
        min-height: calc(100vh - 56px);
    }
    .admin-main > footer { margin-top: auto; }
</style>

<nav class="col-md-3 col-lg-2 d-md-block admin-sidebar py-3 px-2">

    <div class="sidebar-heading">Overview</div>
    <ul class="nav flex-column">
        <li class="nav-item">
            <a class="nav-link ${pageContext.request.requestURI.contains('/dashboard') ? 'active' : ''}"
               href="${pageContext.request.contextPath}/dashboard">
                <i class="bi bi-speedometer2 me-2"></i>Dashboard
            </a>
        </li>
    </ul>

    <div class="sidebar-heading mt-2">Finance</div>
    <ul class="nav flex-column">
        <li class="nav-item">
            <a class="nav-link ${pageContext.request.requestURI.contains('/bill') ? 'active' : ''}"
               href="${pageContext.request.contextPath}/bill?action=list">
                <i class="bi bi-receipt me-2"></i>Bills
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${pageContext.request.requestURI.contains('/deposit') ? 'active' : ''}"
               href="${pageContext.request.contextPath}/deposit">
                <i class="bi bi-bank me-2"></i>Deposits
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${pageContext.request.requestURI.contains('/price') ? 'active' : ''}"
               href="${pageContext.request.contextPath}/price">
                <i class="bi bi-tag me-2"></i>Price Categories
            </a>
        </li>
    </ul>

    <div class="sidebar-heading mt-2">Properties</div>
    <ul class="nav flex-column">
        <li class="nav-item">
            <a class="nav-link ${pageContext.request.requestURI.contains('/room') ? 'active' : ''}"
               href="${pageContext.request.contextPath}/room">
                <i class="bi bi-house-door me-2"></i>Rooms
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${pageContext.request.requestURI.contains('/facility') ? 'active' : ''}"
               href="${pageContext.request.contextPath}/facility">
                <i class="bi bi-wrench me-2"></i>Facilities
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${pageContext.request.requestURI.contains('/amenity') ? 'active' : ''}"
               href="${pageContext.request.contextPath}/amenity">
                <i class="bi bi-stars me-2"></i>Amenities
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${pageContext.request.requestURI.contains('/utility') ? 'active' : ''}"
               href="${pageContext.request.contextPath}/utility">
                <i class="bi bi-lightning-charge me-2"></i>Utilities
            </a>
        </li>
    </ul>

    <div class="sidebar-heading mt-2">Tenants</div>
    <ul class="nav flex-column">
        <li class="nav-item">
            <a class="nav-link ${pageContext.request.requestURI.contains('/contract') ? 'active' : ''}"
               href="${pageContext.request.contextPath}/contract?action=list">
                <i class="bi bi-file-earmark-text me-2"></i>Contracts
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${pageContext.request.requestURI.contains('/manage-customer') ? 'active' : ''}"
               href="${pageContext.request.contextPath}/manage-customer">
                <i class="bi bi-people me-2"></i>Customers
            </a>
        </li>
    </ul>

    <div class="sidebar-heading mt-2">Services</div>
    <ul class="nav flex-column">
        <li class="nav-item">
            <a class="nav-link ${param.action == 'adminList' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/services?action=adminList">
                <i class="bi bi-grid me-2"></i>Manage Services
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${param.action == 'manageRequests' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/services?action=manageRequests">
                <i class="bi bi-clipboard2-check me-2"></i>Service Requests
            </a>
        </li>
    </ul>

    <div class="sidebar-heading mt-2">System</div>
    <ul class="nav flex-column">
        <li class="nav-item">
            <a class="nav-link ${pageContext.request.requestURI.contains('/user') ? 'active' : ''}"
               href="${pageContext.request.contextPath}/user?action=list">
                <i class="bi bi-person-gear me-2"></i>Users
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${pageContext.request.requestURI.contains('/notification') ? 'active' : ''}"
               href="${pageContext.request.contextPath}/notification?action=list">
                <i class="bi bi-bell me-2"></i>Notifications
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${pageContext.request.requestURI.contains('/activity-log') ? 'active' : ''}"
               href="${pageContext.request.contextPath}/activity-log">
                <i class="bi bi-activity me-2"></i>Activity Logs
            </a>
        </li>
    </ul>

</nav>
