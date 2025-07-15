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
    <title>Room Occupancy Statistics</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <style>
        .container { max-width: 800px; margin-top: 2rem; }
        .chart-container { position: relative; height: 400px; margin-top: 2rem; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Room Occupancy Statistics</h2>
        <p>Occupancy rates by room type (Occupied Rooms / Total Rooms)</p>
        
        <div class="chart-container">
            <canvas id="occupancyChart"></canvas>
        </div>
        
        <div class="mt-4">
            <a href="${pageContext.request.contextPath}/discountcodes/list" class="btn btn-secondary">Back to Dashboard</a>
        </div>
    </div>

    <script>
        // Prepare chart data
        const labels = [];
        const data = [];
        <c:forEach items="${occupancyList}" var="occupancy">
            labels.push('${occupancy.typeName}');
            data.push(${occupancy.occupancyRate});
        </c:forEach>

        // Render chart
        const ctx = document.getElementById('occupancyChart').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Occupancy Rate (%)',
                    data: data,
                    backgroundColor: 'rgba(54, 162, 235, 0.6)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true,
                        max: 100,
                        title: { display: true, text: 'Occupancy Rate (%)' }
                    },
                    x: {
                        title: { display: true, text: 'Room Type' }
                    }
                },
                plugins: {
                    legend: { display: true, position: 'top' },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return context.dataset.label + ': ' + context.parsed.y.toFixed(2) + '%';
                            }
                        }
                    }
                }
            }
        });
    </script>
</body>
</html>