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
        th { background-color: #f3f3f3; cursor: pointer; }
        th:hover { background-color: #e0e0e0; }
        .toolbar { margin-bottom: 10px; }
        .pagination { margin-top: 15px; text-align: center; }
        .pagination a {
            padding: 5px 10px; margin: 2px;
            border: 1px solid #ccc; text-decoration: none; color: black;
        }
        .pagination a.active {
            font-weight: bold; background-color: #ddd;
        }
        .error { color: red; margin: 10px 0; }
    </style>
</head>
<body>

<h2>Activity Log</h2>

<c:if test="${not empty errorMessage}">
    <div class="error">${errorMessage}</div>
</c:if>

<form method="get" action="ActivityLogServlet">
    <div class="toolbar">
        <input type="text" name="username" placeholder="Search user" value="${param.username}" />
        <select name="actionType">
            <option value="All" ${param.actionType == 'All' ? 'selected' : ''}>All Actions</option>
            <option value="Add" ${param.actionType == 'Add' ? 'selected' : ''}>Add</option>
            <option value="Update" ${param.actionType == 'Update' ? 'selected' : ''}>Update</option>
            <option value="Delete" ${param.actionType == 'Delete' ? 'selected' : ''}>Delete</option>
            <option value="Login" ${param.actionType == 'Login' ? 'selected' : ''}>Login</option>
            <option value="View" ${param.actionType == 'View' ? 'selected' : ''}>View</option>
        </select>
        <input type="date" name="startDate" value="${param.startDate}" />
        <input type="date" name="endDate" value="${param.endDate}" />
        <input type="hidden" name="page" value="${currentPage}" />
        <input type="hidden" name="sortBy" value="${param.sortBy}" />
        <input type="hidden" name="sortOrder" value="${param.sortOrder}" />
        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
        <button type="submit">Search</button>
        <a href="ActivityLogServlet"><button type="button">Clear Filters</button></a>
        <button type="button" onclick="location.reload()">Refresh</button>
        <button type="button" onclick="window.location.href='ExportLogsServlet'">Export to CSV</button>
    </div>
</form>

<table>
    <thead>
        <tr>
            <th><a href="?sortBy=actionTime&sortOrder=${param.sortOrder == 'ASC' ? 'DESC' : 'ASC'}&username=${param.username}&actionType=${param.actionType}&startDate=${param.startDate}&endDate=${param.endDate}">Date</a></th>
            <th><a href="?sortBy=username&sortOrder=${param.sortOrder == 'ASC' ? 'DESC' : 'ASC'}&username=${param.username}&actionType=${param.actionType}&startDate=${param.startDate}&endDate=${param.endDate}">User</a></th>
            <th><a href="?sortBy=role&sortOrder=${param.sortOrder == 'ASC' ? 'DESC' : 'ASC'}&username=${param.username}&actionType=${param.actionType}&startDate=${param.startDate}&endDate=${param.endDate}">Role</a></th>
            <th><a href="?sortBy=actionType&sortOrder=${param.sortOrder == 'ASC' ? 'DESC' : 'ASC'}&username=${param.username}&actionType=${param.actionType}&startDate=${param.startDate}&endDate=${param.endDate}">Action</a></th>
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
                <td><a href="ViewLogDetailServlet?id=${log.logId}&csrfToken=${sessionScope.csrfToken}">View Details</a></td>
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
            <a href="ActivityLogServlet?page=${i}&username=${param.username}&actionType=${param.actionType}&startDate=${param.startDate}&endDate=${param.endDate}&sortBy=${param.sortBy}&sortOrder=${param.sortOrder}"
               class="${i == currentPage ? 'active' : ''}">${i}</a>
        </c:forEach>
    </div>
</c:if>

</body>
</html>