<%-- 
    Document   : editAccount
    Created on : 28 thg 5, 2025, 17:45:50
    Author     : MyPC
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Account</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f4f7f9;
            margin: 0;
            padding: 20px;
        }

        .container {
            max-width: 600px;
            margin: auto;
            background-color: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 12px rgba(0,0,0,0.1);
        }

        h2 {
            color: #2c3e50;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
        }

        input, select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            margin-top: 20px;
        }

        .btn {
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            font-weight: bold;
            cursor: pointer;
        }

        .btn-cancel {
            background-color: #bdc3c7;
            color: white;
            margin-right: 10px;
        }

        .btn-update {
            background-color: #2980b9;
            color: white;
        }

        .alert {
            color: red;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Edit Account</h2>
        <form action="editAccount" method="post">
            <input type="hidden" name="aid" value="${account.accountID}" />

            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" value="${account.username}" required>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" value="${account.password}" required>
            </div>

            <div class="form-group">
                <label for="role">Role</label>
                <select id="role" name="role" required>
                    <option value="Receptionist" ${account.role == 'Receptionist' ? 'selected' : ''}>Receptionist</option>
                    <option value="Staff" ${account.role == 'Staff' ? 'selected' : ''}>Staff</option>
                </select>
            </div>

            <div class="form-group">
                <label for="isActive">Is Active?</label>
                <select id="isActive" name="isActive" required>
                    <option value="true" ${account.isActive == true ? 'selected' : ''}>Yes</option>
                    <option value="false" ${account.isActive == false ? 'selected' : ''}>No</option>
                </select>
            </div>

            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" value="${account.email}" required>
            </div>

            <div class="form-actions">
                <a href="manageAccount"><button type="button" class="btn btn-cancel">Cancel</button></a>
                <input type="submit" class="btn btn-update" value="Update">
            </div>
        </form>

        <c:if test="${not empty error}">
            <div class="alert">${error}</div>
        </c:if>
    </div>
</body>
</html>

