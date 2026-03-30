<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Rooms</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #D7F9FA;
        }

        /* ===== HEADER ===== */
        .header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 15px 50px;
    background: #fff;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    position: sticky;
    top: 0;
    z-index: 1000;
}

.logo {
    font-size: 22px;
    font-weight: bold;
    color: #ff5a5f;
}

.menu a {
    margin-left: 25px;
    text-decoration: none;
    color: #333;
    font-weight: 500;
}

        /* ===== CONTAINER ===== */
        .container {
            width: 90%;
            margin: 30px auto;
        }

        h2 {
            margin-bottom: 20px;
            color: #3182F6;
        }

        .room-list {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
        }

        .room-card {
            background: #fff;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            transition: 0.3s;
        }

        .room-card:hover {
            transform: translateY(-5px);
        }

        .room-card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }

        .room-info {
            padding: 15px;
        }

        .room-info h3 {
            margin: 0 0 8px;
        }

        .room-info p {
            color: #777;
            margin: 0 0 10px;
        }

        .price {
            color: #ff5a5f;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .btn {
            display: inline-block;
            padding: 8px 18px;
            border-radius: 20px;
            text-decoration: none;
            color: white;
            font-size: 14px;
        }

        .btn-book {
            background: #4FC3F7;
        }

        .btn-book:hover {
            background: #3182F6;
        }

        .btn-detail {
            background: #4FC3F7;
            margin-left: 8px;
        }

        .btn-detail:hover {
            background: #3182F6;
        }
    </style>
</head>
<body>

<!-- ===== HEADER ===== -->
<div class="header">
    <div class="logo">AKDD ROOM</div>
   <div class="menu">
    <a href="#">Home</a>
    <a href="#">About</a>
    <a href="${pageContext.request.contextPath}/room?action=guest">Rooms</a>
    <a href="#">Services</a>
    <a href="#">Contact</a>
    <a href="${pageContext.request.contextPath}/views/login.jsp">Login</a>
</div>
</div>

<!-- ===== CONTENT ===== -->
<div class="container">
    <h2>View Rooms</h2>

    <div class="room-list">
        <c:forEach var="r" items="${rooms}">
            <div class="room-card">
                <c:choose>
    <c:when test="${not empty r.image}">
        <img src="${pageContext.request.contextPath}/images/${r.image}" alt="Room Image">
    </c:when>
    <c:otherwise>
        <img src="https://images.unsplash.com/photo-1560448204-e02f11c3d0e2" alt="Room Image">
    </c:otherwise>
</c:choose>

                <div class="room-info">
                    <h3>${r.roomNumber}</h3>
                    <p>Status: ${r.status}</p>
                    <p class="price">40$ / Per Night</p>

                    <a href="#" class="btn btn-book">Book Now</a>
                    <a href="room?action=guestdetail&id=${r.roomId}" 
                       class="btn btn-detail">View Details</a>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

</body>
</html>