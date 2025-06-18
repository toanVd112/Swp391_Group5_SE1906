<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="DAO.RoomInspectionReportDAO" %>
<%@ page import="java.sql.SQLException" %>

<%
    RoomInspectionReportDAO dao = new RoomInspectionReportDAO();
%>

<div class="room-inspection-page">
    <div class="inspection-container">
        <!-- Page Header -->
        <div class="page-header">
            <h1 class="page-title">
                <i class="fas fa-clipboard-check me-2"></i>
                Room Inspection Management
            </h1>
            <p class="page-subtitle">Manage room inspection requests and reports</p>
        </div>

        <!-- Add New Inspection Request -->
        <div class="inspection-form-section">
            <div class="section-header">
                <h2 class="section-title">
                    <i class="fas fa-plus-circle me-2"></i>
                    Add New Inspection Request
                </h2>
            </div>

            <div class="form-card">
                <form action="${pageContext.request.contextPath}/roomInspection" method="post" class="inspection-form">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="bookingId" class="form-label">
                                <i class="fas fa-calendar-alt me-1"></i>
                                Booking ID
                            </label>
                            <input type="number" id="bookingId" name="bookingId" class="form-control" required>
                        </div>

                        <div class="form-group">
                            <label for="roomId" class="form-label">
                                <i class="fas fa-door-open me-1"></i>
                                Room ID
                            </label>
                            <input type="number" id="roomId" name="roomId" class="form-control" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="staffId" class="form-label">
                                <i class="fas fa-user-tie me-1"></i>
                                Select Inspector
                            </label>
                            <select id="staffId" name="staffId" class="form-control" required>
                                <option value="">Choose inspector...</option>
                                <c:forEach var="staff" items="${staffList}">
                                    <option value="${staff.accountID}">${staff.username}</option>
                                </c:forEach>
                            </select>
                            <c:if test="${not empty catchError}">
                                <div class="error-message">
                                    <i class="fas fa-exclamation-triangle me-1"></i>
                                    Error loading staff list: ${catchError}
                                </div>
                            </c:if>
                        </div>

                        <div class="form-group">
                            <label for="notes" class="form-label">
                                <i class="fas fa-sticky-note me-1"></i>
                                Notes
                            </label>
                            <input type="text" id="notes" name="notes" class="form-control" 
                                   placeholder="Enter inspection notes..." required>
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-paper-plane me-1"></i>
                            Submit Request
                        </button>
                        <button type="reset" class="btn btn-secondary">
                            <i class="fas fa-undo me-1"></i>
                            Reset Form
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Inspection Reports List -->
        <div class="inspection-list-section">
            <div class="section-header">
                <h2 class="section-title">
                    <i class="fas fa-list-alt me-2"></i>
                    Inspection Reports
                </h2>
                <div class="section-actions">
                    <button class="btn btn-outline-primary btn-sm" onclick="refreshTable()">
                        <i class="fas fa-sync-alt me-1"></i>
                        Refresh
                    </button>
                </div>
            </div>

            <div class="table-card">
                <div class="table-responsive">
                    <table class="inspection-table">
                        <thead>
                            <tr>
                                <th><i class="fas fa-hashtag me-1"></i>Report ID</th>
                                <th><i class="fas fa-calendar me-1"></i>Booking ID</th>
                                <th><i class="fas fa-door-open me-1"></i>Room ID</th>
                                <th><i class="fas fa-clock me-1"></i>Inspection Time</th>
                                <th><i class="fas fa-user me-1"></i>Inspector</th>
                                <th><i class="fas fa-check-circle me-1"></i>Status</th>
                                <th><i class="fas fa-comment me-1"></i>Notes</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="report" items="${reports}">
                                <tr>
                                    <td class="report-id">#${report.reportID}</td>
                                    <td>${report.bookingID}</td>
                                    <td>
                                        <span class="room-badge">Room ${report.roomID}</span>
                                    </td>
                                    <td class="inspection-time">
                                        <c:choose>
                                            <c:when test="${not empty report.inspectionTime}">
                                                ${report.inspectionTime}
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">Not scheduled</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="staff-info">
                                        <c:choose>
                                            <c:when test="${not empty report.staffID}">
                                                <div class="staff-assigned">
                                                    <i class="fas fa-user-check text-success me-1"></i>
                                                    <strong>${staffMap[report.staffID]}</strong>
                                                    <small class="text-muted d-block">ID: ${report.staffID}</small>
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
                                    <td>
                                        <c:choose>
                                            <c:when test="${report.isRoomOk == true}">
                                                <span class="status-badge status-ok">
                                                    <i class="fas fa-check-circle me-1"></i>
                                                    OK
                                                </span>
                                            </c:when>
                                            <c:when test="${report.isRoomOk == false}">
                                                <span class="status-badge status-not-ok">
                                                    <i class="fas fa-times-circle me-1"></i>
                                                    Not OK
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge status-pending">
                                                    <i class="fas fa-clock me-1"></i>
                                                    Pending
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="notes-cell">
                                        <c:choose>
                                            <c:when test="${not empty report.notes}">
                                                <div class="notes-content" title="${report.notes}">
                                                    ${report.notes}
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">No notes</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty reports}">
                                <tr>
                                    <td colspan="7" class="empty-state">
                                        <div class="empty-content">
                                            <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                            <h5 class="text-muted">No inspection requests found</h5>
                                            <p class="text-muted">Create your first inspection request above</p>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Error Messages -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-triangle me-2"></i>
                <strong>Error:</strong> ${error}
            </div>
        </c:if>
    </div>
