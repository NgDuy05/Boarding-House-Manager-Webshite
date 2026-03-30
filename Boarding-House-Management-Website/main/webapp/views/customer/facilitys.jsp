<%--
    Document   : facility.jsp
    Created on : Mar 8, 2026, 9:27:36 PM
    Author     : huuda
--%>

<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Room Facilities - AKDD House</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
</head>
<body class="bg-light" style="overflow-x:hidden;">
<%@ include file="../navbar.jsp" %>

<div class="container-fluid p-0">
  <div class="row g-0" style="min-height: calc(100vh - 56px);">
    <%@ include file="sidebar.jsp" %>
    <main class="col p-4">

<h2 class="mb-4">Room Facilities</h2>

<div class="row">

<c:forEach var="facility" items="${facilities}">

    <div class="col-md-4 mb-4">

        <div class="card shadow-sm">

            <img class="card-img-top"
                 src="${pageContext.request.contextPath}/assets/images/facility/default.png"
                 alt="Facility">

            <div class="card-body">

                <h5 class="card-title">
                    ${facility.facilityName}
                </h5>

                <p class="card-text">
                    ${facility.description}
                </p>

                <div class="d-flex justify-content-between">

                    <a href="${pageContext.request.contextPath}/facility?action=edit&id=${facility.facilityId}"
                       class="btn btn-warning btn-sm">
                        Edit
                    </a>

                    <a href="${pageContext.request.contextPath}/facility?action=delete&id=${facility.facilityId}"
                       class="btn btn-danger btn-sm"
                       onclick="return confirm('Are you sure?')">
                        Delete
                    </a>

                </div>

            </div>

        </div>

    </div>

</c:forEach>

</div>

<div class="mt-3">
    <a href="${pageContext.request.contextPath}/facility?action=create"
       class="btn btn-primary">
        Add New Facility
    </a>
</div>

    </main>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
