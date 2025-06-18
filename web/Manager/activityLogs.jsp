<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Activity Logs</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        input, select, button {
            padding: 6px; margin: 5px; font-size: 14px;
        }
        table {
            width: 100%; border-collapse: collapse; margin-top: 10px;
        }
        th, td {
            padding: 10px; border: 1px solid #ccc; text-align: left;
        }
        th { background-color: #f3f3f3; }
        .toolbar { margin-bottom: 10px; }
        .pagination { margin-top: 15px; text-align: center; }
        .pagination a {
            padding: 5px 10px; margin: 2px;
            border: 1px solid #ccc; text-decoration: none; color: black;
        }
        .pagination a.active {
            font-weight: bold; background-color: #ddd;
        }
    </style>
</head>
<body>

<h2>Activity Log</h2>

<form method="get" action="ActivityLogServlet">
    <div class="toolbar">
        <input type="text" name="username" placeholder="Search user" />
        <select name="actionType">
            <option value="All">All Actions</option>
            <option value="Add">Add</option>
            <option value="Update">Update</option>
            <option value="Delete">Delete</option>
            <option value="Login">Login</option>
            <option value="View">View</option>
        </select>
        <input type="hidden" name="page" value="${currentPage}" />
        <button type="submit">Search</button>
        <a href="ActivityLogServlet"><button type="button">Clear Filters</button></a>
        <button type="button" onclick="location.reload()">Refresh</button>
        <button type="button" onclick="window.location.href='ExportLogsServlet'">Export</button>
    </div>
</form>

<table>
    <thead>
        <tr>
            <th>Date</th>
            <th>User</th>
            <th>Role</th>
            <th>Action</th>
            <th>Object</th>
            <th>Details</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="log" items="${logs}">
            <tr>
                <td>${log.actionTime}</td>
                <td>${log.username}</td>
                <td>${log.role}</td>
                <td>${log.actionType}</td>
                <td>${log.targetTable} #${log.targetId}</td>
                <td><a href="ViewLogDetailServlet?id=${log.logId}">View Details</a></td>
            </tr>
        </c:forEach>
        <c:if test="${empty logs}">
            <tr><td colspan="6" style="text-align:center;">No logs found</td></tr>
        </c:if>
    </tbody>
</table>

<c:if test="${totalPages > 1}">
    <div class="pagination">
        <c:forEach var="i" begin="1" end="${totalPages}">
            <a href="ActivityLogServlet?page=${i}"
               class="${i == currentPage ? 'active' : ''}">${i}</a>
        </c:forEach>
    </div>
</c:if>

</body>
</html>