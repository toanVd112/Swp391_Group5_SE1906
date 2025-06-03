<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Manage Accounts</title>
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
                <h2>Manage <b>Accounts</b></h2>
                <a  onclick="openModal()">+ Add New Account</a>
            </div>
            <form method="get" action="managerAccount">
                <div style="display: flex; justify-content: space-between; margin-bottom: 20px;">
                    <div>
                        <input type="text" name="search" placeholder="Search by username..." value="${param.search}" 
                               style="padding: 8px; border-radius: 5px; border: 1px solid #ccc;">
                        <button type="submit" style="padding: 8px 12px; border-radius: 5px; background-color: #3498db; color: white; border: none;">Search</button>
                    </div>
                    <div>
                        <select name="sort" onchange="this.form.submit()" 
                                style="padding: 8px; border-radius: 5px; border: 1px solid #ccc;">
                            <option value="">Sort by Created Date</option>
                            <option value="asc" ${param.sort == 'asc' ? 'selected' : ''}>Oldest First</option>
                            <option value="desc" ${param.sort == 'desc' ? 'selected' : ''}>Newest First</option>
                        </select>
                    </div>
                </div>
            </form>


            <table>
                <thead>
                    <tr>
                        <th><input type="checkbox" id="selectAll"></th>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Password</th>
                        <th>Role</th>
                        <th>isActive</th>
                        <th>createdAt</th>
                        <th>Email</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${listA}" var="a">
                        <tr>
                            <td><input type="checkbox" value="${a.accountID}" /></td>
                            <td>${a.accountID}</td>
                            <td>${a.username}</td>
                            <td>${a.password}</td>
                            <td>${a.role}</td>
                            <td>${a.isActive}</td>
                            <td>${a.createdAt}</td>
                            <td>${a.email}</td>
                            <td>
                                <a href="loadAccount?aid=${a.accountID}" class="edit" title="Edit">&#x270E;</a>
                                <a href="deleteAccount?aid=${a.accountID}" class="delete" title="Delete">&#x1F5D1;</a>
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

        <!-- Modal -->
        <c:if test="${showAddModal}">
            <script>
                window.onload = function () {
                    document.getElementById("addAccountModal").style.display = "block";
                }
            </script>
        </c:if>

        <div id="addAccountModal" class="modal">
            <div class="modal-dialog">
                <form action="addAccount" >
                    <div class="modal-header">
                        <h4 class="modal-title">Add New Account</h4>
                    </div>
                    <div class="modal-body">
                        <div class="form-group">
                            <label for="username">Username</label>
                            <input id="username" name="username" type="text" placeholder="Enter username" required>
                        </div>

                        <div class="form-group">
                            <label for="password">Password</label>
                            <input id="password" name="password" type="password" placeholder="Enter password" required>
                        </div>

                        <div class="form-group">
                            <label for="role">Role</label>
                            <select id="role" name="role" required>
                                <option value="Receptionist">Receptionist</option>
                                <option value="Staff">Staff</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="isActive">Is Active?</label>
                            <select id="isActive" name="isActive" required>
                                <option value="true">Yes</option>
                                <option value="false">No</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="email">Email</label>
                            <input id="email" name="email" type="email" placeholder="example@mail.com" required>
                        </div>
                    </div>

                    <div class="modal-footer">
                        <input type="button" class="btn-default" value="Cancel" onclick="closeModal()">
                        <input type="submit" class="btn-success" value="Add Account">
                    </div>
                </form>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

            </div>
        </div>

        <script>
            function openModal() {
                document.getElementById("addAccountModal").style.display = "block";
            }
            function closeModal() {
                document.getElementById("addAccountModal").style.display = "none";
            }

            // Close modal when clicking outside
            window.onclick = function (event) {
                var modal = document.getElementById("addAccountModal");
                if (event.target === modal) {
                    modal.style.display = "none";
                }
            };
        </script>
    </body>
</html>
