<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Account" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    Account account = (Account) session.getAttribute("account");
    if (account == null || !"Manager".equals(account.getRole())) {
        response.sendRedirect("../login_2.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Manage Accounts</title>
        <link href="https://fonts.googleapis.com/css2?family=Roboto&display=swap" rel="stylesheet">
        <style>

        </style>
    </head>
    <body>


        <%@ include file="/header.jsp" %>

        <div class="container">
            <div class="table-title">
                <h2>Manage <b>Accounts</b></h2>
                <a onclick="openModal()">+ Add New Account</a>
            </div>

            <form method="get" action="managerAccount">
                <div style="display: flex; justify-content: space-between; margin-bottom: 20px;">
                    <div>
                        <input type="text" name="search" placeholder="Search by username..." value="${param.search}" 
                               style="padding: 8px; border-radius: 5px; border: 1px solid #ccc;">
                        <button type="submit" style="padding: 8px 12px; border-radius: 5px; background-color: #3498db; color: white; border: none;">Search</button>
                        <a href="managerAccount" 
                           style="padding: 8px 12px; border-radius: 5px; background-color: #e74c3c; color: white; text-decoration: none; margin-left: 10px;">
                            Reset
                        </a>
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
                <c:if test="${currentPage > 1}">
                    <li><a href="managerAccount?page=${currentPage - 1}&search=${param.search}&sort=${param.sort}">Prev</a></li>
                    </c:if>

                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="${i == currentPage ? 'active' : ''}">
                        <a href="managerAccount?page=${i}&search=${param.search}&sort=${param.sort}">${i}</a>
                    </li>
                </c:forEach>

                <c:if test="${currentPage < totalPages}">
                    <li><a href="managerAccount?page=${currentPage + 1}&search=${param.search}&sort=${param.sort}">Next</a></li>
                    </c:if>
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
                <form action="addAccount">
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

        <%@ include file="/footer.jsp" %>


    </body>
</html>
