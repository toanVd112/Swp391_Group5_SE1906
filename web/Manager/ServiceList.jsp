<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ page import="model.Account" %>
<%@ page import="model.Service" %>
<%@ page import="DAO.ServiceDAO" %>
<%@ page import="java.util.List" %>
<%
    Account account = (Account) session.getAttribute("account");
    if (account == null || !"Manager".equals(account.getRole())) {
        response.sendRedirect("../login_2.jsp");
        return;
    }
    List<Service> services = new ServiceDAO().getAll();
    request.setAttribute("serviceList", services);
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Service List</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            html, body {
                height: 100%;
                margin: 0;
                overflow-x: hidden;
            }
            body {
                background-color: #fff;
                color: #333;
                padding-top: 56px; /* Khoảng cách cho navbar cố định */
                display: flex;
                flex-direction: column;
            }
            .table {
                color: #333;
                background-color: #fff;
            }
            .table th {
                background-color: #f8f9fa;
                color: #333;
            }
            .table td {
                vertical-align: middle;
            }
            .pagination {
                justify-content: center;
                position: fixed;
                bottom: 0;
                left: 0;
                right: 0;
                background-color: #fff;
                padding: 10px 0;
                border-top: 1px solid #dee2e6;
                z-index: 1000;
            }
            .pagination .active .page-link {
                background-color: #007bff;
                border-color: #007bff;
            }
            .page-link {
                color: #333;
                background-color: #fff;
                border-color: #dee2e6;
            }
            .page-link:hover {
                background-color: #e9ecef;
            }
            .sidebar {
                width: 250px;
                background-color: #f8f9fa;
                height: calc(100vh - 56px); /* Chiều cao toàn màn hình trừ navbar */
                position: fixed;
                top: 56px;
                left: 0;
                overflow-y: auto;
            }
            .sidebar .nav-link {
                color: #333;
            }
            .sidebar .nav-link.active {
                color: #fff;
                background-color: #007bff;
            }
            .filter-section {
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .filter-section select,
            .filter-section input {
                background-color: #fff;
                color: #333;
                border: 1px solid #dee2e6;
            }
            .filter-section select:focus,
            .filter-section input:focus {
                background-color: #fff;
                color: #333;
                border-color: #007bff;
                box-shadow: none;
            }
            .navbar {
                background-color: #f8f9fa !important;
            }
            .navbar .navbar-brand,
            .navbar .nav-link {
                color: #333 !important;
            }
            .main-content {
                margin-left: 250px; /* Khoảng cách bên trái để sidebar không đè nội dung */
                padding-bottom: 60px; /* Khoảng cách dưới để không bị pagination che */
                flex: 1;
            }
        </style>
    </head>
    <body>
        <!-- Navbar -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
            <div class="container-fluid">
                <a class="navbar-brand" href="/HotelManagement/services">Hotel Management</a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                Welcome, Admin
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                                <li><a class="dropdown-item" href="#">Profile</a></li>
                                <li><a class="dropdown-item" href="#">Settings</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="../Logout">Logout</a></li>
                            </ul>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- Nội dung chính với Sidebar và Main Content -->
        <div class="d-flex">
            <!-- Sidebar -->
            <div class="sidebar flex-shrink-0 p-3">
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link" href="#">Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Rooms</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Bookings</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="#">Services</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Customers</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Reports</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Settings</a>
                    </li>
                </ul>
            </div>

            <!-- Main Content -->
            <div class="main-content p-3">
                <div class="container">
                    <div class="d-flex justify-content-between mb-3 align-items-center">
                        <!-- Search and Filters -->
                        <div class="filter-section">
                            <input type="text" class="form-control" placeholder="Search..." style="width: 200px;">
                            <select class="form-select" style="width: 150px;">
                                <option value="">Filter by Type</option>
                                <option value="everyone">Mọi người</option>
                                <option value="vip">VIP</option>
                            </select>
                            <select class="form-select" style="width: 150px;">
                                <option value="">Filter by Status</option>
                                <option value="available">Available</option>
                                <option value="inactive">Inactive</option>
                            </select>
                        </div>
                        <!-- Create Data Button -->
                        <button class="btn btn-success btn-sm" onclick="window.location.href='addService.jsp'">Create Data</button>
                    </div>
                    <table class="table table-striped table-bordered">
                        <thead>
                            <tr>
                                <!--                                <th>#</th>-->
                                <th>ID</th>
                                <th>Name</th>
                                <th>Price</th>
                                <th>Type</th>
                                <th>Status</th>
                                <th>Created By</th>
                                <th>Create Date</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${serviceList}" var="s">
                                <tr>
                                    <!--<td></td>-->
                                    <td>${s.serviceID}</td>
                                    <td>${s.serviceName}</td>
                                    <td>${s.price}</td>
                                    <td>${empty s.serviceType ? "Null" : s.serviceType}</td>
                                    <td>${s.availabilityStatus == 1 ? "Available" : "Not Available"}</td>
                                    <td>${empty s.createdBy ? "Null" : s.createdBy}</td>
                                    <td>${s.createdDate}</td>
                                    <td>
                                        <button class="btn btn-primary btn-sm me-1" onclick="window.location
                                                .href = '/HotelManagement/Manager/editService.jsp?id=${s.serviceID}'">Edit</button>
                                        <button class="btn btn-danger btn-sm" onclick="window.location
                                                .href = '/HotelManagement/Manager/toggleService.jsp?id=${s.serviceID}'">Inactive</button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Pagination cố định dưới cùng -->
        <nav aria-label="Page navigation">
            <ul class="pagination">
                <li class="page-item"><a class="page-link" href="#">««</a></li>
                <li class="page-item"><a class="page-link" href="#">«</a></li>
                <li class="page-item"><a class="page-link" href="#">1</a></li>
                <li class="page-item"><a class="page-link" href="#">2</a></li>
                <li class="page-item"><a class="page-link" href="#">3</a></li>
                <li class="page-item active"><a class="page-link" href="#">4</a></li>
                <li class="page-item"><a class="page-link" href="#">5</a></li>
                <li class="page-item"><a class="page-link" href="#">6</a></li>
                <li class="page-item"><a class="page-link" href="#">7</a></li>
                <li class="page-item"><a class="page-link" href="#">8</a></li>
                <li class="page-item"><a class="page-link" href="#">9</a></li>
                <li class="page-item"><a class="page-link" href="#">10</a></li>
                <li class="page-item"><a class="page-link" href="#">11</a></li>
                <li class="page-item"><a class="page-link" href="#">12</a></li>
                <li class="page-item"><a class="page-link" href="#">13</a></li>
                <li class="page-item"><a class="page-link" href="#">14</a></li>
                <li class="page-item"><a class="page-link" href="#">15</a></li>
                <li class="page-item"><a class="page-link" href="#">16</a></li>
                <li class="page-item"><a class="page-link" href="#">17</a></li>
                <li class="page-item"><a class="page-link" href="#">»</a></li>
                <li class="page-item"><a class="page-link" href="#">»»</a></li>
            </ul>
        </nav>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>