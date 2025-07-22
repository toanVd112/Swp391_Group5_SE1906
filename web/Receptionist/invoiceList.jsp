<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.text.SimpleDateFormat, model.Invoice" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Danh sách hóa đơn</title>

        <!-- External CSS -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

        <style>
            /* CSS Variables */
            :root {
                --color-paid: #dcfce7;
                --color-paid-text: #166534;
                --color-unpaid: #fee2e2;
                --color-unpaid-text: #dc2626;
                --color-primary: #dbeafe;
                --color-primary-text: #1d4ed8;
            }

            .badge-paid {
                background-color: var(--color-paid);
                color: var(--color-paid-text);
            }

            .badge-unpaid {
                background-color: var(--color-unpaid);
                color: var(--color-unpaid-text);
            }

            .table-hover tbody tr:hover {
                background-color: rgba(0, 0, 0, 0.02);
            }

            .form-control:invalid,
            .form-select:invalid {
                border-color: #dc3545;
            }

            .form-control:valid,
            .form-select:valid {
                border-color: #198754;
            }

            .filter-section {
                background-color: #f8f9fa;
                border: 1px solid #dee2e6;
                border-radius: 0.375rem;
            }

            .currency-amount {

                font-weight: 600;
            }

            .invoice-code {

                background-color: #e9ecef;
                padding: 2px 6px;
                border-radius: 4px;
                font-size: 0.875rem;
            }

            /* Responsive adjustments */
            @media (max-width: 768px) {
                .card-header {
                    flex-direction: column;
                    gap: 1rem;
                }

                .table-responsive {
                    overflow-x: auto;
                    -webkit-overflow-scrolling: touch;
                }

                .table td {
                    white-space: nowrap;
                    min-width: 120px;
                }

                .filter-form .row {
                    gap: 0.5rem;
                }
            }

            .btn-export {
                background: linear-gradient(45deg, #28a745, #20c997);
                border: none;
                transition: all 0.3s ease;
            }

            .btn-export:hover {
                background: linear-gradient(45deg, #218838, #1ea085);
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            }
            .text-nowrap {
                white-space: nowrap;
            }

        </style>
    </head>

    <body class="bg-light">

        <!-- Main Card -->
        <div class="card shadow-sm">
            <div class="card-header bg-white d-flex justify-content-between align-items-center flex-wrap"> 
                <h2 class="h4 mb-0"> 
                    <i class="fas fa-file-invoice-dollar me-2 text-primary"></i> 
                    List of invoices 
                </h2> 
                
            </div> 

            <div class="card-body"> 
                <!-- Filter Section --> 
                <div class="filter-section p-4 mb-4">
                    <h5 class="mb-3">
                        <i class="fas fa-filter me-2 text-info"></i>
                        Search filters
                    </h5>

                    <form method="get" action="InvoiceListServlet" class="filter-form"> 
                        <div class="row g-3"> 
                            <div class="col-md-3"> 
                                <label class="form-label fw-bold"> 
                                    <i class="fas fa-user me-1"></i> 
                                    Customer name: 
                                </label> 
                                <input type="text" name="customerName" 
                                       value="<%= request.getAttribute("customerName") != null ? request.getAttribute("customerName") : "" %>" 
                                       class="form-control" placeholder="Enter customer name..." /> 
                            </div> 

                            <div class="col-md-2"> 
                                <label class="form-label fw-bold"> 
                                    <i class="fas fa-calendar-alt me-1"></i> 
                                    From date: 
                                </label> 
                                <input type="date" name="fromDate" 
                                       value="<%= request.getAttribute("fromDate") != null ? request.getAttribute("fromDate") : "" %>" 
                                       class="form-control" /> 
                            </div> 

                            <div class="col-md-2"> 
                                <label class="form-label fw-bold"> 
                                    <i class="fas fa-calendar-alt me-1"></i> 
                                    Arrival date: 
                                </label> 
                                <input type="date" name="toDate" 
                                       value="<%= request.getAttribute("toDate") != null ? request.getAttribute("toDate") : "" %>" 
                                       class="form-control" /> 
                            </div> 

                            <div class="col-md-3"> 
                                <label class="form-label fw-bold"> 
                                    <i class="fas fa-credit-card me-1"></i> 
                                    Payment status: 
                                </label> 
                                <select name="paymentStatus" class="form-select"> 
                                    <option value="">All</option> 
                                    <option value="PAID" <%= "PAID".equals(request.getAttribute("paymentStatus")) ? "selected" : "" %>> 
                                    <i class="fas fa-check-circle"></i> Paid 
                                    </option> 
                                    <option value="UNPAID" <%= "UNPAID".equals(request.getAttribute("paymentStatus")) ? "selected" : "" %>> 
                                    <i class="fas fa-times-circle"></i> Unpaid 
                                    </option> 
                                </select> 
                            </div> 

                            <div class="col-md-2 d-flex align-items-end"> 
                                <div class="d-flex gap-2 w-100"> 
                                    <button type="submit" class="btn btn-primary"> 
                                        <i class="fas fa-search me-2"></i>Filter 
                                    </button> 
                                    <a href="InvoiceListServlet" class="btn btn-secondary"> 
                                        <i class="fas fa-redo me-2"></i>Reset 
                                    </a> 
                                </div> 
                            </div> 
                        </div> 
                    </form>
                </div>

                <!-- Invoice Table -->
                <div class="table-responsive">
                    <table class="table table-hover table-bordered">
                        <thead class="table-primary">
                            <tr>
                                <th width = "120">
                                    <i class="fas fa-hashtag me-1"></i>
                                    Invoice code
                                </th>
                                <th width = "120">
                                    <i class="fas fa-calendar me-1"></i>
                                    Created date
                                </th>
                                <th>
                                    <i class="fas fa-user me-1"></i>
                                    Customer name
                                </th>
                                <th width = "100">
                                    <i class="fas fa-bed me-1"></i>
                                    Booking code
                                </th>
                                <--<!-- comment -->
                                <th width = "130">
                                    <i class="fas fa-home me-1"></i>
                                    room currency
                                </th>
                                <th width = "130">
                                    <i class="fas fa-concierge-bell me-1"></i>
                                    Service money
                                </th>

                                <!--  <th width = "100">
                                    <i class="fas fa-percentage me-1"></i>
                                    Discount
                                </th> -->
                                <th width = "130">
                                    <i class="fas fa-dollar-sign me-1"></i>
                                    Total
                                </th>
                                <th width = "120">
                                    <i class="fas fa-credit-card me-1"></i>
                                    Status
                                </th>
                                <-<!-- comment -->
                                <th width = "100">
                                    <i class="fas fa-cogs me-1"></i>
                                    Action
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<Invoice> invoiceList = (List<Invoice>) request.getAttribute("invoiceList");
                                if (invoiceList != null && !invoiceList.isEmpty()) {
                                    for (Invoice invoice : invoiceList) {
                            %>
                            <tr>
                                <td>
                                    <span class="badge bg-secondary">#<%= invoice.getInvoiceId() %></span>
                                </td>
                                <%
 java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy");
 String formattedDate = sdf.format(java.sql.Date.valueOf(invoice.getIssuedDate().toLocalDate()));
                                %>
                                <td class="text-nowrap">
                                    <i class="fas fa-calendar-day me-1 text-muted"></i>
                                    <span><%= formattedDate %></span>
                                </td>

                                <td>
                                    <i class="fas fa-user-circle me-1 text-primary"></i>
                                    <strong><%= invoice.getCustomerName() %></strong>
                                </td>
                                <td>
                                    <span class="badge bg-secondary">#<%= invoice.getBookingId() %></span>
                                </td>
                                <td>
                                    <span class="currency-amount text-success">
                                        <%= String.format("%,.0f", invoice.getRoomTotal()) %> đ
                                    </span>
                                </td>
                                <td class="text-nowrap">
                                    <span class="currency-amount text-primary fw-bold">
                                        <%= String.format("%,.0f", invoice.getTotalAmount()) %> đ
                                    </span>
                                    <% if (invoice.getDiscountPercent() > 0) { %>
                                    <br/>
                                    <span class="badge bg-warning text-dark mt-1">
                                        <i class="fas fa-percentage me-1"></i>
                                        Giảm <%= invoice.getDiscountPercent() %>%
                                    </span>
                                    <% } %>
                                </td>


                                <!-- <td>
                                <% if (invoice.getDiscountPercent() > 0) { %>
                                <span class="badge bg-warning text-dark">
                                    <i class="fas fa-tag me-1"></i>
                                <%= invoice.getDiscountPercent() %>%
                            </span>
                                <% } else { %>
                                <span class="text-muted">-</span>
                                <% } %>
                            </td> -->
                                <td>
                                    <span class="currency-amount text-primary fw-bold">
                                        <%= String.format("%,.0f", invoice.getTotalAmount()) %> đ
                                    </span>
                                </td>
                                <td>
                                    <% if ("PAID".equals(invoice.getPaymentStatus())) { %>
                                    <span class="badge badge-paid">
                                        <i class="fas fa-check-circle me-1"></i>
                                        Paid
                                    </span>
                                    <% } else { %>
                                    <span class="badge badge-unpaid">
                                        <i class="fas fa-times-circle me-1"></i>
                                        UnPaid                                        </span>
                                        <% } %>
                                </td>
                                <td>
                                    <button class="btn btn-export btn-sm" 
                                            onclick="exportToPDF(<%= invoice.getInvoiceId() %>)"
                                            title="Xuất PDF">
                                        <i class="fas fa-file-pdf me-1"></i>
                                        PDF
                                    </button>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="10" class="text-center py-4">
                                    <div class="d-flex flex-column align-items-center">
                                        <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                        <h5 class="text-muted">Không có hóa đơn nào phù hợp</h5>
                                        <p class="text-muted mb-0">Thử thay đổi bộ lọc tìm kiếm để xem thêm kết quả</p>
                                    </div>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>

                <!-- Summary Statistics -->
                <% if (invoiceList != null && !invoiceList.isEmpty()) { %>
                <div class="row mt-4">
                    <div class="col-md-12">
                        <div class="card bg-light">
                            <div class="card-body"> 
                                <h6 class="card-title"> 
                                    <i class="fas fa-chart-bar me-2"></i> 
                                    General statistics 
                                </h6> 
                                <div class="row text-center"> 
                                    <div class="col-md-3"> 
                                        <div class="border-end"> 
                                            <h5 class="text-primary mb-0"><%= invoiceList.size() %></h5> 
                                            <small class="text-muted">Total invoice</small> 
                                        </div> 
                                    </div> 
                                    <div class="col-md-3"> 
                                        <div class="border-end"> 
                                            <% 
                                            long paidCount = invoiceList.stream() 
                                            .filter(inv -> "PAID".equals(inv.getPaymentStatus())) 
                                            .count(); 
                                            %> 
                                            <h5 class="text-success mb-0"><%= paidCount %></h5> 
                                            <small class="text-muted">Paid</small> 
                                        </div> 
                                    </div> 
                                    <div class="col-md-3"> 
                                        <div class="border-end"> 
                                            <h5 class="text-warning mb-0"><%= invoiceList.size() - paidCount %></h5> 
                                            <small class="text-muted">Unpaid</small> 
                                        </div> 
                                    </div> 
                                    <div class="col-md-3"> 
                                        <% 
                                        double totalAmount = invoiceList.stream() 
                                        .mapToDouble(Invoice::getTotalAmount) 
                                        .sum(); 
                                        %>
                                        <h5 class="text-info mb-0"><%= String.format("%,.0f", totalAmount) %> đ</h5>
                                        <small class="text-muted">Total Revenue</small>
                                    </div>
                                </div>                                
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>

                <div class="card-footer bg-white">
                    <div class="d-flex justify-content-between align-items-center">
                        <a href="Manager/manager.jsp" class="btn btn-primary">
                            <i class="fas fa-home me-2"></i>Comeback Home
                        </a>
                        <small class="text-muted">
                            <i class="fas fa-clock me-1"></i>
                            last update: <%= new java.util.Date() %>
                        </small>
                    </div>
                </div>
            </div>
        </div>

        <!-- JavaScript Libraries -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                                                // Export to PDF function
                                                function exportToPDF(invoiceId) {
                                                    // Show loading state
                                                    const button = event.target.closest('button');
                                                    const originalContent = button.innerHTML;
                                                    button.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Đang xuất...';
                                                    button.disabled = true;

                                                    // Open PDF in new window
                                                    window.open('GenerateInvoicePDFServlet?invoiceId=' + invoiceId, '_blank');

                                                    // Reset button after 2 seconds
                                                    setTimeout(() => {
                                                        button.innerHTML = originalContent;
                                                        button.disabled = false;
                                                    }, 2000);
                                                }

                                                // Export to Excel function (placeholder)
                                                function exportToExcel() {
                                                    alert('Chức năng xuất Excel đang được phát triển!');
                                                }

                                                // Auto-submit form when date changes
                                                document.addEventListener('DOMContentLoaded', function () {
                                                    const dateInputs = document.querySelectorAll('input[type="date"]');
                                                    dateInputs.forEach(input => {
                                                        input.addEventListener('change', function () {
                                                            // Optional: Auto-submit form when date changes
                                                            // this.form.submit();
                                                        });
                                                    });

                                                    // Add loading state to filter button
                                                    const filterForm = document.querySelector('.filter-form');
                                                    if (filterForm) {
                                                        filterForm.addEventListener('submit', function () {
                                                            const submitBtn = this.querySelector('button[type="submit"]');
                                                            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang lọc...';
                                                            submitBtn.disabled = true;
                                                        });
                                                    }
                                                });

                                                // Print functionality
                                                function printInvoiceList() {
                                                    window.print();
                                                }

                                                // Responsive table handling
                                                function handleResponsiveTable() {
                                                    const table = document.querySelector('.table-responsive');
                                                    if (window.innerWidth < 768) {
                                                        table.style.fontSize = '0.875rem';
                                                    } else {
                                                        table.style.fontSize = '1rem';
                                                    }
                                                }

                                                window.addEventListener('resize', handleResponsiveTable);
                                                document.addEventListener('DOMContentLoaded', handleResponsiveTable);
        </script>
    </body>
</html>