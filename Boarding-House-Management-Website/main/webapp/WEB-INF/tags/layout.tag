<%@ tag description="Main layout" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ tag body-content="scriptless" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>House Management Website</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        html, body { height: 100%; }
        body { display: flex; flex-direction: column; min-height: 100vh; background-color: #f4f6f9; }
        .admin-layout-row { flex: 1; }
        .admin-main { flex: 1; min-width: 0; }
    </style>
</head>
<body>

<jsp:include page="/views/navbar.jsp" />

<div class="container-fluid flex-grow-1">
<div class="row flex-nowrap admin-layout-row">
<jsp:include page="/views/admin/sidebar.jsp" />
<main class="col admin-main px-4 py-4">
    <jsp:doBody />
</main>
</div>
</div>

<jsp:include page="/views/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
