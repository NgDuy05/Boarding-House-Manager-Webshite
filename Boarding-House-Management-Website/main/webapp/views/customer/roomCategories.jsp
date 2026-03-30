<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Room Categories - AKDD House</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { background: #f4f6f9; font-family: 'Inter', sans-serif; }

        /* ── Hero ── */
        .page-hero {
            background: linear-gradient(135deg, #4f46e5, #7c3aed);
            color: #fff; padding: 48px 0 56px; margin-bottom: -32px;
        }
        .page-hero h1 { font-weight: 700; font-size: 2rem; }
        .page-hero p  { opacity: .85; }

        /* ── Filter bar ── */
        .filter-label {
            font-size: .72rem; font-weight: 700; text-transform: uppercase;
            letter-spacing: .6px; color: #9ca3af; margin-bottom: .4rem;
        }
        .filter-bar {
            background: #fff; border-radius: 50px; padding: 6px;
            display: inline-flex; flex-wrap: wrap; gap: 4px;
            box-shadow: 0 2px 12px rgba(0,0,0,.08);
        }
        .filter-btn {
            border-radius: 50px; border: none; padding: 7px 16px;
            font-weight: 700; font-size: .82rem; cursor: pointer;
            display: inline-flex; align-items: center; gap: .35rem;
            color: #6b7280; background: transparent;
            transition: all .2s; white-space: nowrap;
        }
        .filter-btn:hover  { background: #f3f4f6; color: #374151; }
        .filter-btn.active { background: #FF9005; color: #fff; }
        .filter-count {
            background: #e5e7eb; color: #374151;
            border-radius: 20px; padding: 1px 7px; font-size: .72rem;
        }
        .filter-btn.active .filter-count { background: rgba(255,255,255,.3); color: #fff; }

        /* ── Section heading ── */
        .section-heading {
            font-weight: 700; font-size: 1.15rem; color: #1e1b4b; margin-bottom: 1rem;
        }

        /* ── Room cards ── */
        .room-card {
            border-radius: 12px; border: none;
            box-shadow: 0 2px 12px rgba(0,0,0,.08);
            overflow: hidden; transition: transform .2s, box-shadow .2s;
            background: #fff; height: 100%;
        }
        .room-card:hover { transform: translateY(-4px); box-shadow: 0 10px 28px rgba(0,0,0,.14); }
        .room-img-wrap {
            position: relative; height: 185px; overflow: hidden; background: #f3f4f6;
        }
        .room-img-wrap img {
            width: 100%; height: 100%; object-fit: cover; transition: transform .3s;
        }
        .room-card:hover .room-img-wrap img { transform: scale(1.05); }
        .room-placeholder {
            position: absolute; inset: 0; display: none;
            flex-direction: column; align-items: center; justify-content: center;
            gap: .5rem; color: #aaa;
        }
        .room-placeholder i { font-size: 2.5rem; }
        .status-badge {
            position: absolute; top: 10px; right: 10px;
            border-radius: 20px; padding: 3px 10px;
            font-size: .7rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: .4px;
        }
        .status-available   { background: #d1fae5; color: #059669; }
        .status-occupied    { background: #fee2e2; color: #dc2626; }
        .status-maintenance { background: #fef9c3; color: #d97706; }
        .room-category-tag {
            display: inline-block; background: #fff3e0; color: #e65100;
            border-radius: 8px; padding: 2px 9px;
            font-size: .72rem; font-weight: 700; margin-bottom: .5rem;
        }
        .room-price { font-size: .95rem; color: #FF9005; font-weight: 700; margin-bottom: .75rem; }
        .room-price .price-label { font-size: .75rem; color: #9ca3af; font-weight: 400; }
        .btn-book {
            display: block; text-align: center; background: #FF9005;
            color: #fff; border-radius: 8px; padding: 8px 0;
            font-weight: 700; font-size: .88rem;
            text-decoration: none; transition: background .2s; border: none;
        }
        .btn-book:hover { background: #e08000; color: #fff; }
        .btn-book.disabled { background: #e5e7eb; color: #9ca3af; pointer-events: none; }
        .btn-detail {
            display: block; text-align: center;
            border: 2px solid #4f46e5; color: #4f46e5;
            border-radius: 8px; padding: 7px 0;
            font-weight: 700; font-size: .82rem;
            text-decoration: none; transition: all .2s; margin-bottom: .5rem;
        }
        .btn-detail:hover { background: #4f46e5; color: #fff; }

        /* ── Results info ── */
        .results-info { font-size: .83rem; color: #9ca3af; margin-bottom: 1rem; }
        .results-info strong { color: #FF9005; }

        /* ── Empty state ── */
        .empty-state { text-align: center; padding: 4rem 1rem; color: #9ca3af; }
        .empty-state i { font-size: 3rem; margin-bottom: 1rem; }

        /* ── Rooms section anchor scroll ── */
        #roomsSection { scroll-margin-top: 80px; }
    </style>
</head>
<body>
    <%@ include file="../navbar.jsp" %>

    <div class="container-fluid p-0">
      <div class="row g-0" style="min-height: calc(100vh - 56px);">
        <%@ include file="sidebar.jsp" %>
        <main class="col p-0">

    <%-- Hero --%>
    <div class="page-hero">
        <div class="container">
            <nav aria-label="breadcrumb" class="mb-3">
                <ol class="breadcrumb"
                    style="--bs-breadcrumb-divider-color:rgba(255,255,255,.5);color:rgba(255,255,255,.7)">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/" class="text-white text-opacity-75">Home</a>
                    </li>
                    <li class="breadcrumb-item active text-white">Rooms</li>
                </ol>
            </nav>
            <h1><i class="bi bi-grid-3x3-gap me-2"></i>Browse Rooms</h1>
            <p class="mb-0">Explore room types and find the perfect fit — filter by category or availability</p>
        </div>
    </div>

    <div class="container pb-5" style="padding-top: 48px;">

        <%-- ====== Filter bar row ====== --%>
        <div class="row align-items-start g-3 mb-4">
            <div class="col-md-8">
                <div class="filter-label"><i class="bi bi-tag me-1"></i>Category</div>
                <div class="filter-bar" id="catFilterBar">
                    <button class="filter-btn active" data-cat="0" onclick="setCategory(0)">
                        <i class="bi bi-grid-3x3-gap"></i> All Types
                    </button>
                    <c:forEach var="cat" items="${categories}">
                        <button class="filter-btn" data-cat="${cat.categoryId}"
                                onclick="setCategory(${cat.categoryId})">
                            ${cat.categoryName}
                            <span class="filter-count">${cat.roomCount}</span>
                        </button>
                    </c:forEach>
                </div>
            </div>
            <div class="col-md-4">
                <div class="filter-label"><i class="bi bi-circle-half me-1"></i>Status</div>
                <div class="filter-bar" id="statusFilterBar">
                    <button class="filter-btn active" data-status="" onclick="setStatus('')">
                        <i class="bi bi-grid"></i> All
                    </button>
                    <button class="filter-btn" data-status="available" onclick="setStatus('available')">
                        <i class="bi bi-check-circle"></i> Available
                        <span class="filter-count">${statusCounts['available']}</span>
                    </button>
                    <button class="filter-btn" data-status="occupied" onclick="setStatus('occupied')">
                        <i class="bi bi-person-fill-check"></i> Occupied
                        <span class="filter-count">${statusCounts['occupied']}</span>
                    </button>
                    <button class="filter-btn" data-status="maintenance" onclick="setStatus('maintenance')">
                        <i class="bi bi-tools"></i> Maintenance
                        <span class="filter-count">${statusCounts['maintenance']}</span>
                    </button>
                </div>
            </div>
        </div>

        <%-- ====== Rooms section ====== --%>
        <div id="roomsSection">
            <div class="d-flex align-items-center justify-content-between mb-3">
                <div class="section-heading mb-0"><i class="bi bi-door-open me-2"></i>Rooms</div>
                <div class="results-info mb-0" id="resultsInfo">Loading...</div>
            </div>

            <div id="roomGrid" class="row g-4">
                <%-- Populated by JS --%>
            </div>

            <div id="emptyState" class="empty-state" style="display:none;">
                <i class="bi bi-door-closed d-block"></i>
                <h5>No rooms match your filters</h5>
                <p>Try selecting a different category or status.</p>
                <button class="btn btn-warning fw-bold px-4" style="color:#fff" onclick="resetFilters()">
                    <i class="bi bi-arrow-counterclockwise me-1"></i>Reset Filters
                </button>
            </div>

            <div id="pagination" class="d-flex justify-content-center mt-4"></div>
        </div>

    </div>

    <%-- Embed rooms data for client-side filtering.
         NOTE: Template literals (`${}`) cannot be used inside JSP <script> blocks
         because the JSP parser intercepts ${} as EL expressions.
         All JS string building uses concatenation (+) instead. --%>
    <script>
    var CTX = '<%= request.getContextPath() %>';

    var allRooms = [
        <c:forEach var="room" items="${allRooms}" varStatus="loop">
        {
            roomId:       ${room.roomId},
            roomNumber:   "<c:out value="${room.roomNumber}" escapeXml="false"/>",
            status:       "${room.status}",
            image:        "<c:out value="${room.image}" escapeXml="false"/>",
            categoryId:   ${room.categoryId},
            categoryName: "<c:out value="${room.categoryName}" escapeXml="false"/>",
            basePrice:    ${not empty room.basePrice ? room.basePrice : 0}
        }<c:if test="${!loop.last}">,</c:if>
        </c:forEach>
    ];

    var activeCategoryId = 0;
    var activeStatus     = '';
    var currentPage      = 1;
    var PAGE_SIZE        = 8;  /* rooms per page */

    /* catNameMap: populated at DOMContentLoaded from rendered pill buttons */
    var catNameMap = {};

    /* ── filter setters — reset page on filter change ── */
    function setCategory(catId) {
        activeCategoryId = (activeCategoryId === catId) ? 0 : catId;
        currentPage = 1;
        applyFilters();
    }

    function setStatus(status) {
        // toggle: clicking same chip/pill again clears it
        activeStatus = (activeStatus === status) ? '' : status;
        currentPage = 1;
        applyFilters();
    }

    function resetFilters() {
        activeCategoryId = 0;
        activeStatus = '';
        currentPage = 1;
        applyFilters();
    }

    function goToPage(page) {
        currentPage = page;
        applyFilters();
        document.getElementById('roomsSection').scrollIntoView({ behavior: 'smooth' });
    }

    /* ── core filter + render ── */
    function applyFilters() {
        var filtered = allRooms.filter(function(r) {
            var catOk    = activeCategoryId === 0 || r.categoryId === activeCategoryId;
            var statusOk = activeStatus === '' || r.status === activeStatus;
            return catOk && statusOk;
        });
        var totalPages = Math.max(1, Math.ceil(filtered.length / PAGE_SIZE));
        if (currentPage > totalPages) currentPage = totalPages;
        var from = (currentPage - 1) * PAGE_SIZE;
        var pageRooms = filtered.slice(from, from + PAGE_SIZE);

        renderRooms(pageRooms, filtered.length === 0);
        renderPagination(filtered.length, totalPages);
        updateResultsInfo(filtered);
        updateActiveButtons();
    }

    function renderRooms(rooms, isEmpty) {
        var grid  = document.getElementById('roomGrid');
        var empty = document.getElementById('emptyState');

        if (isEmpty) {
            grid.innerHTML = '';
            empty.style.display = '';
            return;
        }
        empty.style.display = 'none';

        var html = '';
        for (var i = 0; i < rooms.length; i++) {
            var r = rooms[i];
            var imgSrc     = r.image ? CTX + '/assets/images/room/' + escHtml(r.image) : '';
            var statusCls  = escHtml(r.status);
            var statusLbl  = r.status.charAt(0).toUpperCase() + r.status.slice(1);
            var catTag     = r.categoryName
                ? '<span class="room-category-tag"><i class="bi bi-tag me-1"></i>' + escHtml(r.categoryName) + '</span>'
                : '';
            var priceHtml  = r.basePrice > 0
                ? '<div class="room-price">' + formatNum(r.basePrice) + '&#8363;<span class="price-label"> / month</span></div>'
                : '';
            var detailUrl  = CTX + '/room?action=publicDetail&id=' + r.roomId;
            var bookBtn    = r.status === 'maintenance'
                ? '<a href="' + detailUrl + '" class="btn-detail"><i class="bi bi-eye me-1"></i>View Details</a>'
                + '<span class="btn-book disabled"><i class="bi bi-x-circle me-1"></i>Unavailable</span>'
                : '<a href="' + detailUrl + '" class="btn-detail"><i class="bi bi-eye me-1"></i>View Details</a>'
                + '<a href="' + detailUrl + '" class="btn-book"><i class="bi bi-calendar-check me-1"></i>Book Now</a>';
            var imgTag     = imgSrc
                ? '<img src="' + imgSrc + '" alt="Room ' + escHtml(r.roomNumber) + '"'
                + ' onerror="this.onerror=null;this.style.display=\'none\';this.parentElement.querySelector(\'.room-placeholder\').style.display=\'flex\';">'
                : '';

            html += '<div class="col-sm-6 col-lg-3">'
                + '<div class="room-card">'
                +   '<div class="room-img-wrap">'
                +     imgTag
                +     '<div class="room-placeholder"><i class="bi bi-door-closed"></i>'
                +       '<span style="font-size:.8rem">Room ' + escHtml(r.roomNumber) + '</span></div>'
                +     '<span class="status-badge status-' + statusCls + '">' + statusLbl + '</span>'
                +   '</div>'
                +   '<div class="card-body">'
                +     '<h5 class="fw-bold mb-1">Room ' + escHtml(r.roomNumber) + '</h5>'
                +     catTag + priceHtml + bookBtn
                +   '</div>'
                + '</div>'
                + '</div>';
        }
        grid.innerHTML = html;
    }

    function renderPagination(totalItems, totalPages) {
        var el = document.getElementById('pagination');
        if (totalPages <= 1) { el.innerHTML = ''; return; }

        var html = '<ul class="pagination">';
        /* Previous */
        html += '<li class="page-item ' + (currentPage === 1 ? 'disabled' : '') + '">'
            + '<button class="page-link" onclick="goToPage(' + (currentPage - 1) + ')">&laquo;</button></li>';
        /* Page numbers — show max 5 around current */
        var start = Math.max(1, currentPage - 2);
        var end   = Math.min(totalPages, start + 4);
        start     = Math.max(1, end - 4);
        if (start > 1) html += '<li class="page-item disabled"><span class="page-link">...</span></li>';
        for (var i = start; i <= end; i++) {
            html += '<li class="page-item ' + (i === currentPage ? 'active' : '') + '">'
                + '<button class="page-link" onclick="goToPage(' + i + ')">' + i + '</button></li>';
        }
        if (end < totalPages) html += '<li class="page-item disabled"><span class="page-link">...</span></li>';
        /* Next */
        html += '<li class="page-item ' + (currentPage === totalPages ? 'disabled' : '') + '">'
            + '<button class="page-link" onclick="goToPage(' + (currentPage + 1) + ')">&raquo;</button></li>';
        html += '</ul>';
        el.innerHTML = html;
    }

    function updateResultsInfo(filtered) {
        var info  = document.getElementById('resultsInfo');
        var total = filtered.length;
        var from  = Math.min((currentPage - 1) * PAGE_SIZE + 1, total);
        var to    = Math.min(currentPage * PAGE_SIZE, total);
        var label = total === 0 ? 'No rooms found'
            : 'Showing <strong>' + from + '-' + to + '</strong> of <strong>' + total + '</strong> room' + (total !== 1 ? 's' : '');
        if (activeCategoryId !== 0) {
            var catName = catNameMap[activeCategoryId];
            if (catName) label += ' in <strong>' + escHtml(catName) + '</strong>';
        }
        if (activeStatus !== '') {
            label += ' &middot; <strong>' + activeStatus + '</strong>';
        }
        info.innerHTML = label;
    }

    function updateActiveButtons() {
        /* Category filter bar */
        document.querySelectorAll('#catFilterBar .filter-btn').forEach(function(btn) {
            btn.classList.toggle('active', parseInt(btn.dataset.cat, 10) === activeCategoryId);
        });
        /* Status filter bar */
        document.querySelectorAll('#statusFilterBar .filter-btn').forEach(function(btn) {
            btn.classList.toggle('active', btn.dataset.status === activeStatus);
        });
    }

    /* ── helpers ── */
    function escHtml(str) {
        return String(str)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;');
    }
    function formatNum(n) {
        return Number(n).toLocaleString('vi-VN');
    }

    /* ── init ── */
    document.addEventListener('DOMContentLoaded', function() {
        /* Build category name map from rendered pill buttons */
        document.querySelectorAll('#catFilterBar .filter-btn[data-cat]').forEach(function(btn) {
            var id = parseInt(btn.dataset.cat, 10);
            if (id !== 0) {
                catNameMap[id] = btn.textContent.trim().replace(/\s*\d+\s*$/, '').trim();
            }
        });
        applyFilters();
    });
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        </main>
      </div>
    </div>
</body>
</html>
