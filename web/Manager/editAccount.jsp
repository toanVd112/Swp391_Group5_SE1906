<%-- 
    Document   : editAccount
    Created on : 28 thg 5, 2025
    Author     : MyPC
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Edit Account</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                padding: 20px;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .container {
                max-width: 500px;
                width: 100%;
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                border-radius: 20px;
                padding: 40px;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
                border: 1px solid rgba(255, 255, 255, 0.2);
            }

            .header {
                text-align: center;
                margin-bottom: 30px;
            }

            .header h2 {
                color: #2d3748;
                font-size: 28px;
                font-weight: 700;
                margin-bottom: 8px;
            }

            .header p {
                color: #718096;
                font-size: 14px;
                font-weight: 400;
            }

            .form-group {
                margin-bottom: 24px;
                position: relative;
            }

            .form-group label {
                display: block;
                margin-bottom: 8px;
                font-weight: 500;
                color: #4a5568;
                font-size: 14px;
                letter-spacing: 0.025em;
            }

            .input-wrapper {
                position: relative;
            }

            .form-group input,
            .form-group select {
                width: 100%;
                padding: 14px 16px;
                border: 2px solid #e2e8f0;
                border-radius: 12px;
                font-size: 16px;
                font-weight: 400;
                color: #2d3748;
                background: #ffffff;
                transition: all 0.3s ease;
                outline: none;
            }

            .form-group input:focus,
            .form-group select:focus {
                border-color: #667eea;
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
                transform: translateY(-1px);
            }

            .form-group input:hover,
            .form-group select:hover {
                border-color: #cbd5e0;
            }

            .form-group select {
                cursor: pointer;
                appearance: none;
                background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='m6 8 4 4 4-4'/%3e%3c/svg%3e");
                background-position: right 12px center;
                background-repeat: no-repeat;
                background-size: 16px;
                padding-right: 40px;
            }

            .alert {
                color: #e53e3e;
                background: linear-gradient(135deg, #fed7d7 0%, #feb2b2 100%);
                border: 1px solid #fc8181;
                padding: 10px 14px;
                border-radius: 8px;
                margin-top: 8px;
                font-size: 13px;
                font-weight: 500;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .alert::before {
                content: '\f071';
                font-family: 'Font Awesome 6 Free';
                font-weight: 900;
                font-size: 12px;
            }

            .form-actions {
                display: flex;
                gap: 12px;
                margin-top: 32px;
            }

            .btn {
                flex: 1;
                padding: 14px 24px;
                border: none;
                border-radius: 12px;
                font-weight: 600;
                font-size: 16px;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                letter-spacing: 0.025em;
            }

            .btn-cancel {
                background: linear-gradient(135deg, #f7fafc 0%, #edf2f7 100%);
                color: #4a5568;
                border: 2px solid #e2e8f0;
            }

            .btn-cancel:hover {
                background: linear-gradient(135deg, #edf2f7 0%, #e2e8f0 100%);
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            }

            .btn-update {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border: 2px solid transparent;
            }

            .btn-update:hover {
                background: linear-gradient(135deg, #5a67d8 0%, #6b46c1 100%);
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
            }

            .btn-update:active,
            .btn-cancel:active {
                transform: translateY(0);
            }

            /* Role and Status badges */
            .form-group select[name="role"] option,
            .form-group select[name="isActive"] option {
                padding: 8px;
            }

            /* Loading state */
            .btn:disabled {
                opacity: 0.6;
                cursor: not-allowed;
                transform: none !important;
            }

            /* Responsive design */
            @media (max-width: 640px) {
                body {
                    padding: 16px;
                }

                .container {
                    padding: 24px;
                    border-radius: 16px;
                }

                .header h2 {
                    font-size: 24px;
                }

                .form-actions {
                    flex-direction: column;
                }

                .btn {
                    width: 100%;
                }
            }

            /* Animation for form appearance */
            .container {
                animation: slideUp 0.6s ease-out;
            }

            @keyframes slideUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Focus indicators for accessibility */
            .btn:focus-visible {
                outline: 2px solid #667eea;
                outline-offset: 2px;
            }

            /* Custom scrollbar for select dropdowns */
            select::-webkit-scrollbar {
                width: 8px;
            }

            select::-webkit-scrollbar-track {
                background: #f1f1f1;
                border-radius: 4px;
            }

            select::-webkit-scrollbar-thumb {
                background: #c1c1c1;
                border-radius: 4px;
            }

            select::-webkit-scrollbar-thumb:hover {
                background: #a8a8a8;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h2>Edit Account</h2>
                <p>Update account information and settings</p>
            </div>

            <form action="editAccount" method="post">
                <input type="hidden" name="aid" value="${account.accountID}" />

                <div class="form-group">
                    <label for="username">Username</label>
                    <div class="input-wrapper">
                        <input type="text" id="username" name="username" minlength="4" maxlength="20" pattern="^\S{4,20}$" value="${account.username}" required>
                    </div>
                    <c:if test="${not empty usernameError}">
                        <div class="alert">${usernameError}</div>
                    </c:if>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="input-wrapper">
                        <input type="password" id="password" name="password" minlength="4" maxlength="20" pattern="^\S{4,20}$" value="${account.password}" required>
                    </div>
                    <c:if test="${not empty passwordError}">
                        <div class="alert">${passwordError}</div>
                    </c:if>
                </div>

                <div class="form-group">
                    <label for="role">Role</label>
                    <select id="role" name="role" required>
                        <option value="Receptionist" ${account.role == 'Receptionist' ? 'selected' : ''}>Receptionist</option>
                        <option value="Staff" ${account.role == 'Staff' ? 'selected' : ''}>Staff</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="isActive">Account Status</label>
                    <select id="isActive" name="isActive" required>
                        <option value="true" ${account.isActive == true ? 'selected' : ''}>Active</option>
                        <option value="false" ${account.isActive == false ? 'selected' : ''}>Inactive</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <div class="input-wrapper">
                        <input type="email" id="email" name="email" maxlength="100" value="${account.email}" required>
                    </div>
                    <c:if test="${not empty emailError}">
                        <div class="alert">${emailError}</div>
                    </c:if>
                </div>

                <div class="form-actions">
                    <a href="managerAccount" class="btn btn-cancel">
                        <i class="fas fa-times"></i>
                        Cancel
                    </a>
                    <button type="submit" class="btn btn-update">
                        <i class="fas fa-save"></i>
                        Update Account
                    </button>
                </div>
            </form>
        </div>

        <script>
            const usernameInput = document.getElementById("username");
            const passwordInput = document.getElementById("password");

            // Ngăn không cho nhập khoảng trắng
            usernameInput.addEventListener('input', function () {
                this.value = this.value.replace(/\s+/g, '');
            });

            passwordInput.addEventListener('input', function () {
                this.value = this.value.replace(/\s+/g, '');
            });

            document.querySelector("form").addEventListener("submit", function (e) {
                let username = document.getElementById("username").value.trim();
                let password = document.getElementById("password").value.trim();
                let email = document.getElementById("email").value.trim();
                let emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

                // Add loading state to submit button
                const submitBtn = document.querySelector('.btn-update');

                if (username === "") {
                    alert("Username is required.");
                    e.preventDefault();
                    return;
                }

                if (password === "") {
                    alert("Password is required.");
                    e.preventDefault();
                    return;
                }

                if (email === "" || !emailRegex.test(email)) {
                    alert("Valid email is required.");
                    e.preventDefault();
                    return;
                }

                // Show loading state
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Updating...';
            });

            // Add smooth focus transitions
            document.querySelectorAll('input, select').forEach(element => {
                element.addEventListener('focus', function () {
                    this.parentElement.style.transform = 'scale(1.02)';
                });

                element.addEventListener('blur', function () {
                    this.parentElement.style.transform = 'scale(1)';
                });
            });
        </script>
    </body>
</html>