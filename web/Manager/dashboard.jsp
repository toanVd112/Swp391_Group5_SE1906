<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thống Kê Khách Sạn</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <style>
        body { background-color: #f8f9fa; }
        .card { margin-bottom: 20px; }
        .filter-form { margin-bottom: 20px; }
        .chart-container { max-width: 400px; margin: auto; }
        .btn-group { margin: 5px; }
    </style>
</head>
<body>
    <div class="container mt-4">
        <h1 class="text-center mb-4">Dashboard Thống Kê Khách Sạn</h1>

        <!-- Form lọc thời gian với nút bấm -->
        <div class="filter-form">
            <div class="row">
                <div class="col-md-4">
                    <select class="form-select" name="timeRange" id="timeRange">
                        <option value="day" <c:if test="${timeRange == 'day'}">selected</c:if>>Hôm nay</option>
                        <option value="week" <c:if test="${timeRange == 'week'}">selected</c:if>>Tuần này</option>
                        <option value="month" <c:if test="${timeRange == 'month'}">selected</c:if>>Tháng này</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <button type="button" class="btn btn-primary" onclick="filterData()">Lọc Dữ Liệu</button>
                    <button type="button" class="btn btn-success" onclick="exportReport()">Xuất Báo Cáo (PDF)</button>
                    <button type="button" class="btn btn-warning" onclick="refreshData()">Làm Mới</button>
                </div>
            </div>
        </div>

        <!-- Thống kê phòng -->
        <div class="row">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">Tỷ Lệ Lấp Đầy Phòng
                        <div class="btn-group float-end">
                            <button type="button" class="btn btn-info btn-sm" onclick="viewRoomDetails()">Xem Chi Tiết</button>
                            <button type="button" class="btn btn-secondary btn-sm" onclick="updateRoomStatus()">Cập Nhật Trạng Thái</button>
                        </div>
                    </div>
                    <div class="card-body">
                        <p>Tỷ lệ lấp đầy: <strong>${stats.occupancyRate}%</strong></p>
                        <p>Phòng đã đặt: ${stats.bookedRooms}/${stats.totalRooms}</p>
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>Loại phòng</th>
                                    <th>Số phòng đã đặt</th>
                                    <th>Tỷ lệ</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="roomType" items="${stats.roomTypeStats}">
                                    <tr>
                                        <td>${roomType.type}</td>
                                        <td>${roomType.booked}</td>
                                        <td>${roomType.percentage}%</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        <div class="chart-container">
                            <canvas id="roomChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Thống kê doanh thu -->
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">Doanh Thu
                        <div class="btn-group float-end">
                            <button type="button" class="btn btn-info btn-sm" onclick="viewRevenueDetails()">Xem Chi Tiết</button>
                            <button type="button" class="btn btn-secondary btn-sm" onclick="exportRevenue()">Xuất Doanh Thu</button>
                        </div>
                    </div>
                    <div class="card-body">
                        <p>Tổng doanh thu: <strong>${stats.totalRevenue} VNĐ</strong></p>
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>Nguồn</th>
                                    <th>Doanh thu (VNĐ)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr><td>Phòng</td><td>${stats.roomRevenue}</td></tr>
                                <tr><td>Nhà hàng</td><td>${stats.restaurantRevenue}</td></tr>
                                <tr><td>Dịch vụ khác</td><td>${stats.otherRevenue}</td></tr>
                            </tbody>
                        </table>
                        <div class="chart-container">
                            <canvas id="revenueChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Thống kê khách hàng -->
        <div class="row">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">Thống Kê Khách Hàng
                        <div class="btn-group float-end">
                            <button type="button" class="btn btn-info btn-sm" onclick="viewCustomerDetails()">Xem Chi Tiết</button>
                            <button type="button" class="btn btn-secondary btn-sm" onclick="updateCustomerData()">Cập Nhật Dữ Liệu</button>
                        </div>
                    </div>
                    <div class="card-body">
                        <p>Tổng số khách: <strong>${stats.totalCustomers}</strong></p>
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>Nguồn</th>
                                    <th>Số lượng</th>
                                    <th>Tỷ lệ</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr><td>OTA</td><td>${stats.otaCustomers}</td><td>${stats.otaPercentage}%</td></tr>
                                <tr><td>Website</td><td>${stats.websiteCustomers}</td><td>${stats.websitePercentage}%</td></tr>
                                <tr><td>Khách trực tiếp</td><td>${stats.directCustomers}</td><td>${stats.directPercentage}%</td></tr>
                            </tbody>
                        </table>
                        <div class="chart-container">
                            <canvas id="customerChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Thống kê vận hành -->
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">Thống Kê Vận Hành
                        <div class="btn-group float-end">
                            <button type="button" class="btn btn-info btn-sm" onclick="viewOperationDetails()">Xem Chi Tiết</button>
                            <button type="button" class="btn btn-secondary btn-sm" onclick="updateOperation()">Cập Nhật Vận Hành</button>
                        </div>
                    </div>
                    <div class="card-body">
                        <p>Phòng đã dọn: <strong>${stats.cleanedRooms}</strong></p>
                        <p>Phòng chờ dọn: <strong>${stats.pendingRooms}</strong></p>
                        <p>Chi phí vận hành: <strong>${stats.operationalCost} VNĐ</strong></p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS and Chart.js scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Biểu đồ tỷ lệ lấp đầy phòng
        const roomChart = new Chart(document.getElementById('roomChart'), {
            type: 'pie',
            data: {
                labels: [<c:forEach var="roomType" items="${stats.roomTypeStats}">'${roomType.type}',</c:forEach>],
                datasets: [{
                    data: [<c:forEach var="roomType" items="${stats.roomTypeStats}">${roomType.booked},</c:forEach>],
                    backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56']
                }]
            },
            options: { responsive: true }
        });

        // Biểu đồ doanh thu
        const revenueChart = new Chart(document.getElementById('revenueChart'), {
            type: 'bar',
            data: {
                labels: ['Phòng', 'Nhà hàng', 'Dịch vụ khác'],
                datasets: [{
                    label: 'Doanh thu (VNĐ)',
                    data: [${stats.roomRevenue}, ${stats.restaurantRevenue}, ${stats.otherRevenue}],
                    backgroundColor: '#36A2EB'
                }]
            },
            options: { responsive: true }
        });

        // Biểu đồ khách hàng
        const customerChart = new Chart(document.getElementById('customerChart'), {
            type: 'pie',
            data: {
                labels: ['OTA', 'Website', 'Khách trực tiếp'],
                datasets: [{
                    data: [${stats.otaCustomers}, ${stats.websiteCustomers}, ${stats.directCustomers}],
                    backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56']
                }]
            },
            options: { responsive: true }
        });

        // Hàm xử lý các nút bấm
        function filterData() {
            const timeRange = document.getElementById('timeRange').value;
            window.location.href = 'DashboardServlet?timeRange=' + timeRange;
        }

        function exportReport() {
            alert('Chức năng xuất báo cáo PDF sẽ được thực hiện. (Cần tích hợp backend)');
            // Thêm logic gọi servlet để xuất file (ví dụ: window.location.href = 'ExportServlet')
        }

        function refreshData() {
            window.location.href = 'DashboardServlet';
        }

        function viewRoomDetails() { alert('Xem chi tiết phòng...'); }
        function updateRoomStatus() { alert('Cập nhật trạng thái phòng...'); }
        function viewRevenueDetails() { alert('Xem chi tiết doanh thu...'); }
        function exportRevenue() { alert('Xuất doanh thu...'); }
        function viewCustomerDetails() { alert('Xem chi tiết khách hàng...'); }
        function updateCustomerData() { alert('Cập nhật dữ liệu khách hàng...'); }
        function viewOperationDetails() { alert('Xem chi tiết vận hành...'); }
        function updateOperation() { alert('Cập nhật vận hành...'); }
    </script>
</body>
</html>