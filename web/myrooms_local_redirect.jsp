<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đang xử lý My Rooms...</title>

    <script>
        function sendRoomCartToServerAndRedirect() {
            const cart = JSON.parse(localStorage.getItem("roomCart")) || [];

            if (cart.length === 0) {
                alert("Chưa có phòng nào trong giỏ.");
                window.location.href = "rooms.jsp";
                return;
            }

            fetch("myrooms", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(cart)
            })
            .then(response => {
                if (response.redirected) {
                    window.location.href = response.url;
                } else {
                    window.location.href = "myrooms_db.jsp";
                }
            })
            .catch(err => {
                console.error("❌ Lỗi khi gửi phòng:", err);
                alert("Không thể gửi dữ liệu giỏ phòng.");
                window.location.href = "rooms.jsp";
            });
        }

        document.addEventListener("DOMContentLoaded", function () {
            sendRoomCartToServerAndRedirect();
        });
    </script>

    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 40px;
            text-align: center;
        }
    </style>
</head>
<body>
    <h2>🔄 Đang xử lý dữ liệu phòng của bạn...</h2>
    <p>Vui lòng chờ trong giây lát...</p>
</body>
</html>
