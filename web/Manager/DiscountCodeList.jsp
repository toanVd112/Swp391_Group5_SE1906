<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="model.Account" %>

<%
    Account account = (Account) session.getAttribute("account");
    if (account == null || !"Manager".equals(account.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Discount Code List</title>
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
        }
        .table th {
            background-color: #f8f9fa;
        }
        .pagination {
            justify-content: center;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container mt-4">
        <h2>Discount Code Management</h2>
        <div class="d-flex justify-content-between mb-3 align-items-center">
    <form id="searchForm" method="GET" action="${pageContext.request.contextPath}/discountcodes/list" class="d-flex gap-2">
        <input type="text" class="form-control" id="searchKeyword" name="searchKeyword" placeholder="Search by code..." value="${currentSearchKeyword}" style="width: 200px;" maxlength="50">
        <select class="form-select" id="filterType" name="filterType" style="width: 150px;">
            <option value="">All Types</option>
            <option value="1" ${"1" == currentFilterType ? 'selected' : ''}>Percentage</option>
            <option value="2" ${"2" == currentFilterType ? 'selected' : ''}>Fixed Amount</option>
        </select>
        <select class="form-select" id="filterStatus" name="filterStatus" style="width: 150px;">
            <option value="">All Status</option>
            <option value="Active" ${"Active" == currentFilterStatus ? 'selected' : ''}>Active</option>
            <option value="Inactive" ${"Inactive" == currentFilterStatus ? 'selected' : ''}>Inactive</option>
        </select>
        <button type="submit" class="btn btn-primary btn-sm">Filter</button>
        <a href="${pageContext.request.contextPath}/discountcodes/list" class="btn btn-secondary btn-sm">Clear</a>
    </form>
    <button class="btn btn-success btn-sm ms-2" onclick="window.location.href = '${pageContext.request.contextPath}/Manager/manager.jsp?page=addDiscountCode.jsp'">Add New</button>
</div>

        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Code</th>
                    <th>Discount</th>
                    <th>Expiry Date</th>
                    <th>Type</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:if test="${empty discountCodeList}">
                    <tr>
                        <td colspan="7" class="text-center">No discount codes found.</td>
                    </tr>
                </c:if>
                <c:forEach items="${discountCodeList}" var="dc">
                    <tr>
                        <td>${dc.discountCodeID}</td>
                        <td>${dc.code}</td>
                        <td>
                            <c:choose>
                                <c:when test="${dc.type == '1'}">
                                    <fmt:formatNumber value="${dc.discountPercent}" pattern="##.##"/>%
                                </c:when>
                                <c:otherwise>
                                    <fmt:formatNumber value="${dc.discountPercent}" pattern="###,###,###"/> VND
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${dc.expiryDate}</td>
                        <td>${dc.type == '1' ? 'Percentage' : 'Fixed Amount'}</td>
                        <td>${dc.status}</td>
                        <td>
                            <button class="btn btn-primary btn-sm mb-1" onclick="window.location.href = '${pageContext.request.contextPath}/discountcodes/edit?id=${dc.discountCodeID}'">Edit</button>
                            <c:choose>
                                <c:when test="${dc.status == 'Active'}">
                                    <button class="btn btn-danger btn-sm mb-1" style="width: 80px" onclick="toggleStatus(${dc.discountCodeID})">Inactive</button>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn btn-success btn-sm mb-1" style="width: 80px" onclick="toggleStatus(${dc.discountCodeID})">Active</button>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <nav aria-label="Page navigation">
                <ul class="pagination">
                    <!-- First Page -->
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/discountcodes/list?page=1&searchKeyword=${currentSearchKeyword}&filterType=${currentFilterType}&filterStatus=${currentFilterStatus}">««</a>
                    </li>
                    <!-- Previous Page -->
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/discountcodes/list?page=${currentPage - 1}&searchKeyword=${currentSearchKeyword}&filterType=${currentFilterType}&filterStatus=${currentFilterStatus}">«</a>
                    </li>
                    <!-- Page Numbers -->
                    <c:forEach begin="${currentPage - 2 > 0 ? currentPage - 2 : 1}" end="${currentPage + 2 <= totalPages ? currentPage + 2 : totalPages}" var="i">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/discountcodes/list?page=${i}&searchKeyword=${currentSearchKeyword}&filterType=${currentFilterType}&filterStatus=${currentFilterStatus}">${i}</a>
                        </li>
                    </c:forEach>
                    <!-- Next Page -->
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/discountcodes/list?page=${currentPage + 1}&searchKeyword=${currentSearchKeyword}&filterType=${currentFilterType}&filterStatus=${currentFilterStatus}">»</a>
                    </li>
                    <!-- Last Page -->
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/discountcodes/list?page=${totalPages}&searchKeyword=${currentSearchKeyword}&filterType=${currentFilterType}&filterStatus=${currentFilterStatus}">»»</a>
                    </li>
                </ul>
            </nav>
        </c:if>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
    document.getElementById('searchForm').addEventListener('submit', function(event) {
        const searchKeyword = document.getElementById('searchKeyword').value.trim();
        if (searchKeyword.length > 50) {
            alert('Search keyword must not exceed 50 characters.');
            event.preventDefault();
            return;
        }
        // Type and status are restricted by <select> options, no additional validation needed
    });
</script>
        <script>
            let msg = '${msg}';
            if (msg !== '') {
                alert(msg);
            }

            function toggleStatus(discountCodeId) {
                console.log("Toggling status for ID:", discountCodeId);
                if (!Number.isInteger(discountCodeId) || discountCodeId <= 0) {
                    alert("Invalid discount code ID.");
                    return;
                }

                fetch('${pageContext.request.contextPath}/discountcodes/toggle', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: 'id=' + encodeURIComponent(discountCodeId)
                })
                .then(response => {
                    if (!response.ok) {
                        return response.json().then(data => {
                            throw new Error(data.message || `HTTP error! Status: ${response.status}`);
                        });
                    }
                    return response.json();
                })
                .then(data => {
                    if (data.success) {
                        alert(data.message || "Status updated successfully.");
                        window.location.reload();
                    } else {
                        alert(data.message || "Failed to update status.");
                    }
                })
                .catch(error => {
                    console.error("Toggle error:", error);
                    if (error.message.includes("Unauthorized")) {
                        alert("Your session has expired. Please log in again.");
                        window.location.href = '${pageContext.request.contextPath}/login.jsp';
                    } else {
                        alert("Error: " + error.message);
                    }
                });
            }
        </script>
    </div>
</body>
</html>