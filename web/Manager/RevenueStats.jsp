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
    <style>
        .container { max-width: 1000px; margin-top: 2rem; }
        .chart-container { position: relative; height: 400px; margin-top: 2rem; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Revenue Statistics</h2>
        <p>Revenue from room bookings and service usage</p>
        
        <div class="chart-container">
            <canvas id="revenueChart"></canvas>
        </div>
        
        <div class="mt-4">
            <a href="${pageContext.request.contextPath}/discountcodes/list" class="btn btn-secondary">Back to Dashboard</a>
        </div>
    </div>

    <script>
        // Prepare chart data
        const labels = [];
        const roomData = [];
        const serviceData = [];

        // Room revenue data
        <c:forEach items="${roomRevenue}" var="revenue">
            labels.push('${revenue.category} (Rooms)');
            roomData.push(${revenue.amount});
            serviceData.push(0); // Placeholder for rooms
        </c:forEach>

        // Service revenue data
        <c:forEach items="${serviceRevenue}" var="revenue">
            labels.push('${revenue.category} (Services)');
            roomData.push(0); // Placeholder for services
            serviceData.push(${revenue.amount});
        </c:forEach>

        // Render chart
        const ctx = document.getElementById('revenueChart').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [
                    {
                        label: 'Room Revenue (VND)',
                        data: roomData,
                        backgroundColor: 'rgba(54, 162, 235, 0.6)',
                        borderColor: 'rgba(54, 162, 235, 1)',
                        borderWidth: 1
                    },
                    {
                        label: 'Service Revenue (VND)',
                        data: serviceData,
                        backgroundColor: 'rgba(255, 99, 132, 0.6)',
                        borderColor: 'rgba(255, 99, 132, 1)',
                        borderWidth: 1
                    }
                ]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true,
                        title: { display: true, text: 'Revenue (VND)' }
                    },
                    x: {
                        title: { display: true, text: 'Category' }
                    }
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
    </script>
</body>
</html>