</div>

<style>
    /* Room Inspection Page Styles */
    .room-inspection-page {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    .inspection-container {
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

    .section-actions {
        display: flex;
        gap: 0.5rem;
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

    .inspection-form {
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

    .btn-secondary {
        background-color: #6c757d;
        color: white;
    }

    .btn-secondary:hover {
        background-color: #545b62;
    }

    .btn-outline-primary {
        background-color: transparent;
        color: #007bff;
        border: 2px solid #007bff;
    }

    .btn-outline-primary:hover {
        background-color: #007bff;
        color: white;
    }

    .btn-sm {
        padding: 0.5rem 1rem;
        font-size: 0.875rem;
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

    .inspection-table {
        width: 100%;
        border-collapse: collapse;
        margin: 0;
    }

    .inspection-table thead {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
    }

    .inspection-table th {
        padding: 1rem;
        text-align: left;
        font-weight: 600;
        font-size: 0.9rem;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .inspection-table td {
        padding: 1rem;
        border-bottom: 1px solid #e9ecef;
        vertical-align: middle;
    }

    .inspection-table tbody tr:hover {
        background-color: #f8f9fa;
    }

    .inspection-table tbody tr:last-child td {
        border-bottom: none;
    }

    /* Table Content Styles */
    .report-id {
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

    .inspection-time {
        font-family: 'Courier New', monospace;
        font-size: 0.9rem;
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

    .status-ok {
        background-color: #d4edda;
        color: #155724;
        border: 1px solid #c3e6cb;
    }

    .status-not-ok {
        background-color: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
    }

    .status-pending {
        background-color: #fff3cd;
        color: #856404;
        border: 1px solid #ffeaa7;
    }

    .notes-cell {
        max-width: 200px;
    }

    .notes-content {
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

    /* Alert Styles */
    .alert {
        padding: 1rem 1.5rem;
        border-radius: 8px;
        margin-top: 1rem;
        display: flex;
        align-items: center;
    }

    .alert-danger {
        background-color: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
    }

    .error-message {
        color: #dc3545;
        font-size: 0.875rem;
        margin-top: 0.25rem;
        display: flex;
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

        .inspection-table {
            font-size: 0.875rem;
        }

        .inspection-table th,
        .inspection-table td {
            padding: 0.75rem 0.5rem;
        }

        .notes-cell,
        .notes-content {
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

<script>
    function refreshTable() {
        window.location.reload();
    }

// Form validation
    document.addEventListener('DOMContentLoaded', function () {
        const form = document.querySelector('.inspection-form');
        if (form) {
            form.addEventListener('submit', function (e) {
                const bookingId = document.getElementById('bookingId').value;
                const roomId = document.getElementById('roomId').value;
                const staffId = document.getElementById('staffId').value;
                const notes = document.getElementById('notes').value;

                if (!bookingId || !roomId || !staffId || !notes.trim()) {
                    e.preventDefault();
                    alert('Please fill in all required fields.');
                    return false;
                }

                if (bookingId <= 0 || roomId <= 0) {
                    e.preventDefault();
                    alert('Booking ID and Room ID must be positive numbers.');
                    return false;
                }
            });
        }
    });
</script>