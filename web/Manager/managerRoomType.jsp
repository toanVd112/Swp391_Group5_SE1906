<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm mới Loại Phòng</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            color: #333;
            margin: 0;
            padding: 30px;
        }

        .card {
            background: #fff;
            border-radius: 8px;
            padding: 30px;
            max-width: 900px;
            margin: auto;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        h2 {
            font-size: 24px;
            margin-bottom: 20px;
            color: #1e293b;
            font-weight: 600;
        }

        .tabs {
            display: flex;
            border-bottom: 1px solid #ddd;
            margin-bottom: 20px;
        }

        .tab {
            padding: 10px 20px;
            cursor: pointer;
            background: #f1f5f9;
            border: none;
            font-weight: bold;
            color: #333;
        }

        .tab.active {
            background: #1d4ed8;
            color: white;
            border-radius: 6px 6px 0 0;
        }

        .tab-content {
            display: none;
        }

        .tab-content.active {
            display: block;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 6px;
            font-weight: 600;
        }

        input[type="text"],
        input[type="number"],
        textarea,
        input[type="file"] {
            width: 100%;
            padding: 10px;
            border-radius: 4px;
            border: 1px solid #ccc;
            font-size: 14px;
        }

        textarea {
            resize: vertical;
        }

        .checkbox-group {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
        }

        .submit-btn {
            background-color: #2563eb;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
        }

        .submit-btn:hover {
            background-color: #1d4ed8;
        }

        .image-preview {
            margin-top: 15px;
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .image-preview img {
            width: 120px;
            height: 80px;
            object-fit: cover;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
    </style>
</head>
<body>
<div class="card">
    <h2>${roomType != null ? "Cập nhật Loại Phòng" : "Thêm mới Loại Phòng"}</h2>
    <div class="tabs">
        <button type="button" class="tab active" data-tab="details">Details</button>
        <button type="button" class="tab" data-tab="images">Images</button>
    </div>
    <form method="post" action="${pageContext.request.contextPath}/ManageRoomType" enctype="multipart/form-data">
        <c:if test="${not empty roomType}">
            <input type="hidden" name="roomTypeID" value="${roomType.roomTypeID}" />
        </c:if>

        <div class="tab-content active" id="tab-details">
            <div class="form-group">
                <label for="name">Tên loại phòng</label>
                <input type="text" id="name" name="name" value="${roomType.name}" required>
            </div>

            <div class="form-group">
                <label for="description">Mô tả</label>
                <textarea id="description" name="description" rows="3">${roomType.description}</textarea>
            </div>

            <div class="form-group">
                <label for="basePrice">Giá cơ bản</label>
                <input type="number" step="0.01" id="basePrice" name="basePrice" value="${roomType.basePrice}" required>
            </div>

            <div class="form-group">
                <label for="roomDetail">Chi tiết loại phòng</label>
                <textarea id="roomDetail" name="roomDetail" rows="4">${roomType.roomDetail}</textarea>
            </div>

            <div class="form-group">
                <label>Tiện ích</label>
                <div class="checkbox-group">
                    <label><input type="checkbox" name="amenities" value="tv" <c:if test="${roomType.hasAmenity('tv')}">checked</c:if>> TV</label>
                    <label><input type="checkbox" name="amenities" value="wifi" <c:if test="${roomType.hasAmenity('wifi')}">checked</c:if>> Wi-Fi</label>
                    <label><input type="checkbox" name="amenities" value="airConditioner" <c:if test="${roomType.hasAmenity('airConditioner')}">checked</c:if>> Điều hòa</label>
                    <label><input type="checkbox" name="amenities" value="balcony" <c:if test="${roomType.hasAmenity('balcony')}">checked</c:if>> Ban công</label>
                    <label><input type="checkbox" name="amenities" value="minibar" <c:if test="${roomType.hasAmenity('minibar')}">checked</c:if>> Mini Bar</label>
                </div>
            </div>
        </div>

        <div class="tab-content" id="tab-images">
            <div class="form-group">
                <label for="roomImages">Ảnh loại phòng (có thể chọn nhiều ảnh)</label>
                <input type="file" id="roomImages" name="roomImages" accept="image/*" multiple>
                <div id="imagePreview" class="image-preview"></div>
            </div>
        </div>

        <button type="submit" class="submit-btn">Lưu</button>
    </form>
</div>

<script>
    const tabs = document.querySelectorAll('.tab');
    const contents = document.querySelectorAll('.tab-content');

    tabs.forEach(tab => {
        tab.addEventListener('click', () => {
            tabs.forEach(t => t.classList.remove('active'));
            contents.forEach(c => c.classList.remove('active'));

            tab.classList.add('active');
            document.getElementById('tab-' + tab.dataset.tab).classList.add('active');
        });
    });

    const imageInput = document.getElementById('roomImages');
    const previewContainer = document.getElementById('imagePreview');

    imageInput.addEventListener('change', () => {
        previewContainer.innerHTML = '';
        [...imageInput.files].forEach(file => {
            if (file.type.startsWith('image/')) {
                const reader = new FileReader();
                reader.onload = e => {
                    const img = document.createElement('img');
                    img.src = e.target.result;
                    previewContainer.appendChild(img);
                };
                reader.readAsDataURL(file);
            }
        });
    });
</script>
</body>
</html>