<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Room ${room.roomNumber} - AKDD House</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
    <style>
        /* ── Base (from room-view.html) ── */
        body {
            background-color: rgba(0,0,0,0.06);
            font-family: 'Lato', sans-serif;
        }

        /* ── Room details section (from room-view.html .room-details) ── */
        .room-details {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 16px rgba(0,0,0,.08);
            padding: 24px;
            margin-bottom: 24px;
        }
        .view-img {
            border-radius: 10px;
            object-fit: cover;
            height: 260px;
            width: 100%;
            background: #f3f4f6;
        }
        .view-img-placeholder {
            height: 260px;
            border-radius: 10px;
            background: linear-gradient(135deg,#e0e7ff,#ede9fe);
            display: flex; align-items: center; justify-content: center;
            flex-direction: column; gap: .5rem; color: #818cf8;
        }
        .view-img-placeholder i { font-size: 3rem; }

        /* Title & description (from room-view.html .view-title / .view-des) */
        .view-title {
            font-size: 1.6rem;
            font-weight: 700;
            color: #222;
        }
        .view-des {
            color: #555;
            font-size: .95rem;
            line-height: 1.7;
            margin: 10px 0 16px;
        }

        /* Stats boxes (from room-view.html .no-of-rooms) */
        .stats-row { display: flex; gap: 16px; flex-wrap: wrap; margin-bottom: 16px; }
        .stat-box {
            text-align: center;
            min-width: 90px;
        }
        .stat-box .num {
            font-size: 2rem;
            font-weight: 700;
            color: #FF9005;
            display: block;
            line-height: 1;
        }
        .stat-box .num-text {
            font-size: .75rem;
            color: #888;
            display: block;
            margin-top: 4px;
        }

        /* Status badge */
        .status-pill {
            display: inline-block; border-radius: 20px;
            padding: 4px 14px; font-weight: 700;
            font-size: .78rem; text-transform: uppercase; letter-spacing: .4px;
        }
        .s-available   { background:#d1fae5; color:#059669; }
        .s-occupied    { background:#fee2e2; color:#dc2626; }
        .s-maintenance { background:#fef9c3; color:#d97706; }

        /* Category tag */
        .category-tag {
            display: inline-block;
            background: #fff3e0; color: #e65100;
            border-radius: 8px; padding: 3px 10px;
            font-size: .8rem; font-weight: 700;
        }

        /* Action buttons (from room-view.html .view-btn) */
        .view-btn { display: flex; gap: 10px; flex-wrap: wrap; margin-top: 8px; }
        .btn-book-now {
            background: #FF9005; color: #fff;
            border: none; border-radius: 8px;
            padding: 10px 22px; font-size: .95rem; font-weight: 700;
            text-decoration: none; display: inline-flex; align-items: center; gap: .4rem;
            transition: background .2s;
        }
        .btn-book-now:hover { background: #e08000; color: #fff; }
        .btn-contact {
            color: #FF9005; border: 2px solid #FF9005;
            border-radius: 8px;
            padding: 10px 22px; font-size: .95rem; font-weight: 700;
            text-decoration: none; display: inline-flex; align-items: center; gap: .4rem;
            background: transparent; transition: all .2s;
        }
        .btn-contact:hover { background: #FF9005; color: #fff; }

        /* ── Image gallery (from room-view.html .gallery) ── */
        .gallery { background: #fff; border-radius: 12px; box-shadow: 0 2px 16px rgba(0,0,0,.08); padding: 20px; margin-bottom: 24px; }
        .img-gallery-grid { display: flex; gap: 8px; flex-wrap: wrap; }
        .img-thumb {
            width: calc(16.6% - 7px);
            min-width: 80px;
            aspect-ratio: 1;
            object-fit: cover;
            border-radius: 8px;
            cursor: pointer;
            border: 2px solid transparent;
            transition: border-color .2s, transform .2s;
        }
        .img-thumb:hover, .img-thumb.active {
            border-color: #FF9005;
            transform: scale(1.04);
        }
        @media (max-width: 576px) {
            .img-thumb { width: calc(33.3% - 6px); }
        }

        /* ── Info card / amenities (adapted from roomDetail.jsp) ── */
        .info-card {
            background: #fff;
            border-radius: 12px;
            border: none;
            box-shadow: 0 2px 16px rgba(0,0,0,.08);
            padding: 1.4rem;
            margin-bottom: 20px;
        }
        .section-title {
            font-weight: 700; font-size: .98rem; color: #222;
            display: flex; align-items: center; gap: .5rem;
            margin-bottom: 1.1rem;
            padding-bottom: .65rem;
            border-bottom: 2px solid #f0f0f0;
        }
        .section-title i { color: #FF9005; font-size: 1.1rem; }

        .info-row {
            display: flex; align-items: center;
            padding: 9px 0; border-bottom: 1px solid #f9f9f9;
            font-size: .9rem;
        }
        .info-row:last-child { border-bottom: none; }
        .info-key { width: 120px; flex-shrink: 0; color: #9ca3af; font-weight: 700; font-size: .78rem; text-transform: uppercase; letter-spacing: .3px; }
        .info-val { color: #1f2937; font-weight: 500; }

        /* Amenity cards */
        .amenity-card {
            border-radius: 10px;
            border: 1.5px solid #e5e7eb;
            padding: .9rem;
            display: flex; align-items: flex-start; gap: .75rem;
            transition: border-color .2s;
            background: #fff;
        }
        .amenity-card:hover { border-color: #FF9005; }
        .amenity-icon-wrap {
            width: 40px; height: 40px; flex-shrink: 0;
            background: #fff3e0; border-radius: 8px;
            display: flex; align-items: center; justify-content: center;
        }
        .amenity-icon-wrap img { width: 26px; height: 26px; object-fit: cover; border-radius: 5px; }
        .amenity-name { font-weight: 700; font-size: .88rem; color: #1f2937; }
        .amenity-desc { font-size: .78rem; color: #6b7280; margin-top: 2px; }
        .amenity-qty {
            margin-left: auto; flex-shrink: 0;
            background: #fff3e0; color: #e65100;
            border-radius: 8px; padding: 3px 10px;
            font-size: .76rem; font-weight: 700;
        }
        .empty-amenity { text-align: center; padding: 2rem; color: #9ca3af; }
        .empty-amenity i { font-size: 2.2rem; margin-bottom: .6rem; }

        /* Back link */
        .btn-back {
            display: inline-flex; align-items: center; gap: .4rem;
            color: #FF9005; font-weight: 700; font-size: .88rem;
            text-decoration: none; margin-bottom: 1rem;
        }
        .btn-back:hover { text-decoration: underline; color: #e08000; }

        /* ── Booking modal (from room-view.html #booking) ── */
        .modal-backdrop-custom {
            display: none;
            position: fixed; inset: 0;
            background: rgba(0,0,0,.5);
            z-index: 1040;
            align-items: center; justify-content: center;
        }
        .modal-backdrop-custom.show { display: flex; }
        .booking-form {
            background: #fff;
            border-radius: 14px;
            padding: 28px 32px;
            width: 100%; max-width: 480px;
            position: relative;
            box-shadow: 0 8px 40px rgba(0,0,0,.18);
        }
        .booking-form .close-btn {
            position: absolute; top: 14px; right: 18px;
            font-size: 1.4rem; cursor: pointer; color: #888;
            background: none; border: none; line-height: 1;
        }
        .booking-form .close-btn:hover { color: #333; }
        .booking-heading {
            font-size: 1.2rem; font-weight: 700; color: #222; margin-bottom: 6px;
        }
        .booking-text { font-size: .83rem; color: #777; margin-bottom: 14px; }
        .booking-form input[type="text"],
        .booking-form input[type="email"],
        .booking-form input[type="date"],
        .booking-form input[type="number"] {
            width: 100%; padding: 8px 12px;
            border: 1.5px solid #e5e7eb; border-radius: 8px;
            font-size: .9rem; margin-bottom: 4px;
            transition: border-color .2s;
        }
        .booking-form input:focus { outline: none; border-color: #FF9005; }
        .booking-form p { font-size: .85rem; color: #555; margin: 8px 0 4px; font-weight: 600; }
        .btn-submit-booking {
            width: 100%; background: #FF9005; color: #fff;
            border: none; border-radius: 8px; padding: 11px;
            font-weight: 700; font-size: .95rem; cursor: pointer;
            transition: background .2s; margin-top: 8px;
        }
        .btn-submit-booking:hover { background: #e08000; }

        /* ── Footer (from rooms.html) ── */
        .footer-section {
            background: #222; color: #ccc;
            padding: 28px 0 18px; margin-top: 8px;
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

    <%-- Room not found --%>
    <c:if test="${empty room}">
        <div class="container mt-5 text-center">
            <i class="bi bi-exclamation-circle text-danger" style="font-size:3rem"></i>
            <h4 class="mt-3">Room not found</h4>
            <a href="${pageContext.request.contextPath}/room?action=publicList" class="btn btn-warning fw-bold mt-2" style="color:#fff">
                Back to Room List
            </a>
        </div>
    </c:if>

    <c:if test="${not empty room}">
    <div class="container py-4" style="max-width:1000px;">

        <a href="${pageContext.request.contextPath}/room?action=publicList" class="btn-back">
            <i class="bi bi-arrow-left"></i> Back to Room List
        </a>

        <%-- ── Room details (from room-view.html layout) ── --%>
        <section class="room-details">
            <div class="row g-4">
                <%-- Main image --%>
                <div class="col-lg-4">
                    <c:choose>
                        <c:when test="${not empty room.image}">
                            <img class="view-img"
                                 src="${pageContext.request.contextPath}/assets/images/room/${room.image}"
                                 alt="Room ${room.roomNumber}"
                                 onerror="this.style.display='none';document.getElementById('img-placeholder').style.display='flex';">
                            <div id="img-placeholder" class="view-img-placeholder" style="display:none;">
                                <i class="bi bi-door-closed"></i>
                                <span>Room ${room.roomNumber}</span>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="view-img-placeholder">
                                <i class="bi bi-door-closed"></i>
                                <span>Room ${room.roomNumber}</span>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <%-- Details column (from room-view.html .details) --%>
                <div class="col-lg-8">
                    <div class="d-flex align-items-center gap-2 mb-1 flex-wrap">
                        <span class="view-title">
                            <i class="bi bi-door-closed me-1"></i>Room ${room.roomNumber}
                        </span>
                        <span class="status-pill s-${room.status}">
                            <c:choose>
                                <c:when test="${room.status == 'available'}"><i class="bi bi-check-circle me-1"></i>Available</c:when>
                                <c:when test="${room.status == 'occupied'}"><i class="bi bi-person-fill-check me-1"></i>Occupied</c:when>
                                <c:otherwise><i class="bi bi-tools me-1"></i>Maintenance</c:otherwise>
                            </c:choose>
                        </span>
                        <c:if test="${not empty room.categoryName}">
                            <span class="category-tag"><i class="bi bi-tag me-1"></i>${room.categoryName}</span>
                        </c:if>
                    </div>

                    <c:if test="${not empty room.basePrice and room.basePrice > 0}">
                        <p class="mb-2" style="font-size:1.1rem;font-weight:700;color:#FF9005;">
                            <fmt:formatNumber value="${room.basePrice}" groupingUsed="true" maxFractionDigits="0"/>&#8363;
                            <span style="font-size:.8rem;color:#9ca3af;font-weight:400"> / month</span>
                        </p>
                    </c:if>

                    <p class="view-des">No description available for this room.</p>

                    <%-- Stats (from room-view.html .no-of-rooms) --%>
                    <div class="stats-row">
                        <div class="stat-box">
                            <span class="num">#${room.roomId}</span>
                            <span class="num-text">Room ID</span>
                        </div>
                        <c:if test="${not empty amenities}">
                        <div class="stat-box">
                            <span class="num">${amenities.size()}</span>
                            <span class="num-text">Amenities</span>
                        </div>
                        </c:if>
                        <div class="stat-box">
                            <span class="num" style="font-size:1rem;padding-top:.4rem;">
                                <c:choose>
                                    <c:when test="${room.status == 'available'}">Yes</c:when>
                                    <c:otherwise>No</c:otherwise>
                                </c:choose>
                            </span>
                            <span class="num-text">Available</span>
                        </div>
                    </div>

                    <%-- Action buttons (from room-view.html .view-btn) --%>
                    <div class="view-btn">
                        <c:choose>
                            <%-- Admin/Staff --%>
                            <c:when test="${sessionScope.user.role == 'admin' or sessionScope.user.role == 'staff'}">
                                <a href="${pageContext.request.contextPath}/contract?action=create"
                                   class="btn-book-now">
                                    <i class="bi bi-file-earmark-plus"></i> Create Contract
                                </a>
                            </c:when>
                            <%-- Logged-in customer, room available --%>
                            <c:when test="${not empty sessionScope.user and room.status == 'available'}">
                                <c:choose>
                                    <c:when test="${alreadyHasContract == true}">
                                        <span class="btn-book-now" style="background:#e5e7eb;color:#9ca3af;cursor:default;">
                                            <i class="bi bi-bookmark"></i> Already Contracted
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/contract?action=signContract&roomId=${room.roomId}"
                                           class="btn-book-now">
                                            <i class="bi bi-bookmark"></i> BOOK NOW
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <%-- Not logged in, room available --%>
                            <c:when test="${empty sessionScope.user and room.status == 'available'}">
                                <a href="${pageContext.request.contextPath}/auth?action=login"
                                   class="btn-book-now">
                                    <i class="bi bi-box-arrow-in-right"></i> Log In to Book
                                </a>
                            </c:when>
                            <%-- Not available --%>
                            <c:otherwise>
                                <span class="btn-book-now" style="background:#e5e7eb;color:#9ca3af;cursor:default;">
                                    <i class="bi bi-bookmark"></i> Not Available
                                </span>
                            </c:otherwise>
                        </c:choose>
                        <a href="${pageContext.request.contextPath}/room?action=publicList" class="btn-contact">
                            <i class="bi bi-telephone"></i> CONTACT
                        </a>
                    </div>
                </div>
            </div>
        </section>

        <%-- ── Image gallery (from room-view.html .gallery) ── --%>
        <c:if test="${not empty room.image}">
        <section class="gallery">
            <div class="section-title">
                <i class="bi bi-images"></i> Room Gallery
            </div>
            <div class="img-gallery-grid">
                <%-- Main image shown as thumbnail --%>
                <img class="img-thumb active"
                     src="${pageContext.request.contextPath}/assets/images/room/${room.image}"
                     alt="Room ${room.roomNumber}"
                     onclick="selectThumb(this)"
                     onerror="this.style.display='none'">
                <%-- Additional thumbnails can be added here dynamically in future --%>
            </div>
        </section>
        </c:if>

        <%-- ── Room info + amenities row ── --%>
        <div class="row g-4">

            <%-- Left: Room information (from roomDetail.jsp info-card) --%>
            <div class="col-md-5">
                <div class="info-card">
                    <div class="section-title">
                        <i class="bi bi-info-circle-fill"></i> Room Information
                    </div>
                    <div class="info-row">
                        <div class="info-key">Room No.</div>
                        <div class="info-val fw-bold">${room.roomNumber}</div>
                    </div>
                    <div class="info-row">
                        <div class="info-key">Status</div>
                        <div class="info-val">
                            <span class="status-pill s-${room.status}" style="font-size:.74rem;padding:3px 11px;">
                                <c:choose>
                                    <c:when test="${room.status == 'available'}"><i class="bi bi-check-circle me-1"></i>Available</c:when>
                                    <c:when test="${room.status == 'occupied'}"><i class="bi bi-person-fill-check me-1"></i>Occupied</c:when>
                                    <c:otherwise><i class="bi bi-tools me-1"></i>Maintenance</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                    <c:if test="${not empty room.categoryName}">
                    <div class="info-row">
                        <div class="info-key">Type</div>
                        <div class="info-val">
                            <span class="category-tag"><i class="bi bi-tag me-1"></i>${room.categoryName}</span>
                        </div>
                    </div>
                    </c:if>
                    <c:if test="${not empty room.basePrice and room.basePrice > 0}">
                    <div class="info-row">
                        <div class="info-key">Base Price</div>
                        <div class="info-val fw-bold" style="color:#FF9005;">
                            <fmt:formatNumber value="${room.basePrice}" groupingUsed="true" maxFractionDigits="0"/>&#8363;
                            <span class="text-muted fw-normal" style="font-size:.78rem"> / month</span>
                        </div>
                    </div>
                    </c:if>
                    <div class="info-row">
                        <div class="info-key">Room ID</div>
                        <div class="info-val text-muted">#${room.roomId}</div>
                    </div>
                </div>

                <%-- Quick actions card --%>
                <div class="info-card">
                    <div class="section-title">
                        <i class="bi bi-lightning-fill"></i> Quick Actions
                    </div>
                    <c:choose>
                        <c:when test="${room.status == 'available'}">
                            <p class="text-muted small mb-3">This room is available. Sign a contract to move in right away.</p>
                            <c:choose>
                                <c:when test="${sessionScope.user.role == 'admin' or sessionScope.user.role == 'staff'}">
                                    <a href="${pageContext.request.contextPath}/contract?action=create"
                                       class="btn-book-now d-block text-center">
                                        <i class="bi bi-file-earmark-plus me-1"></i> Create Contract
                                    </a>
                                </c:when>
                                <c:when test="${not empty sessionScope.user}">
                                    <c:choose>
                                        <c:when test="${alreadyHasContract == true}">
                                            <div class="alert alert-warning py-2 small rounded-3 mb-0">
                                                <i class="bi bi-exclamation-triangle me-1"></i>
                                                You already have an active contract.
                                                <a href="${pageContext.request.contextPath}/contract?action=mycontract" class="alert-link">View it here.</a>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/contract?action=signContract&roomId=${room.roomId}"
                                               class="btn-book-now d-block text-center">
                                                <i class="bi bi-pen me-1"></i> Sign Contract for This Room
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/auth?action=login"
                                       class="btn-book-now d-block text-center">
                                        <i class="bi bi-box-arrow-in-right me-1"></i> Log In to Sign Contract
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </c:when>
                        <c:when test="${room.status == 'occupied'}">
                            <p class="text-muted small mb-2">This room is currently occupied.</p>
                            <div class="alert alert-warning py-2 small rounded-3 mb-0">
                                <i class="bi bi-clock me-1"></i> Check back later for availability.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p class="text-muted small mb-2">This room is temporarily unavailable.</p>
                            <div class="alert alert-secondary py-2 small rounded-3 mb-0">
                                <i class="bi bi-tools me-1"></i> Under maintenance.
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <%-- Right: Amenities --%>
            <div class="col-md-7">
                <div class="info-card">
                    <div class="section-title">
                        <i class="bi bi-stars"></i>
                        Room Amenities
                        <span class="badge ms-auto rounded-pill"
                              style="background:#fff3e0;color:#e65100;font-size:.76rem;">
                            ${amenities.size()} items
                        </span>
                    </div>
                    <c:choose>
                        <c:when test="${empty amenities}">
                            <div class="empty-amenity">
                                <i class="bi bi-inbox d-block"></i>
                                <p class="mb-0">No amenities listed for this room yet.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="d-flex flex-column gap-3">
                                <c:forEach var="a" items="${amenities}">
                                    <div class="amenity-card">
                                        <div class="amenity-icon-wrap">
                                            <c:choose>
                                                <c:when test="${not empty a.image}">
                                                    <img src="${pageContext.request.contextPath}/assets/images/facility/${a.image}"
                                                         alt="${a.facilityName}"
                                                         onerror="this.style.display='none';this.parentElement.innerHTML='<i class=\'bi bi-box\' style=\'color:#FF9005;font-size:1.2rem\'></i>'">
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="bi bi-box" style="color:#FF9005;font-size:1.2rem"></i>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="flex-grow-1">
                                            <div class="amenity-name">${a.facilityName}</div>
                                            <c:if test="${not empty a.description}">
                                                <div class="amenity-desc">${a.description}</div>
                                            </c:if>
                                        </div>
                                        <div class="amenity-qty">x${a.quantity}</div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

        </div><%-- end row --%>
    </div><%-- end container --%>

    <%-- ── Booking modal (from room-view.html #booking) ── --%>
    <div id="bookingModal" class="modal-backdrop-custom">
        <div class="booking-form">
            <button class="close-btn" onclick="closeBookingModal()">&times;</button>
            <h2 class="booking-heading"><i class="bi bi-book me-2"></i>Booking Request</h2>
            <p class="booking-text">Once created, you may edit or remove bookings unless they've been approved. You will receive an approval mail with payment options shortly!</p>
            <form action="${pageContext.request.contextPath}/booking" method="post">
                <input type="hidden" name="roomId" value="${room.roomId}">
                <p><i class="bi bi-file-person me-1"></i> Full Name:</p>
                <input type="text" name="custname" value="${sessionScope.user.fullName}" required>
                <p><i class="bi bi-envelope me-1"></i> Email:</p>
                <input type="email" name="custmail" value="${sessionScope.user.email}" required>
                <div class="row g-2">
                    <div class="col">
                        <p><i class="bi bi-calendar me-1"></i> Check-In:</p>
                        <input type="date" name="cindate" required>
                    </div>
                    <div class="col">
                        <p><i class="bi bi-calendar me-1"></i> Check-Out:</p>
                        <input type="date" name="coutdate" required>
                    </div>
                </div>
                <hr style="margin:12px 0;">
                <button type="submit" class="btn-submit-booking">Create Booking</button>
            </form>
        </div>
    </div>

    </c:if><%-- end not empty room --%>

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
                        <a href="#" class="mx-2"><i class="bi bi-twitter"></i></a>
                        <a href="#" class="mx-2"><i class="bi bi-facebook"></i></a>
                        <a href="#" class="mx-2"><i class="bi bi-instagram"></i></a>
                    </p>
                </div>
            </div>
        </div>
    </section>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Thumbnail gallery selector (from room-view.html gallery logic)
        function selectThumb(el) {
            document.querySelectorAll('.img-thumb').forEach(t => t.classList.remove('active'));
            el.classList.add('active');
            // Update main view image if present
            const viewImg = document.querySelector('.view-img');
            if (viewImg) viewImg.src = el.src;
        }

        // Booking modal (from room-view.html booking window)
        function openBookingModal() {
            document.getElementById('bookingModal').classList.add('show');
        }
        function closeBookingModal() {
            document.getElementById('bookingModal').classList.remove('show');
        }
        // Close modal on backdrop click
        document.getElementById('bookingModal')?.addEventListener('click', function(e) {
            if (e.target === this) closeBookingModal();
        });
    </script>
        </main>
      </div>
    </div>
</body>
</html>
