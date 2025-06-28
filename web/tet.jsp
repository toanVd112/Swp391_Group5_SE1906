<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Gi? Phòng</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { font-family: Arial, sans-serif; margin: 2rem; }
        table { width: 100%; border-collapse: collapse; margin-bottom: 2rem; }
        th, td { border: 1px solid #ddd; padding: 12px; text-align: center; }
        th { background: #f4f4f4; }
        img { width: 80px; height: auto; }
        .actions { display: flex; justify-content: space-between; }
        .btn { padding: 10px 20px; border: none; background: #007bff; color: #fff; cursor: pointer; border-radius: 4px; text-decoration: none; }
        .btn-secondary { background: #6c757d; }
        .btn-danger { background: #dc3545; }
        .summary { text-align: right; margin-bottom: 1rem; }
    </style>
</head>
<body>
    <h1>? Gi? Phòng C?a B?n</h1>

    <table>
        <thead>
            <tr>
                <th>Hình ?nh</th>
                <th>Lo?i Phòng</th>
                <th>S?c Ch?a</th>
                <th>S? L??ng</th>
                <th>Giá/?êm</th>
                <th>T?ng</th>
                <th>Hành ??ng</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td><img src="https://via.placeholder.com/80" alt="Deluxe Room"></td>
                <td>Deluxe Room</td>
                <td>2 ng??i</td>
                <td><input type="number" value="2" min="1" style="width: 60px;"></td>
                <td>1.200.000?</td>
                <td>2.400.000?</td>
                <td><button class="btn btn-danger">Xóa</button></td>
            </tr>
            <tr>
                <td><img src="https://via.placeholder.com/80" alt="Superior Room"></td>
                <td>Superior Room</td>
                <td>3 ng??i</td>
                <td><input type="number" value="1" min="1" style="width: 60px;"></td>
                <td>1.400.000?</td>
                <td>1.400.000?</td>
                <td><button class="btn btn-danger">Xóa</button></td>
            </tr>
        </tbody>
    </table>

    <div class="summary">
        <p><strong>T?ng s?c ch?a:</strong> 7 ng??i</p>
        <p><strong>T?ng ti?n:</strong> 3.800.000?</p>
    </div>

    <div class="actions">
        <a href="#" class="btn btn-secondary">? Quay l?i ch?n phòng</a>
        <a href="#" class="btn">? Ti?n hành thanh toán</a>
    </div>
</body>
</html>
