<%@ page import="java.util.*, model.Booking, model.InvoiceData" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
//    List<Booking> completedBookings = (List<Booking>) request.getAttribute("completedBookings");
//    InvoiceData invoiceData = (InvoiceData) request.getAttribute("invoiceData");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Invoice</title>
    
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

        .readonly-field {
            background-color: #f8f9fa;
            border-color: #dee2e6;
        }

        .invoice-section {
            border: 1px solid #dee2e6;
            border-radius: 0.375rem;
            background-color: #ffffff;
        }

        .debug-section {
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 0.375rem;
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
        }
    </style>
</head>

<body class="bg-light">
    <div class="container py-4">
        <!-- Last Invoices Section -->
        <div class="card shadow-sm mb-4">
            <div class="card-header bg-white">
                <h3 class="h5 mb-0">
                    <i class="fas fa-history me-2 text-primary"></i>
                    5 Last Invoices
                </h3>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover table-bordered">
                        <thead class="table-primary">
                            <tr>
                                <th>Booking ID</th>
                                <th>Customer</th>
                                <th>Issued Date</th>
                                <th>Total Amount</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="inv" items="${lastInvoices}">
                                <tr>
                                    <td><span class="badge bg-secondary">${inv.bookingId}</span></td>
                                    <td>${fn:escapeXml(inv.customerName)}</td>
                                    <td>${fn:escapeXml(inv.issuedDate)}</td>
                                    <td><strong class="text-success">${inv.totalAmount} VND</strong></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Create Invoice Section -->
        <div class="card shadow-sm">
            <div class="card-header bg-white">
                <h2 class="h4 mb-0">
                    <i class="fas fa-file-invoice me-2 text-success"></i>
                    Create Invoice
                </h2>
            </div>
            
            <div class="card-body">
                <!-- Error Messages -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show mb-4">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        ${fn:escapeXml(error)}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <!-- Booking Selection Form -->
                <form method="get" action="${pageContext.request.contextPath}/LoadInvoiceDataServlet" class="mb-4">
                    <div class="row">
                        <div class="col-md-8">
                            <label class="form-label fw-bold">
                                <i class="fas fa-calendar-check me-2"></i>
                                Select Completed Booking:
                            </label>
                            <select name="bookingId" onchange="this.form.submit()" class="form-select shadow-sm">
                                <option value="">-- Select a booking --</option>
                                <c:forEach var="b" items="${completedBookings}">
                                    <option value="${b.bookingID}" 
                                            <c:if test="${invoiceData != null && invoiceData.bookingId == b.bookingID}">selected</c:if>>
                                        BookingID: ${b.bookingID} - Customer: ${fn:escapeXml(b.contactName)} - Checkout: ${b.checkOutDate}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                </form>

                <!-- Invoice Form -->
                <c:if test="${invoiceData != null}">
                    <form method="post" action="${pageContext.request.contextPath}/CreateInvoiceServlet">
                        <!-- Invoice Details Section -->
                        <div class="invoice-section p-4 mb-4">
                            <h5 class="mb-3">
                                <i class="fas fa-info-circle me-2 text-info"></i>
                                Invoice Details
                            </h5>
                            
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Booking ID:</label>
                                    <input type="text" name="bookingId" value="${invoiceData.bookingId}" 
                                           class="form-control readonly-field" readonly />
                                </div>
                                
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Customer Name:</label>
                                    <input type="text" value="${fn:escapeXml(invoiceData.customerName)}" 
                                           class="form-control readonly-field" readonly />
                                </div>
                                
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Invoice Date:</label>
                                    <input type="text" value="${fn:escapeXml(invoiceData.issuedDate)}" 
                                           class="form-control readonly-field" readonly />
                                </div>
                                
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Room Total:</label>
                                    <input type="text" value="${invoiceData.roomTotal} VND" 
                                           class="form-control readonly-field" readonly />
                                </div>
                                
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Service Total:</label>
                                    <input type="text" value="${invoiceData.serviceTotal} VND" 
                                           class="form-control readonly-field" readonly />
                                </div>
                                
                                <c:if test="${invoiceData.discountCode != null}">
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold">Discount Code:</label>
                                        <input type="text" value="${fn:escapeXml(invoiceData.discountCode)} (-${invoiceData.discountPercent}%)" 
                                               class="form-control readonly-field" readonly />
                                    </div>
                                </c:if>
                                
                                <div class="col-12">
                                    <label class="form-label fw-bold text-success">
                                        <i class="fas fa-dollar-sign me-2"></i>
                                        Final Total:
                                    </label>
                                    <input type="text" value="${invoiceData.totalAmount} VND" 
                                           class="form-control readonly-field fw-bold text-success" readonly />
                                </div>
                            </div>
                        </div>

                        <!-- Payment Information Section -->
                        <div class="invoice-section p-4 mb-4">
                            <h5 class="mb-3">
                                <i class="fas fa-credit-card me-2 text-warning"></i>
                                Payment Information
                            </h5>
                            
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Payment Status: <span class="text-danger">*</span></label>
                                    <select name="paymentStatus" class="form-select" required>
                                        <option value="">-- Select Status --</option>
                                        <option value="PAID">
                                            <i class="fas fa-check-circle"></i> Paid
                                        </option>
                                        <option value="UNPAID">
                                            <i class="fas fa-times-circle"></i> Unpaid
                                        </option>
                                    </select>
                                    <div class="invalid-feedback">Please select a payment status.</div>
                                </div>
                                
                                <div class="col-12">
                                    <label class="form-label fw-bold">Note:</label>
                                    <textarea name="note" rows="3" class="form-control" 
                                              placeholder="Enter any additional notes..."></textarea>
                                </div>
                            </div>
                        </div>

                        <!-- Hidden Fields -->
                        <input type="hidden" name="roomTotal" value="${invoiceData.roomTotal}" />
                        <input type="hidden" name="serviceTotal" value="${invoiceData.serviceTotal}" />
                        <input type="hidden" name="discountCode" value="${invoiceData.discountCode}" />
                        <input type="hidden" name="discountPercent" value="${invoiceData.discountPercent}" />
                        <input type="hidden" name="totalAmount" value="${invoiceData.totalAmount}" />

                        <!-- Submit Button -->
                        <div class="d-flex justify-content-end gap-2">
                            <button type="button" class="btn btn-secondary" onclick="window.history.back()">
                                <i class="fas fa-arrow-left me-2"></i>Cancel
                            </button>
                            <button type="submit" class="btn btn-success">
                                <i class="fas fa-file-invoice me-2"></i>Create Invoice
                            </button>
                        </div>
                    </form>

                    <!-- Debug Section -->
                    <div class="debug-section p-3 mt-4">
                        <h6 class="mb-3">
                            <i class="fas fa-bug me-2 text-muted"></i>
                            Debug Invoice Values:
                        </h6>
                        <div class="row g-2 small text-muted">
                            <div class="col-md-6">
                                <strong>Room Total:</strong> ${invoiceData.roomTotal}
                            </div>
                            <div class="col-md-6">
                                <strong>Service Total:</strong> ${invoiceData.serviceTotal}
                            </div>
                            <div class="col-md-6">
                                <strong>Discount Code:</strong> ${invoiceData.discountCode}
                            </div>
                            <div class="col-md-6">
                                <strong>Discount %:</strong> ${invoiceData.discountPercent}
                            </div>
                            <div class="col-12">
                                <strong>Total Amount:</strong> ${invoiceData.totalAmount}
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <!-- JavaScript Libraries -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Form validation
            const forms = document.querySelectorAll('form[method="post"]');
            forms.forEach(form => {
                form.addEventListener('submit', function(e) {
                    const paymentStatus = form.querySelector('select[name="paymentStatus"]');
                    
                    if (paymentStatus && !paymentStatus.value) {
                        e.preventDefault();
                        paymentStatus.classList.add('is-invalid');
                        paymentStatus.focus();
                        return false;
                    }
                });
            });

            // Remove invalid class on change
            const selects = document.querySelectorAll('select[required]');
            selects.forEach(select => {
                select.addEventListener('change', function() {
                    if (this.value) {
                        this.classList.remove('is-invalid');
                    }
                });
            });
        });
    </script>
</body>
</html>