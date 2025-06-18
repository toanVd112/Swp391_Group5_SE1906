<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.Account" %>
<%@ page import="DAO.RoomInspectionReportDAO" %>

<%@ page import="java.sql.SQLException" %>
<%
    Account account = (Account) session.getAttribute("account");
    if (account == null || !"Receptionist".equals(account.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Gửi Yêu Cầu Bảo Trì</title>

        <link href="https://fonts.googleapis.com/css2?family=Roboto&display=swap" rel="stylesheet">
        <style>
/* Maintenance Request Page Styles - Based on Room Inspection Design */
.maintenance-request-page {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

.maintenance-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0;
}

/* Page Header */
.page-header {
    margin-bottom: 2rem;
    padding-bottom: 1rem;
    border-bottom: 2px solid #e9ecef;
}

.page-title {
    color: #2c3e50;
    font-size: 2rem;
    font-weight: 600;
    margin-bottom: 0.5rem;
    display: flex;
    align-items: center;
}

.page-subtitle {
    color: #6c757d;
    font-size: 1.1rem;
    margin: 0;
}

/* Section Headers */
.section-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 1.5rem;
}

.section-title {
    color: #495057;
    font-size: 1.5rem;
    font-weight: 500;
    margin: 0;
    display: flex;
    align-items: center;
}

/* Form Styles */
.form-card {
    background: #ffffff;
    border-radius: 12px;
    padding: 2rem;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
    border: 1px solid #e9ecef;
    margin-bottom: 2rem;
}

.maintenance-form {
    display: flex;
    flex-direction: column;
    gap: 1.5rem;
}

.form-row {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 1.5rem;
}

.form-group {
    display: flex;
    flex-direction: column;
}

.form-label {
    font-weight: 500;
    color: #495057;
    margin-bottom: 0.5rem;
    display: flex;
    align-items: center;
}

.form-control {
    padding: 0.75rem 1rem;
    border: 2px solid #e9ecef;
    border-radius: 8px;
    font-size: 1rem;
    transition: all 0.3s ease;
    background-color: #ffffff;
}

.form-control:focus {
    outline: none;
    border-color: #007bff;
    box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.1);
}

.form-control:hover {
    border-color: #ced4da;
}

textarea.form-control {
    resize: vertical;
    min-height: 100px;
}

.form-actions {
    display: flex;
    gap: 1rem;
    justify-content: flex-start;
    margin-top: 1rem;
}

.btn {
    padding: 0.75rem 1.5rem;
    border: none;
    border-radius: 8px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.3s ease;
    display: inline-flex;
    align-items: center;
    text-decoration: none;
    font-size: 1rem;
}

.btn-primary {
    background-color: #007bff;
    color: white;
}

.btn-primary:hover {
    background-color: #0056b3;
    transform: translateY(-1px);
}

/* Error Message */
.error-message {
    background-color: #f8d7da;
    color: #721c24;
    padding: 1rem 1.5rem;
    border-radius: 8px;
    margin-bottom: 1rem;
    display: flex;
    align-items: center;
    border: 1px solid #f5c6cb;
}

/* Table Styles */
.table-card {
    background: #ffffff;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
    border: 1px solid #e9ecef;
}

.table-responsive {
    overflow-x: auto;
}

.maintenance-table {
    width: 100%;
    border-collapse: collapse;
    margin: 0;
}

.maintenance-table thead {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
}

