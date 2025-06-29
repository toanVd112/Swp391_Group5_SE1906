<%-- 
    Document   : error
    Created on : Jun 30, 2025, 6:35:03 AM
    Author     : AD
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Customer/profile.css">
    <style>
        .error-container {
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        .error-message {
            color: #d32f2f;
            font-size: 1.2em;
            margin-bottom: 20px;
        }
        .btn-back {
            display: inline-flex;
            align-items: center;
            padding: 10px 20px;
            background: linear-gradient(90deg, #667eea, #764ba2);
            color: #fff;
            text-decoration: none;
            border-radius: 5px;
            transition: background 0.3s;
        }
        .btn-back:hover {
            background: linear-gradient(90deg, #764ba2, #667eea);
        }
        .btn-back .icon {
            width: 20px;
            height: 20px;
            margin-right: 8px;
            fill: #fff;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <h1>ERROR!</h1>
        <p class="error-message">${'An unknown error occurred. Please try again.!'}</p>
        <a href="${pageContext.request.contextPath}/profile" class="btn-back">
            <svg class="icon" viewBox="0 0 24 24">
                <path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z"/>
            </svg>
            Back to profile
        </a>
    </div>
</body>
</html>
