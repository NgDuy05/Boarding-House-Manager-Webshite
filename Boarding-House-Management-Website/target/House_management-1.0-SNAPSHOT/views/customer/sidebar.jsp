<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- Customer Sidebar — included in all customer pages --%>
<style>
    .customer-sidebar {
        min-height: calc(100vh - 56px);
        background: #1e293b;
        position: sticky;
        top: 56px;
        height: calc(100vh - 56px);
        overflow-y: auto;
    }
    .customer-sidebar .nav-link {
        color: #94a3b8;
        border-radius: 6px;
        margin-bottom: 2px;
        padding: 0.45rem 1rem;
        font-size: 0.875rem;
    }
    .customer-sidebar .nav-link:hover,
    .customer-sidebar .nav-link.active {
        color: #fff;
        background-color: #334155;
    }
    .customer-sidebar .nav-link i { width: 20px; }
    .sidebar-heading {
        color: #64748b;
        font-size: 0.68rem;
        text-transform: uppercase;
        letter-spacing: 0.08em;
        padding: 0.75rem 1rem 0.2rem;
    }
</style>

<nav class="col-md-2 d-md-block customer-sidebar py-3 px-2">

    <div class="sidebar-heading">My Account</div>
    <ul class="nav flex-column">
        <li class="nav-item">
            <a class="nav-link ${pageContext.request.requestURI.contains('/dashboard') ? 'active' : ''}"
               href="${pageContext.request.contextPath}/dashboard">
                <i class="bi bi-speedometer2 me-2"></i>Dashboard
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${pageContext.request.requestURI.contains('/customer') && param.action == 'profile' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/customer?action=profile">
                <i class="bi bi-person-circle me-2"></i>My Profile
            </a>
        </li>
    </ul>

    <div class="sidebar-heading mt-2">Billing</div>
    <ul class="nav flex-column">
        <li class="nav-item">
            <a class="nav-link ${pageContext.request.requestURI.contains('/bill') ? 'active' : ''}"
               href="${pageContext.request.contextPath}/bill?action=mybill">
                <i class="bi bi-receipt me-2"></i>My Bills
            </a>
        </li>
    </ul>

    <div class="sidebar-heading mt-2">Contracts</div>
    <ul class="nav flex-column">
        <li class="nav-item">
            <a class="nav-link ${pageContext.request.requestURI.contains('/contract') && param.action != 'signContract' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/contract?action=mycontract">
                <i class="bi bi-file-earmark-text me-2"></i>My Contracts
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${param.action == 'signContract' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/contract?action=signContract">
                <i class="bi bi-pen me-2"></i>Sign Contract
            </a>
        </li>
    </ul>

    <div class="sidebar-heading mt-2">Services</div>
    <ul class="nav flex-column">
        <li class="nav-item">
            <a class="nav-link ${pageContext.request.requestURI.contains('/services') && empty param.action ? 'active' : ''}"
               href="${pageContext.request.contextPath}/services">
                <i class="bi bi-grid me-2"></i>Browse Services
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${param.action == 'myHistory' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/services?action=myHistory">
                <i class="bi bi-clock-history me-2"></i>My Service History
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${param.action == 'requestService' || param.action == 'requestForm' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/services?action=requestService">
                <i class="bi bi-send me-2"></i>Request Service
            </a>
        </li>
    </ul>

    <div class="sidebar-heading mt-2">Notifications</div>
    <ul class="nav flex-column">
        <li class="nav-item">
            <a class="nav-link ${pageContext.request.requestURI.contains('/notification') ? 'active' : ''}"
               href="${pageContext.request.contextPath}/notification?action=publicList">
                <i class="bi bi-bell me-2"></i>Notifications
            </a>
        </li>
    </ul>

    <div class="sidebar-heading mt-2">Rooms</div>
    <ul class="nav flex-column">
        <li class="nav-item">
            <a class="nav-link ${pageContext.request.requestURI.contains('/room') ? 'active' : ''}"
               href="${pageContext.request.contextPath}/room?action=categories">
                <i class="bi bi-house-door me-2"></i>Browse Rooms
            </a>
        </li>
    </ul>

    <div class="sidebar-heading mt-2">Account</div>
    <ul class="nav flex-column">
        <li class="nav-item">
            <a class="nav-link ${pageContext.request.requestURI.contains('/auth') && param.action == 'changePassword' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/auth?action=changePassword">
                <i class="bi bi-shield-lock me-2"></i>Change Password
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link text-danger"
               href="${pageContext.request.contextPath}/auth?action=logout">
                <i class="bi bi-box-arrow-right me-2"></i>Logout
            </a>
        </li>
    </ul>

</nav>