.maintenance-table th {
    padding: 1rem;
    text-align: left;
    font-weight: 600;
    font-size: 0.9rem;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.maintenance-table td {
    padding: 1rem;
    border-bottom: 1px solid #e9ecef;
    vertical-align: middle;
}

.maintenance-table tbody tr:hover {
    background-color: #f8f9fa;
}

.maintenance-table tbody tr:last-child td {
    border-bottom: none;
}

/* Table Content Styles */
.request-id {
    font-weight: 600;
    color: #495057;
}

.room-badge {
    background-color: #e3f2fd;
    color: #1976d2;
    padding: 0.25rem 0.75rem;
    border-radius: 20px;
    font-size: 0.875rem;
    font-weight: 500;
}

.staff-info {
    min-width: 150px;
}

.staff-assigned {
    display: flex;
    flex-direction: column;
}

.staff-unassigned {
    color: #ffc107;
    font-style: italic;
}

.status-badge {
    padding: 0.5rem 1rem;
    border-radius: 20px;
    font-size: 0.875rem;
    font-weight: 500;
    display: inline-flex;
    align-items: center;
    white-space: nowrap;
}

.status-done {
    background-color: #d4edda;
    color: #155724;
    border: 1px solid #c3e6cb;
}

.status-pending {
    background-color: #fff3cd;
    color: #856404;
    border: 1px solid #ffeaa7;
}

.description-cell {
    max-width: 200px;
}

.description-content {
    max-width: 200px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    cursor: help;
}

/* Empty State */
.empty-state {
    text-align: center;
    padding: 3rem 1rem;
}

.empty-content {
    display: flex;
    flex-direction: column;
    align-items: center;
}

/* Utility Classes */
.text-muted {
    color: #6c757d !important;
}

.text-success {
    color: #28a745 !important;
}

.text-warning {
    color: #ffc107 !important;
}

.me-1 {
    margin-right: 0.25rem;
}

.me-2 {
    margin-right: 0.5rem;
}

.mb-3 {
    margin-bottom: 1rem;
}

.d-block {
    display: block;
}

/* Responsive Design */
@media (max-width: 768px) {
    .form-row {
        grid-template-columns: 1fr;
        gap: 1rem;
    }

    .form-actions {
        flex-direction: column;
    }

    .section-header {
        flex-direction: column;
        align-items: flex-start;
        gap: 1rem;
    }

    .maintenance-table {
        font-size: 0.875rem;
    }

    .maintenance-table th,
    .maintenance-table td {
        padding: 0.75rem 0.5rem;
    }

    .description-cell,
    .description-content {
        max-width: 120px;
    }
}

@media (max-width: 576px) {
    .form-card {
        padding: 1.5rem;
    }

    .page-title {
        font-size: 1.5rem;
    }

    .section-title {
        font-size: 1.25rem;
    }
}
</style>
    </head>
    <body>

        <div class="maintenance-request-page">
            <div class="maintenance-container">
                <!-- Page Header -->
                <div class="page-header">
                    <h1 class="page-title">
                        <i class="fas fa-tools me-2"></i>
                        Maintenance Request Management
                    </h1>
                    <p class="page-subtitle">Submit and track maintenance requests for hotel rooms</p>
                </div>

                <!-- Add New Maintenance Request -->
                <div class="maintenance-form-section">
                    <div class="section-header">
                        <h2 class="section-title">
                            <i class="fas fa-plus-circle me-2"></i>
                            Submit New Maintenance Request
                        </h2>
                    </div>

                    <div class="form-card">
                        <c:if test="${not empty error}">
                            <div class="error-message">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                <strong>Error:</strong> ${error}
                            </div>
                        </c:if>

                        <form method="post" action="${pageContext.request.contextPath}/sendMaintenanceRequest" class="maintenance-form">
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="roomID" class="form-label">
                                        <i class="fas fa-door-open me-1"></i>
                                        Room Number
                                    </label>
                                    <input type="number" name="roomID" id="roomID" class="form-control" required />
                                </div>

                                <div class="form-group">
                                    <label for="staffID" class="form-label">
                                        <i class="fas fa-user-tie me-1"></i>
                                        Assign Staff Member
                                    </label>
                                    <select name="staffID" id="staffID" class="form-control" required>
                                        <option value="">-- Choose staff member --</option>
                                        <c:forEach var="s" items="${staffList}">
                                            <option value="${s.accountID}">${s.username}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="description" class="form-label">
                                    <i class="fas fa-clipboard-list me-1"></i>
                                    Request Description
                                </label>
                                <textarea name="description" id="description" rows="4" class="form-control" 
                                          placeholder="Describe the maintenance issue in detail..." required></textarea>
                            </div>

                            <div class="form-actions">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-paper-plane me-1"></i>
                                    Submit Request
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Maintenance Requests List -->
                <div class="maintenance-list-section">
                    <div class="section-header">
                        <h2 class="section-title">
                            <i class="fas fa-list-alt me-2"></i>
                            Maintenance Request History
                        </h2>
                    </div>

                    <div class="table-card">
                        <c:if test="${empty requestList}">
                            <div class="empty-state">
                                <div class="empty-content">
                                    <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                    <h5 class="text-muted">No maintenance requests found</h5>
                                    <p class="text-muted">Submit your first maintenance request above</p>
                                </div>
                            </div>
                        </c:if>

                        <c:if test="${not empty requestList}">
                            <div class="table-responsive">
                                <table class="maintenance-table">
                                    <thead>
                                        <tr>
                                            <th><i class="fas fa-hashtag me-1"></i>Request ID</th>
                                            <th><i class="fas fa-door-open me-1"></i>Room</th>
                                            <th><i class="fas fa-user me-1"></i>Assigned Staff</th>
                                            <th><i class="fas fa-calendar me-1"></i>Request Date</th>
                                            <th><i class="fas fa-clipboard-list me-1"></i>Description</th>
                                            <th><i class="fas fa-check-circle me-1"></i>Status</th>
                                            <th><i class="fas fa-clock me-1"></i>Completed At</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="r" items="${requestList}">
                                            <tr>
                                                <td class="request-id">#${r.requestID}</td>
                                                <td>
                                                    <span class="room-badge">Room ${r.roomID}</span>
                                                </td>
                                                <td class="staff-info">
                                                    <c:choose>
                                                        <c:when test="${not empty r.staffID}">
                                                            <div class="staff-assigned">
                                                                <i class="fas fa-user-check text-success me-1"></i>
                                                                <strong><c:out value="${staffMap[r.staffID]}" default="Unknown" /></strong>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="staff-unassigned">
                                                                <i class="fas fa-user-times text-warning me-1"></i>
                                                                Not assigned
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>${r.requestDate}</td>
                                                <td class="description-cell">
                                                    <div class="description-content" title="${r.description}">
                                                        ${r.description}
                                                    </div>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${r.isResolved}">
                                                            <span class="status-badge status-done">
                                                                <i class="fas fa-check-circle me-1"></i>
                                                                Completed
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge status-pending">
                                                                <i class="fas fa-clock me-1"></i>
                                                                In Progress
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${r.resolutionDate != null}">
                                                            ${r.resolutionDate}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">Pending</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

    </body>
</html>
