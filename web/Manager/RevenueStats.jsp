<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
    <title>Revenue Statistics</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        .container { max-width: 1200px; margin-top: 2rem; }
        .chart-container { position: relative; height: 400px; margin-top: 2rem; }
        .filter-section { margin-bottom: 2rem; }
        .error-message { color: red; margin-top: 1rem; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Revenue Statistics</h2>
        <p>View revenue from room bookings and service usage by date range</p>

        <!-- Filter Section -->
        <div class="filter-section">
            <form id="filterForm" action="${pageContext.request.contextPath}/revenuestats" method="get">
                <div class="row">
                    <div class="col-md-3">
                        <label for="startDate" class="form-label">Start Date</label>
                        <input type="date" id="startDate" name="startDate" class="form-control" required>
                    </div>
                    <div class="col-md-3">
                        <label for="endDate" class="form-label">End Date</label>
                        <input type="date" id="endDate" name="endDate" class="form-control" required>
                    </div>
                    <div class="col-md-3">
                        <label for="groupBy" class="form-label">Group By</label>
                        <select id="groupBy" name="groupBy" class="form-select">
                            <option value="day">Day</option>
                            <option value="month">Month</option>
                            <option value="year">Year</option>
                        </select>
                    </div>
                    <div class="col-md-3 align-self-end">
                        <button type="submit" class="btn btn-primary">Apply Filter</button>
                        <button type="button" id="exportCsv" class="btn btn-success">Export CSV</button>
                    </div>
                </div>
            </form>
        </div>

        <!-- Error Message -->
        <c:if test="${empty roomRevenue and empty serviceRevenue}">
            <div class="error-message">No revenue data available for the selected period.</div>
        </c:if>

        <!-- Chart Tabs -->
        <ul class="nav nav-tabs mb-3">
            <li class="nav-item">
                <a class="nav-link active" id="room-tab" data-bs-toggle="tab" href="#roomChartTab">Room Revenue</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" id="service-tab" data-bs-toggle="tab" href="#serviceChartTab">Service Revenue</a>
            </li>
        </ul>

        <div class="tab-content">
            <div class="tab-pane fade show active" id="roomChartTab">
                <div class="chart-container">
                    <canvas id="roomRevenueChart"></canvas>
                </div>
            </div>
            <div class="tab-pane fade" id="serviceChartTab">
                <div class="chart-container">
                    <canvas id="serviceRevenueChart"></canvas>
                </div>
            </div>
        </div>

        <div class="mt-4">
            <a href="${pageContext.request.contextPath}/Manager/manager.jsp" class="btn btn-secondary">Back to Dashboard</a>
        </div>
    </div>

    <script>
        // Room Revenue Chart
        const roomLabels = [];
        const roomData = [];
        <c:forEach items="${roomRevenue}" var="revenue">
            roomLabels.push('${revenue.category}');
            roomData.push(${revenue.amount});
        </c:forEach>

        const roomCtx = document.getElementById('roomRevenueChart').getContext('2d');
        new Chart(roomCtx, {
            type: 'bar',
            data: {
                labels: roomLabels,
                datasets: [{
                    label: 'Room Revenue (VND)',
                    data: roomData,
                    backgroundColor: 'rgba(54, 162, 235, 0.6)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: { beginAtZero: true, title: { display: true, text: 'Revenue (VND)' } },
                    x: { title: { display: true, text: 'Room Type' }, ticks: { maxRotation: 45, minRotation: 45 } }
                },
                plugins: {
                    legend: { display: true, position: 'top' },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return context.dataset.label + ': ' + context.parsed.y.toLocaleString('vi-VN') + ' VND';
                            }
                        }
                    }
                }
            }
        });

        // Service Revenue Chart
        const serviceLabels = [];
        const serviceData = [];
        <c:forEach items="${serviceRevenue}" var="revenue">
            serviceLabels.push('${revenue.category}');
            serviceData.push(${revenue.amount});
        </c:forEach>

        const serviceCtx = document.getElementById('serviceRevenueChart').getContext('2d');
        new Chart(serviceCtx, {
            type: 'bar',
            data: {
                labels: serviceLabels,
                datasets: [{
                    label: 'Service Revenue (VND)',
                    data: serviceData,
                    backgroundColor: 'rgba(255, 99, 132, 0.6)',
                    borderColor: 'rgba(255, 99, 132, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: { beginAtZero: true, title: { display: true, text: 'Revenue (VND)' } },
                    x: { title: { display: true, text: 'Service Type' }, ticks: { maxRotation: 45, minRotation: 45 } }
                },
                plugins: {
                    legend: { display: true, position: 'top' },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return context.dataset.label + ': ' + context.parsed.y.toLocaleString('vi-VN') + ' VND';
                            }
                        }
                    }
                }
            }
        });

        // Export CSV
        document.getElementById('exportCsv').addEventListener('click', function() {
            let csv = 'Category,Type,Amount (VND)\n';
            roomLabels.forEach((label, index) => {
                csv += `${label},Room,${roomData[index].toLocaleString('vi-VN')}\n`;
            });
            serviceLabels.forEach((label, index) => {
                csv += `${label},Service,${serviceData[index].toLocaleString('vi-VN')}\n`;
            });
            const blob = new Blob([csv], { type: 'text/csv' });
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = 'revenue_statistics.csv';
            a.click();
            window.URL.revokeObjectURL(url);
        });
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>