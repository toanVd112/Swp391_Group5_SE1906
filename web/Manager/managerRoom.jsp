<%-- 
    Document   : managerRoom
    Created on : 1 thg 6, 2025, 19:08:55
    Author     : hieppm76
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Manage Rooms</title>
        <link href="https://fonts.googleapis.com/css2?family=Roboto&display=swap" rel="stylesheet">
        <style>
            * {
                box-sizing: border-box;
                font-family: 'Roboto', sans-serif;
            }

            body {
                background-color: #f4f7f9;
                margin: 0;
                padding: 20px;
            }

            .container {
                max-width: 1100px;
                margin: auto;
                background-color: #fff;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 0 12px rgba(0,0,0,0.1);
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

            .material-icons {
                font-size: 18px;
                vertical-align: middle;
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
        <div class="container">
            <div class="table-title">
                <h2>Manage <b>Rooms</b></h2>
                <a onclick="openModal()">+ Add New Room</a>
            </div>

            <table>
                <thead>
                    <tr>
                        <th><input type="checkbox" id="selectAll"></th>
                        <th>ID</th>
                        <th>Room Number</th>
                        <th>Floor</th>
                        <th>Room Type</th>
                        <th>Status</th>
                        <th>Price</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${listR}" var="r">
                        <tr>
                            <td><input type="checkbox" value="${r.roomID}" /></td>
                            <td>${r.roomID}</td>
                            <td>${r.roomnumber}</td>
                            <td>${r.floor}</td>
                            <td>${r.roomType}</td>
                            <td>${r.status}</td>
                            <td>${r.basePrice}</td>
                            <td>
                                <a href="loadRoom?rid=${r.roomID}" class="edit" title="Edit">&#x270E;</a>
                                <a href="deleteRoom?rid=${r.roomID}" class="delete" title="Delete">&#x1F5D1;</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <ul class="pagination">
                <li><a href="#">Prev</a></li>
                <li><a href="#">1</a></li>
                <li><a href="#">2</a></li>
                <li class="active"><a href="#">3</a></li>
                <li><a href="#">Next</a></li>
            </ul>

            <a href="Manager/manager.jsp"><button type="button" class="btn-primary">Back to home</button></a>
        </div>

        <!-- Modal Add Room -->
        <c:if test="${showAddModal}">
            <script>
                window.onload = function () {
                    document.getElementById("addRoomModal").style.display = "block";
                }
            </script>
        </c:if>

        <div id="addRoomModal" class="modal">
            <div class="modal-dialog">
                <form action="addRoom">
                    <div class="modal-header">
                        <h4 class="modal-title">Add New Room</h4>
                    </div>
                    <div class="modal-body">
                        <div class="form-group">
                            <label for="roomNumber">Room Number</label>
                            <input id="roomNumber" name="roomNumber" type="text" required>
                        </div>
                        <div class="form-group">
                            <label for="roomType">Room Type</label>
                            <select id="roomType" name="roomType" required>
                                <option value="Single">Single</option>
                                <option value="Double">Double</option>
                                <option value="Suite">Suite</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="status">Status</label>
                            <select id="status" name="status" required>
                                <option value="Available">Available</option>
                                <option value="Occupied">Occupied</option>
                                <option value="Maintenance">Maintenance</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="price">Price</label>
                            <input id="price" name="price" type="number" step="0.01" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <input type="button" class="btn-default" value="Cancel" onclick="closeModal()">
                        <input type="submit" class="btn-success" value="Add Room">
                    </div>
                </form>
            </div>
        </div>

        <script>
            function openModal() {
                document.getElementById("addRoomModal").style.display = "block";
            }
            function closeModal() {
                document.getElementById("addRoomModal").style.display = "none";
            }
            window.onclick = function (event) {
                var modal = document.getElementById("addRoomModal");
                if (event.target === modal) {
                    modal.style.display = "none";
                }
            };
        </script>
    </body>
</html>

