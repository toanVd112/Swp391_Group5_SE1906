<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Manage Rooms</title>
        <link href="https://fonts.googleapis.com/css2?family=Roboto&display=swap" rel="stylesheet">
        <style>
            body, .main-content, .container, table, input, select, button {
                box-sizing: border-box;
                font-family: 'Roboto', sans-serif;
            }

            /* KHÔNG ảnh hưởng layout tổng thể hay sidebar */
            .main-content {
                margin-left: 260px;
                padding: 30px;
                width: calc(100% - 260px);
                box-sizing: border-box;
            }

            .container {
                max-width: 1100px;
                background-color: #fff;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 0 12px rgba(0,0,0,0.1);
                margin: auto;
            }

            .table-title {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }

            .table-title h2 {
                color: #2c3e50;
            }

            .table-title a {
                background-color: #2ecc71;
                color: #fff;
                padding: 10px 18px;
                border-radius: 5px;
                text-decoration: none;
                font-weight: bold;
            }

            table {
                width: 100%;
                border-collapse: collapse;
            }

            table thead {
                background-color: #3498db;
                color: white;
            }

            table th, table td {
                padding: 12px 10px;
                text-align: left;
                border-bottom: 1px solid #ddd;
            }

            table tr:hover {
                background-color: #f1f1f1;
            }

            .custom-checkbox input[type="checkbox"] {
                width: 16px;
                height: 16px;
            }

            a.edit, a.delete {
                margin: 0 5px;
                color: #2980b9;
                text-decoration: none;
            }

            a.delete {
                color: #e74c3c;
            }

            .pagination {
                display: flex;
                justify-content: center;
                list-style-type: none;
                padding: 0;
                margin-top: 20px;
            }

            .pagination li {
                margin: 0 5px;
            }

            .pagination a {
                display: block;
                padding: 8px 12px;
                text-decoration: none;
                background-color: #ecf0f1;
                border-radius: 4px;
                color: #2c3e50;
            }

            .pagination .active a {
                background-color: #3498db;
                color: white;
            }

            .btn-primary {
                margin-top: 20px;
                background-color: #2980b9;
                color: white;
                padding: 10px 16px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
            }

            /* Modal Styles */
            .modal {
                display: none;
                position: fixed;
                z-index: 100;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                overflow: auto;
                background-color: rgba(0,0,0,0.4);
            }

            .modal-dialog {
                background-color: #fff;
                margin: 80px auto;
                padding: 20px;
                width: 500px;
                border-radius: 10px;
            }

            .modal-header h4 {
                margin: 0;
                color: #2c3e50;
            }

            .form-group {
                margin-top: 15px;
            }

            .form-group label {
                display: block;
                margin-bottom: 6px;
                font-weight: 500;
            }

            .form-group input,
            .form-group select {
                width: 100%;
                padding: 10px;
                border-radius: 5px;
                border: 1px solid #ccc;
            }

            .modal-footer {
                margin-top: 20px;
                display: flex;
                justify-content: flex-end;
            }

            .modal-footer input {
                margin-left: 10px;
                padding: 10px 14px;
                border: none;
                border-radius: 5px;
                font-weight: bold;
            }

            .btn-default {
                background-color: #bdc3c7;
                color: white;
            }

            .btn-success {
                background-color: #2ecc71;
                color: white;
            }
        </style>
    </head>
    <body>
        <%@ include file="sidebar.jsp" %>

        <div class="main-content">
            <div class="container">
                <div class="table-title">
                    <h2>Manage <b>Rooms</b></h2>
                    <a href="#">+ Add New Room</a>
                </div>
                <form method="get" action="managerR">
                    <div style="display: flex; justify-content: space-between; margin-bottom: 20px;">
                        <div>
                            <input type="text" name="search" placeholder="Search by Room Number..." value="${param.search}" 
                                   style="padding: 8px; border-radius: 5px; border: 1px solid #ccc;">
                            <button type="submit" 
                                    style="padding: 8px 12px; border-radius: 5px; background-color: #3498db; color: white; border: none;">
                                Search
                            </button>
                            <a href="managerR" 
                               style="padding: 8px 12px; border-radius: 5px; background-color: #e74c3c; color: white; text-decoration: none; margin-left: 10px;">
                                Reset
                            </a>
                        </div>
                        <div>
                            <select name="sort" onchange="this.form.submit()" 
                                    style="padding: 8px; border-radius: 5px; border: 1px solid #ccc;">
                                <option value="">Sort by Price</option>
                                <option value="asc" ${param.sort == 'asc' ? 'selected' : ''}>Low to High</option>
                                <option value="desc" ${param.sort == 'desc' ? 'selected' : ''}>High to Low</option>
                            </select>
                        </div>
                    </div>
                </form>

                <table>
                    <thead>
                        <tr>
                            <th><input type="checkbox" id="selectAll"></th>
                            <th>ID</th>
                            <th>RoomType ID</th>
                            <th>Room Number</th>
                            <th>Floor</th>
                            <th>Status</th>
                            <th>Room Image</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${listR}" var="r">
                            <tr>
                                <td><input type="checkbox" value="${r.roomID}" /></td>
                                <td>${r.roomID}</td>
                                <td>${r.roomTypeID}</td>
                                <td>${r.roomnumber}</td>
                                <td>${r.floor}</td>
                                <td>${r.status}</td>
                                <td>${r.roomImage}</td>
                                <td>
                                    <a href="loadRoom?rid=${r.roomID}" class="edit" title="Edit">&#x270E;</a>
                                    <a href="deleteRoom?rid=${r.roomID}" class="delete" title="Delete">&#x1F5D1;</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <ul class="pagination">
                    <c:if test="${currentPage > 1}">
                        <li><a href="managerR?page=${currentPage - 1}&search=${param.search}&sort=${param.sort}">Prev</a></li>
                        </c:if>

                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="${i == currentPage ? 'active' : ''}">
                            <a href="managerR?page=${i}&search=${param.search}&sort=${param.sort}">${i}</a>
                        </li>
                    </c:forEach>

                    <c:if test="${currentPage < totalPages}">
                        <li><a href="managerR?page=${currentPage + 1}&search=${param.search}&sort=${param.sort}">Next</a></li>
                        </c:if>
                </ul>

                <a href="Manager/manager.jsp"><button type="button" class="btn-primary">Back to home</button></a>
            </div>
        </div>
    </body>
</html>