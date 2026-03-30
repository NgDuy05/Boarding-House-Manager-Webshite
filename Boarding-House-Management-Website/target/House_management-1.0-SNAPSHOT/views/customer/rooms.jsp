<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Room List - AKDD House</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
    <style>
        /* ── Base (from rooms.html) ── */
        body {
            background-color: rgba(0,0,0,0.06);
            font-family: 'Lato', sans-serif;
        }

        /* ── Search bar (from rooms.html) ── */
        .s-box {
            display: inline-block;
            padding: 10px;
        }
        .s-box-text-a {
            padding: 38px 10px 10px;
            font-weight: 700;
            color: #555;
        }
        .s-box-text { padding: 38px 10px 10px; font-weight: 700; color: #555; }
        .search-wrap {
            text-align: center;
            margin: 20px 0 10px;
        }
        .search-inner {
            display: inline-block;
            width: 60%;
            background-color: rgba(255,255,255,0.8);
            border-radius: 8px;
            padding: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,.08);
        }

        /* ── Section title (from rooms.html .room-title-new) ── */
        .room-title-new {
            font-size: 1.5rem;
            font-weight: 700;
            color: #333;
            display: block;
            padding: 16px 0 4px;
        }
        .room-title-new hr { margin: 6px 0 12px; border-color: #FF9005; }

        /* ── Filter bar (pill style adapted) ── */
        .filter-label {
            font-size: .72rem; font-weight: 700; text-transform: uppercase;
            letter-spacing: .6px; color: #9ca3af; margin-bottom: .4rem;
        }
        .filter-bar {
            background: #fff;
            border-radius: 50px;
            padding: 6px;
            display: inline-flex;
            flex-wrap: wrap;
            gap: 4px;
            box-shadow: 0 2px 12px rgba(0,0,0,.08);
        }
        .filter-btn {
            border-radius: 50px; border: none;
            padding: 7px 16px;
            font-weight: 700; font-size: .82rem;
            cursor: pointer; text-decoration: none;
            display: inline-flex; align-items: center; gap: .35rem;
            color: #6b7280; background: transparent;
            transition: all .2s; white-space: nowrap;
        }
        .filter-btn:hover  { background: #f3f4f6; color: #374151; }
        .filter-btn.active { background: #FF9005; color: #fff; }
        .filter-count {
            background: rgba(255,255,255,.3);
            border-radius: 20px; padding: 1px 7px; font-size: .72rem;
        }
        .filter-btn:not(.active) .filter-count { background: #e5e7eb; color: #374151; }

        /* ── Room card (from rooms.html Bootstrap card) ── */
        .card {
            border-radius: 12px;
            border: none;
            box-shadow: 0 2px 12px rgba(0,0,0,.08);
            overflow: hidden;
            transition: transform .2s, box-shadow .2s;
            height: 100%;
        }
        .card:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 28px rgba(0,0,0,.14);
        }
        .card-img-wrap {
            position: relative;
            height: 185px;
            overflow: hidden;
            background: #f3f4f6;
        }
        .card-img-wrap .card-img-top {
            width: 100%; height: 100%;
            object-fit: cover;
            transition: transform .3s;
        }
        .card:hover .card-img-wrap .card-img-top { transform: scale(1.05); }

        .room-placeholder {
            position: absolute; inset: 0;
            display: none; flex-direction: column;
            align-items: center; justify-content: center;
            gap: .5rem; color: #aaa;
        }
        .room-placeholder i { font-size: 2.5rem; }

        /* Status badge over card image */
        .status-badge {
            position: absolute; top: 10px; right: 10px;
            border-radius: 20px; padding: 3px 10px;
            font-size: .7rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: .4px;
        }
        .status-available   { background: #d1fae5; color: #059669; }
        .status-occupied    { background: #fee2e2; color: #dc2626; }
        .status-maintenance { background: #fef9c3; color: #d97706; }

        /* Category tag */
        .room-category-tag {
            display: inline-block;
            background: #fff3e0; color: #e65100;
            border-radius: 8px; padding: 2px 9px;
            font-size: .72rem; font-weight: 700;
            margin-bottom: .5rem;
        }
        .room-price {
            font-size: .95rem; color: #FF9005; font-weight: 700;
            margin-bottom: .75rem;
        }
        .room-price .price-label { font-size: .75rem; color: #9ca3af; font-weight: 400; }

        /* Book Now button (from rooms.html .btn-warning) */
        .btn-book {
            display: block; text-align: center;
            background: #FF9005;
            color: #fff; border-radius: 8px;
            padding: 8px 0; font-weight: 700; font-size: .88rem;
            text-decoration: none; transition: background .2s;
            border: none;
        }
        .btn-book:hover { background: #e08000; color: #fff; }
        .btn-book.disabled {
            background: #e5e7eb; color: #9ca3af; pointer-events: none;
        }

        /* ── Section wrapper (from rooms.html .h-rooms) ── */
        .h-rooms { padding: 0 8px 24px; }
        .card-set { padding: 8px 0; }

        /* ── Results info ── */
        .results-info { font-size: .83rem; color: #9ca3af; margin-bottom: 1rem; }
        .results-info strong { color: #FF9005; }

        /* ── Empty state ── */
        .empty-state { text-align: center; padding: 4rem 1rem; color: #9ca3af; }
        .empty-state i { font-size: 3rem; margin-bottom: 1rem; }

        /* ── Footer (from rooms.html) ── */
        .footer-section {
            background: #222;
            color: #ccc;
            padding: 28px 0 18px;
            margin-top: 32px;
        }
        .footer-section h3 { color: #fff; font-size: 1.1rem; font-weight: 700; }
        .footer-section h5 { color: #ccc; font-size: .9rem; font-weight: 400; }
        .footer-section a { color: #FF9005; font-size: 1.2rem; }
        .footer-section a:hover { color: #fff; }
    </style>
</head>
<body>
    <%@ include file="../navbar.jsp" %>

    <div class="container-fluid p-0">
      <div class="row g-0" style="min-height: calc(100vh - 56px);">
        <%@ include file="sidebar.jsp" %>
        <main class="col p-0">

    <%-- Search bar (from rooms.html) --%>
    <div class="search-wrap">
        <div class="search-inner">
            <form action="${pageContext.request.contextPath}/room" method="get">
                <input type="hidden" name="action" value="publicList">
                <div class="row align-items-end g-2 justify-content-center">
                    <div class="col-auto">
                        <label class="form-label fw-bold mb-1" style="font-size:.85rem;color:#555">Check In:</label>
                        <input type="date" name="checkIn" class="form-control form-control-sm">
                    </div>
                    <div class="col-auto">
                        <label class="form-label fw-bold mb-1" style="font-size:.85rem;color:#555">Check Out:</label>
                        <input type="date" name="checkOut" class="form-control form-control-sm">
                    </div>
                    <div class="col-auto">
                        <button type="submit" class="btn btn-warning btn-sm fw-bold"
                                style="color:#fff; padding: 6px 18px;">
                            <i class="bi bi-search"></i>
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <div class="container pb-4" style="padding-top: 20px;">

        <%-- Category filter --%>
        <c:if test="${not empty categories}">
            <div class="mb-2">
                <div class="filter-label"><i class="bi bi-tag me-1"></i>Category</div>
                <div class="filter-bar">
                    <a href="${pageContext.request.contextPath}/room?action=publicList<c:if test="${not empty activeStatus}">&amp;status=${activeStatus}</c:if>"
                       class="filter-btn ${activeCategoryId == 0 ? 'active' : ''}">
                        <i class="bi bi-grid-3x3-gap"></i> All Types
                    </a>
                    <c:forEach var="cat" items="${categories}">
                        <a href="${pageContext.request.contextPath}/room?action=publicList&amp;categoryId=${cat.categoryId}<c:if test="${not empty activeStatus}">&amp;status=${activeStatus}</c:if>"
                           class="filter-btn ${activeCategoryId == cat.categoryId ? 'active' : ''}">
                            ${cat.categoryName}
                        </a>
                    </c:forEach>
                </div>
            </div>
        </c:if>

        <%-- Status filter --%>
        <div class="mb-3">
            <div class="filter-label"><i class="bi bi-circle-half me-1"></i>Status</div>
            <div class="filter-bar">
                <a href="${pageContext.request.contextPath}/room?action=publicList<c:if test="${activeCategoryId > 0}">&amp;categoryId=${activeCategoryId}</c:if>"
                   class="filter-btn ${empty activeStatus ? 'active' : ''}">
                    <i class="bi bi-grid"></i> All
                    <span class="filter-count">
                        ${statusCounts['available'] + statusCounts['occupied'] + statusCounts['maintenance']}
                    </span>
                </a>
                <a href="${pageContext.request.contextPath}/room?action=publicList&amp;status=available<c:if test="${activeCategoryId > 0}">&amp;categoryId=${activeCategoryId}</c:if>"
                   class="filter-btn ${activeStatus == 'available' ? 'active' : ''}">
                    <i class="bi bi-check-circle"></i> Available
                    <span class="filter-count">${statusCounts['available']}</span>
                </a>
                <a href="${pageContext.request.contextPath}/room?action=publicList&amp;status=occupied<c:if test="${activeCategoryId > 0}">&amp;categoryId=${activeCategoryId}</c:if>"
                   class="filter-btn ${activeStatus == 'occupied' ? 'active' : ''}">
                    <i class="bi bi-person-fill-check"></i> Occupied
                    <span class="filter-count">${statusCounts['occupied']}</span>
                </a>
                <a href="${pageContext.request.contextPath}/room?action=publicList&amp;status=maintenance<c:if test="${activeCategoryId > 0}">&amp;categoryId=${activeCategoryId}</c:if>"
                   class="filter-btn ${activeStatus == 'maintenance' ? 'active' : ''}">
                    <i class="bi bi-tools"></i> Maintenance
                    <span class="filter-count">${statusCounts['maintenance']}</span>
                </a>
            </div>
        </div>

        <%-- Room sections grouped by category (inspired by rooms.html section layout) --%>
        <c:choose>
            <c:when test="${empty rooms}">
                <div class="empty-state">
                    <i class="bi bi-door-open d-block"></i>
                    <h5>No rooms found</h5>
                    <p>There are no rooms matching the selected filters.</p>
                    <a href="${pageContext.request.contextPath}/room?action=publicList"
                       class="btn btn-warning fw-bold px-4" style="color:#fff">View All Rooms</a>
                </div>
            </c:when>
            <c:otherwise>
                <%-- Results info --%>
                <div class="results-info">
                    Showing <strong>${rooms.size()}</strong> room<c:if test="${rooms.size() != 1}">s</c:if>
                    <c:if test="${activeCategoryId > 0}">
                        <c:forEach var="cat" items="${categories}">
                            <c:if test="${cat.categoryId == activeCategoryId}"> in <strong>${cat.categoryName}</strong></c:if>
                        </c:forEach>
                    </c:if>
                    <c:if test="${not empty activeStatus}"> &middot; status: <strong>${activeStatus}</strong></c:if>
                </div>

                <section class="room-details">
                    <div class="h-rooms">
                        <%-- Section title (rooms.html style) --%>
                        <div class="row">
                            <span class="room-title-new">
                                <c:choose>
                                    <c:when test="${activeCategoryId > 0}">
                                        <c:forEach var="cat" items="${categories}">
                                            <c:if test="${cat.categoryId == activeCategoryId}">${cat.categoryName}</c:if>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>All Rooms</c:otherwise>
                                </c:choose>
                                <hr>
                            </span>
                        </div>

                        <%-- Cards (rooms.html card layout) --%>
                        <div class="card-set">
                            <div class="row g-4">
                                <c:forEach var="room" items="${rooms}">
                                    <div class="col-sm-6 col-lg-3">
                                        <div class="card">
                                            <div class="card-img-wrap">
                                                <img class="card-img-top"
                                                     src="${pageContext.request.contextPath}/assets/images/room/${not empty room.image ? room.image : 'default.jpg'}"
                                                     alt="Room ${room.roomNumber}"
                                                     onerror="this.onerror=null;this.style.display='none';this.parentElement.querySelector('.room-placeholder').style.display='flex';">
                                                <div class="room-placeholder">
                                                    <i class="bi bi-door-closed"></i>
                                                    <span style="font-size:.8rem">Room ${room.roomNumber}</span>
                                                </div>
                                                <span class="status-badge status-${room.status}">
                                                    <c:choose>
                                                        <c:when test="${room.status == 'available'}">Available</c:when>
                                                        <c:when test="${room.status == 'occupied'}">Occupied</c:when>
                                                        <c:otherwise>Maintenance</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            <div class="card-body">
                                                <h5 class="card-title fw-bold mb-1">Room ${room.roomNumber}</h5>
                                                <c:if test="${not empty room.categoryName}">
                                                    <span class="room-category-tag">
                                                        <i class="bi bi-tag me-1"></i>${room.categoryName}
                                                    </span>
                                                </c:if>
                                                <c:if test="${not empty room.basePrice and room.basePrice > 0}">
                                                    <div class="room-price">
                                                        <fmt:formatNumber value="${room.basePrice}" groupingUsed="true" maxFractionDigits="0"/>&#8363;
                                                        <span class="price-label">/ month</span>
                                                    </div>
                                                </c:if>
                                                <a href="${pageContext.request.contextPath}/room?action=publicDetail&id=${room.roomId}"
                                                   class="btn-book ${room.status == 'maintenance' ? 'disabled' : ''}">
                                                    <i class="bi bi-eye me-1"></i>
                                                    ${room.status == 'maintenance' ? 'Unavailable' : 'Book Now!'}
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </section>
            </c:otherwise>
        </c:choose>

        <%-- Pagination --%>
        <c:if test="${totalPages > 1}">
            <nav class="mt-4">
                <ul class="pagination justify-content-center">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="?action=publicList<c:if test='${not empty activeStatus}'>&amp;status=${activeStatus}</c:if><c:if test='${activeCategoryId > 0}'>&amp;categoryId=${activeCategoryId}</c:if>&amp;page=${currentPage - 1}">Previous</a>
                    </li>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                            <a class="page-link" href="?action=publicList<c:if test='${not empty activeStatus}'>&amp;status=${activeStatus}</c:if><c:if test='${activeCategoryId > 0}'>&amp;categoryId=${activeCategoryId}</c:if>&amp;page=${i}">${i}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="?action=publicList<c:if test='${not empty activeStatus}'>&amp;status=${activeStatus}</c:if><c:if test='${activeCategoryId > 0}'>&amp;categoryId=${activeCategoryId}</c:if>&amp;page=${currentPage + 1}">Next</a>
                    </li>
                </ul>
            </nav>
        </c:if>

    </div>

    <%-- Footer (from rooms.html) --%>
    <section class="footer-section">
        <div class="container">
            <div class="row text-center">
                <div class="col-lg-4 mb-2">
                    <h3>AKDD House</h3>
                </div>
                <div class="col-lg-4 mb-2">
                    <h5>115B, Main Street, Ha Noi, Viet Nam<br>+(84) 91 123 4567</h5>
                </div>
                <div class="col-lg-4">
                    <p class="lead mb-0">
                        <a href="#" class="mx-2"><i class="bi bi-twitter" aria-hidden="true"></i></a>
                        <a href="#" class="mx-2"><i class="bi bi-facebook" aria-hidden="true"></i></a>
                        <a href="#" class="mx-2"><i class="bi bi-instagram" aria-hidden="true"></i></a>
                    </p>
                </div>
            </div>
        </div>
    </section>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        </main>
      </div>
    </div>
</body>
</html>
