<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<t:layout>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2><i class="bi bi-door-open me-2"></i>Room List</h2>
        <a href="${pageContext.request.contextPath}/room?action=create"
           class="btn btn-primary">
            <i class="bi bi-plus-circle me-1"></i> Add Room
        </a>
    </div>

    <div class="card shadow-sm">
        <div class="card-body p-0">
            <table class="table table-hover table-striped mb-0 align-middle">
                <thead class="table-dark">
                    <tr>
                        <th style="width: 60px;">#</th>
                        <th>Room Number</th>
                        <th>Status</th>
                        <th style="width: 200px; text-align: center;">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="room" items="${rooms}" varStatus="s">
                        <tr>
                            <td>${s.index + 1}</td>
                            <td>
                                <i class="bi bi-house me-1 text-secondary"></i>
                                <strong>${room.roomNumber}</strong>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${room.status == 'available'}">
                                        <span class="badge bg-success fs-6">Available</span>
                                    </c:when>
                                    <c:when test="${room.status == 'occupied'}">
                                        <span class="badge bg-danger fs-6">Occupied</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-warning text-dark fs-6">Maintenance</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center">
                                <a href="${pageContext.request.contextPath}/room?action=detail&id=${room.roomId}"
                                   class="btn btn-sm btn-info me-1">
                                    <i class="bi bi-eye"></i> Detail
                                </a>
                                <a href="${pageContext.request.contextPath}/room?action=edit&id=${room.roomId}"
                                   class="btn btn-sm btn-warning me-1">
                                    <i class="bi bi-pencil"></i> Edit
                                </a>
                                <a href="${pageContext.request.contextPath}/room?action=delete&id=${room.roomId}"
                                   class="btn btn-sm btn-danger"
                                   onclick="return confirm('Are you sure you want to delete room ' + '${room.roomNumber}' + '?')">
                                    <i class="bi bi-trash"></i> Delete
                                </a>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty rooms}">
                        <tr>
                            <td colspan="4" class="text-center text-muted py-5">
                                <i class="bi bi-inbox fs-2 d-block mb-2"></i>
                                No rooms found.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <div class="card-footer text-muted d-flex justify-content-between align-items-center flex-wrap gap-2">
            <span>Total: <strong>${totalRooms}</strong> room(s)</span>
            <c:if test="${totalPages > 1}">
                <nav>
                    <ul class="pagination pagination-sm mb-0">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="?action=list&page=${currentPage - 1}">Previous</a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link" href="?action=list&page=${i}">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="?action=list&page=${currentPage + 1}">Next</a>
                        </li>
                    </ul>
                </nav>
            </c:if>
        </div>
    </div>

</t:layout>
