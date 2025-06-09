<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Activity Logs</title>
        <style>
            .main-content {
                margin-left: 260px;
                padding: 30px;
                width: calc(100% - 260px);
                box-sizing: border-box;
            }

            .card {
                background: #fff;
                padding: 25px;
                border-radius: 10px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
                max-width: 1200px;
                margin: auto;
            }

            .card h1 {
                text-align: center;
                color: #2c3e50;
                margin-bottom: 25px;
            }

            .filter-form {
                margin-bottom: 30px;
                display: flex;
                flex-wrap: wrap;
                gap: 12px;
                align-items: center;
            }

            .filter-form label {
                font-weight: bold;
            }

            .filter-form input,
            .filter-form select {
                padding: 6px;
                border: 1px solid #ccc;
                border-radius: 4px;
            }

            .filter-form button {
                padding: 6px 14px;
                background-color: #2980b9;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
            }

            .filter-form button:hover {
                background-color: #1c5980;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                background: #fff;
            }

            th, td {
                padding: 12px 15px;
                border: 1px solid #ddd;
                text-align: left;
            }

            th {
                background-color: #3498db;
                color: white;
            }

            tr:hover {
                background-color: #f1f1f1;
            }

            .back-btn {
                display: inline-block;
                margin-top: 20px;
                padding: 10px 16px;
                background-color: #2980b9;
                color: white;
                border-radius: 6px;
                text-decoration: none;
            }

            .back-btn:hover {
                background-color: #1c5980;
            }
            .pagination {
                display: flex;
                justify-content: center;
                list-style: none;
                padding: 0;
                margin-top: 20px;
                gap: 6px;
            }

            .pagination li {
                display: inline-block;
            }

            .pagination a {
                padding: 8px 12px;
                text-decoration: none;
                border: 1px solid #ccc;
                background-color: #f4f4f4;
                color: #333;
                border-radius: 4px;
            }

            .pagination .active a {
                background-color: #3498db;
                color: white;
                font-weight: bold;
                border-color: #2980b9;
            }
            .filter-form .form-btn {
                padding: 6px 14px;
                background-color: #2980b9;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                text-decoration: none;
                display: inline-block;
                height: 38px;
                line-height: 24px;
            }

            .filter-form .form-btn:hover {
                background-color: #1c5980;
            }
            .btn-reset:hover {
                background-color: #1c5980;
            }
        </style>
    </head>
    <body>
        <%@ include file="sidebar.jsp" %>

        <div class="main-content">
            <div class="card">
                <h1>Activity Logs</h1>

                <form class="filter-form" action="activityStaff" method="get" novalidate>

                    <label for="username">Username:</label>
                    <input type="text" id="username" name="username"
                           value="${param.username}"
                           required
                           oninvalid="this.setCustomValidity('Username không được bỏ trống')"
                           oninput="this.setCustomValidity('')" />

                    <label for="actionType">Action Type:</label>
                    <select id="actionType" name="actionType"
                            required
                            oninvalid="this.setCustomValidity('Hãy chọn Action Type')"
                            oninput="this.setCustomValidity('')">
                        <option value="">-- Chọn Action --</option>
                        <option value="Add"    ${param.actionType=='Add'    ? 'selected':''}>Add</option>
                        <option value="Delete" ${param.actionType=='Delete' ? 'selected':''}>Delete</option>
                        <option value="Update" ${param.actionType=='Update' ? 'selected':''}>Update</option>
                    </select>

                    <label for="targetTable">Target Table:</label>
                    <input type="text" id="targetTable" name="targetTable"
                           value="${param.targetTable}"
                           required
                           oninvalid="this.setCustomValidity('Target Table không được bỏ trống')"
                           oninput="this.setCustomValidity('')" />

                    <label for="from">From (ngày):</label>
                    <input type="date" id="from" name="from"
                           value="${param.from}"
                           required
                           oninvalid="this.setCustomValidity('Chọn ngày bắt đầu')"
                           oninput="this.setCustomValidity('')" />

                    <label for="to">To (ngày):</label>
                    <input type="date" id="to" name="to"
                           value="${param.to}"
                           required
                           oninvalid="this.setCustomValidity('Chọn ngày kết thúc')"
                           oninput="this.setCustomValidity('')" />

                    <label for="targetID">Target ID:</label>
                    <input type="number" id="targetID" name="targetID"
                           value="${param.targetID}"
                           required
                           oninvalid="this.setCustomValidity('Target ID không được để trống')"
                           oninput="this.setCustomValidity('')" />

                    <label for="pageSize">Số dòng / trang:</label>
                    <select id="pageSize" name="pageSize"
                            required
                            oninvalid="this.setCustomValidity('Chọn số dòng/trang')"
                            oninput="this.setCustomValidity('')">
                        <option value="">-- Chọn --</option>
                        <option value="5"  ${param.pageSize=='5'  ? 'selected':''}>5</option>
                        <option value="10" ${param.pageSize=='10' ? 'selected':''}>10</option>
                        <option value="20" ${param.pageSize=='20' ? 'selected':''}>20</option>
                    </select>

                    <button type="submit">Filter</button>
                    <button type="reset">Reset</button>
                </form>

                <table>
                    <thead>
                        <tr>
                            <th>#</th>

                            <%--   <th>Log ID</th>--%>

                            <th>Actor ID</th>
                            <th>Username</th>
                            <th>Action Type</th>
                            <th>Target Table</th>
                            <th>Target ID</th>
                            <th>Action Time</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="log" items="${logList}" varStatus="st">

                            <tr>
                                <td>${(currentPage - 1) * pageSize + st.index + 1}</td>


                                <%--   <     <td>${log.logID}</td>--%>
                                <td>${log.actorID}</td>
                                <td>${log.username}</td>
                                <td>${log.actionType}</td>
                                <td>${log.targetTable}</td>
                                <td>${log.targetID}</td>
                                <td>${log.actionTime}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <c:if test="${totalPages > 1}">
                    <ul class="pagination">
                        <c:if test="${currentPage > 1}">
                            <li>
                                <a href="activityStaff?page=${currentPage - 1}&pageSize=${pageSize}&username=${param.username}&actionType=${param.actionType}&targetTable=${param.targetTable}&from=${param.from}&to=${param.to}&targetID=${param.targetID}">Prev</a>
                            </li>
                        </c:if>

                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <li class="${i == currentPage ? 'active' : ''}">
                                <a href="activityStaff?page=${i}&pageSize=${pageSize}&username=${param.username}&actionType=${param.actionType}&targetTable=${param.targetTable}&from=${param.from}&to=${param.to}&targetID=${param.targetID}">${i}</a>
                            </li>
                        </c:forEach>

                        <c:if test="${currentPage < totalPages}">
                            <li>
                                <a href="activityStaff?page=${currentPage + 1}&pageSize=${pageSize}&username=${param.username}&actionType=${param.actionType}&targetTable=${param.targetTable}&from=${param.from}&to=${param.to}&targetID=${param.targetID}">Next</a>
                            </li>
                        </c:if>
                    </ul>
                </c:if>


                <a class="back-btn" href="Manager/manager.jsp">← Back to Manager Home</a>
            </div>
        </div>
    </body>
</html>
