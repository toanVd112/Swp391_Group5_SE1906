<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="dashboard">
    <div class="page-header mb-4">
        <h1 class="h3 mb-0">Dashboard</h1>
        <p class="text-muted">Welcome to Hoang Nam Hotel Management System</p>
    </div>

    <!-- Statistics Cards -->
    <div class="row mb-4">
        <div class="col-lg-3 col-md-6 mb-3">
            <div class="stat-card">
                <div class="stat-card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="stat-title">Total Rooms</h6>
                            <h3 class="stat-number">124</h3>
                            <small class="text-success">+2 from last month</small>
                        </div>
                        <div class="stat-icon">
                            <i class="fas fa-hotel"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-3 col-md-6 mb-3">
            <div class="stat-card">
                <div class="stat-card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="stat-title">Active Guests</h6>
                            <h3 class="stat-number">89</h3>
                            <small class="text-success">+12% from last week</small>
                        </div>
                        <div class="stat-icon">
                            <i class="fas fa-users"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-3 col-md-6 mb-3">
            <div class="stat-card">
                <div class="stat-card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="stat-title">Bookings Today</h6>
                            <h3 class="stat-number">23</h3>
                            <small class="text-success">+5 from yesterday</small>
                        </div>
                        <div class="stat-icon">
                            <i class="fas fa-calendar"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-3 col-md-6 mb-3">
            <div class="stat-card">
                <div class="stat-card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="stat-title">Maintenance</h6>
                            <h3 class="stat-number">7</h3>
                            <small class="text-warning">Pending requests</small>
                        </div>
                        <div class="stat-icon">
                            <i class="fas fa-wrench"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Content Cards -->
    <div class="row">
        <div class="col-lg-6 mb-4">
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title mb-0">Recent Activities</h5>
                    <small class="text-muted">Latest updates from your hotel</small>
                </div>
                <div class="card-body">
                    <div class="activity-list">
                        <div class="activity-item">
                            <div class="activity-dot bg-primary"></div>
                            <div class="activity-content">
                                <p class="mb-1">Room 205 checked out</p>
                                <small class="text-muted">2 minutes ago</small>
                            </div>
                        </div>
                        <div class="activity-item">
                            <div class="activity-dot bg-success"></div>
                            <div class="activity-content">
                                <p class="mb-1">New booking received</p>
                                <small class="text-muted">15 minutes ago</small>
                            </div>
                        </div>
                        <div class="activity-item">
                            <div class="activity-dot bg-warning"></div>
                            <div class="activity-content">
                                <p class="mb-1">Maintenance request for Room 301</p>
                                <small class="text-muted">1 hour ago</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-6 mb-4">
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title mb-0">Quick Actions</h5>
                    <small class="text-muted">Frequently used functions</small>
                </div>
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-6">
                            <button class="btn btn-primary w-100 quick-action-btn">
                                <i class="fas fa-hotel mb-2"></i>
                                <br>Add Room
                            </button>
                        </div>
                        <div class="col-6">
                            <button class="btn btn-outline-primary w-100 quick-action-btn">
                                <i class="fas fa-users mb-2"></i>
                                <br>New Guest
                            </button>
                        </div>
                        <div class="col-6">
                            <button class="btn btn-outline-primary w-100 quick-action-btn">
                                <i class="fas fa-calendar mb-2"></i>
                                <br>Schedule
                            </button>
                        </div>
                        <div class="col-6">
                            <button class="btn btn-outline-primary w-100 quick-action-btn">
                                <i class="fas fa-cog mb-2"></i>
                                <br>Settings
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>