<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Booking List</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            .badge-status {
                padding: 0.35em 0.6em;
                font-size: 0.875em;
                border-radius: 0.35rem;
                display: inline-block;
                font-weight: 500;
            }

            .status-pending {
                background-color: #fff3cd;
                color: #856404;
            }

            .status-upcoming {
                background-color: #cff4fc;
                color: #055160;
            }

            .status-active {
                background-color: #d1e7dd;
                color: #0f5132;
            }

            .status-completed {
                background-color: #e2e3e5;
                color: #41464b;
            }

            .status-cancelled {
                background-color: #f8d7da;
                color: #842029;
            }

            .status-expired {
                background-color: #f5c6cb;
                color: #721c24;
            }
        </style>
    </head>
    <body class="bg-light">
        <div class="container py-4">
            <h2 class="mb-4">Booking List</h2>
            <form method="get" action="bookingList" class="mb-4">
                <div class="row g-3">
                    <div class="col-md-6">
                        <input type="text" name="search" value="${param.search}" class="form-control" placeholder="Search by phone number...">
                    </div>
                    <div class="col-md-3">
                        <select name="sort" class="form-select" onchange="this.form.submit()">
                            <option value="">Sort By Created Day</option>
                            <option value="asc" ${param.sort == 'asc' ? 'selected' : ''}>Oldest</option>
                            <option value="desc" ${param.sort == 'desc' ? 'selected' : ''}>Newest</option>
                        </select>
                    </div>
                    <div class="col-md-3 d-flex gap-2">
                        <button type="submit" class="btn btn-primary btn-sm">Search</button>
                        <a href="bookingList" class="btn btn-secondary btn-sm">Reset</a>
                    </div>
                </div>
            </form>

            <table class="table table-bordered table-hover">
                <thead class="table-primary">
                    <tr>
                        <th>ID</th>
                        <th>User ID</th>
                        <th>Check-in</th>
                        <th>Check-out</th>
                        <th>Guests</th>
                        <th>Status</th>
                        <th>Name</th>
                        <th>Phone</th>
                        <th>Pay</th>
                        <th>Update</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${bookingList}" var="b">
                        <tr>
                            <td>${b.bookingID}</td>
                            <td>${b.userID}</td>
                            <td>${b.checkInDate}</td>
                            <td>${b.checkOutDate}</td>
                            <td>${b.guestsCount}</td>
                            <td>
                                <span class="badge-status status-${fn:toLowerCase(b.status)}">${b.status}</span>
                            </td>
                            <td>${b.contactName}</td>
                            <td>${b.contactPhone}</td>
                            <td>${b.totalAmount} đ</td>
                            <td>
                                <form action="${pageContext.request.contextPath}/bookingList" method="post" class="d-flex">
                                    <input type="hidden" name="bookingID" value="${b.bookingID}">
                                    <input type="hidden" name="sort" value="${param.sort}">
                                    <input type="hidden" name="search" value="${param.search}">
                                    <input type="hidden" name="page" value="${currentPage}">

                                    <select name="status" class="form-select form-select-sm me-2">
                                        <c:choose>
                                            <c:when test="${b.status == 'Pending'}">
                                                <option value="Pending" selected>Pending</option>
                                                <option value="Cancelled">Cancelled</option>
                                                <option value="Upcoming">Upcoming</option>
                                            </c:when>
                                            <c:when test="${b.status == 'Upcoming'}">
                                                <option value="Upcoming" selected>Upcoming</option>
                                                <option value="Cancelled">Cancelled</option>
                                                <option value="Active">Active</option>
                                            </c:when>
                                            <c:when test="${b.status == 'Active'}">
                                                <option value="Active" selected>Active</option>
                                                <option value="Completed">Completed</option>
                                            </c:when>
                                            <c:when test="${b.status == 'Completed'}">
                                                <option value="Completed" selected disabled>Completed</option>
                                            </c:when>
                                            <c:when test="${b.status == 'Cancelled'}">
                                                <option value="Cancelled" selected disabled>Cancelled</option>
                                            </c:when>
                                            <c:when test="${b.status == 'Expired'}">
                                                <option value="Expired" selected disabled>Expired</option>
                                            </c:when>
                                        </c:choose>
                                    </select>
                                    <button type="submit" class="btn btn-sm btn-primary">Update</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <c:if test="${totalPages > 1}">
                <nav class="mt-4">
                    <ul class="pagination justify-content-center">
                        <c:if test="${currentPage > 1}">
                            <li class="page-item">
                                <a class="page-link"
                                   href="bookingList?page=${currentPage - 1}&search=${param.search}&sort=${param.sort}">
                                    &laquo;
                                </a>
                            </li>
                        </c:if>

                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link"
                                   href="bookingList?page=${i}&search=${param.search}&sort=${param.sort}">${i}</a>
                            </li>
                        </c:forEach>

                        <c:if test="${currentPage < totalPages}">
                            <li class="page-item">
                                <a class="page-link"
                                   href="bookingList?page=${currentPage + 1}&search=${param.search}&sort=${param.sort}">
                                    &raquo;
                                </a>
                            </li>
                        </c:if>
                    </ul>
                </nav>
            </c:if>
        </div>
    </body>
</html>
