<%@page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Loại Phòng</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"/>
    <style>
        .editor-toolbar button { margin-right: 5px; }
        .description-editor { border: 1px solid #ced4da; padding: 10px; min-height: 200px; border-radius: .25rem; }
        .tab-btn.active { background-color: #007bff; color: white; }
        .tab-btn { border: none; padding: 10px 20px; margin-right: 5px; cursor: pointer; border-radius: 5px; background: #f0f0f0; }
        .image-url-row input { flex: 1; }
        .image-url-row img { width: 100px; height: 100px; object-fit: cover; margin-left: 10px; border-radius: 5px; }
    </style>
</head>
<body class="p-4 bg-light">
<div class="container">
    <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h5 class="mb-0">Thông tin loại phòng</h5>
            <div>
                <button class="tab-btn active" data-tab="details">Chi tiết</button>
                <button class="tab-btn" data-tab="images">Hình ảnh</button>
            </div>
        </div>
        <div class="card-body">
            <div id="details" class="tab-content active">
                <form id="room-type-form" action="ManageRoomType" method="post" novalidate>
                    <c:if test="${not empty roomType}">
                        <input type="hidden" name="roomTypeID" value="${roomType.roomTypeID}" />
                    </c:if>

                    <div class="form-group">
                        <label for="name">Tên loại phòng</label>
                        <input type="text" id="name" name="name" class="form-control" value="${roomType.name}" required />
                    </div>

                    <div class="form-group">
                        <label for="description">Mô tả</label>
                        <div class="editor-toolbar mb-2">
                            <button type="button" data-cmd="bold" class="btn btn-light btn-sm"><b>B</b></button>
                            <button type="button" data-cmd="italic" class="btn btn-light btn-sm"><i>I</i></button>
                            <button type="button" data-cmd="underline" class="btn btn-light btn-sm"><u>U</u></button>
                        </div>
                        <div id="description" class="description-editor" contenteditable="true">${roomType.description}</div>
                        <input type="hidden" name="description" id="descriptionHidden" />
                    </div>

                    <div class="form-group">
                        <label for="basePrice">Giá cơ bản</label>
                        <input type="number" id="basePrice" name="basePrice" step="0.01" class="form-control" value="${roomType.basePrice}" />
                    </div>

                    <div class="form-group">
                        <label for="roomDetail">Chi tiết loại phòng</label>
                        <textarea id="roomDetail" name="roomDetail" rows="4" class="form-control">${roomType.roomDetail}</textarea>
                    </div>

                    <div class="form-group">
                        <label for="imageUrl">URL ảnh đại diện</label>
                        <input type="text" id="imageUrl" name="imageUrl" class="form-control" value="${roomType.imageUrl}" />
                    </div>

                    <button type="submit" class="btn btn-success">Lưu</button>
                </form>
            </div>

            <div id="images" class="tab-content" style="display: none;">
                <label>Ảnh chi tiết (URL)</label>
                <div id="image-url-container">
                    <c:forEach var="image" items="${roomType.images}">
                        <div class="d-flex align-items-start mb-3 image-url-row">
                            <input type="text" name="imageUrls" class="form-control image-url-input" value="${image.imageUrl}" />
                            <img src="${image.imageUrl}" onerror="this.style.display='none'" />
                            <button type="button" class="btn btn-danger btn-sm ml-2 remove-url">×</button>
                        </div>
                    </c:forEach>
                </div>
                <button type="button" id="add-url-btn" class="btn btn-outline-primary btn-sm mt-2">+ Thêm URL ảnh</button>
            </div>
        </div>
    </div>
</div>

<script>
    const tabs = document.querySelectorAll('.tab-btn');
    const details = document.getElementById('details');
    const images = document.getElementById('images');
    tabs.forEach(tab => {
        tab.addEventListener('click', () => {
            tabs.forEach(t => t.classList.remove('active'));
            tab.classList.add('active');
            details.style.display = tab.dataset.tab === 'details' ? 'block' : 'none';
            images.style.display = tab.dataset.tab === 'images' ? 'block' : 'none';
        });
    });

    const editor = document.getElementById('description');
    document.querySelectorAll('.editor-toolbar button').forEach(btn => {
        btn.addEventListener('click', () => document.execCommand(btn.dataset.cmd, false));
    });

    document.getElementById('room-type-form').addEventListener('submit', () => {
        document.getElementById('descriptionHidden').value = editor.innerHTML;
    });

    // Image URL handling with preview
    function createImageRow(url = '') {
        const div = document.createElement('div');
        div.className = 'd-flex align-items-start mb-3 image-url-row';
        div.innerHTML = `
            <input type="text" name="imageUrls" class="form-control image-url-input" placeholder="https://..." value="${url}">
            <img src="${url}" onerror="this.style.display='none'" />
            <button type="button" class="btn btn-danger btn-sm ml-2 remove-url">×</button>
        `;

        div.querySelector('.remove-url').addEventListener('click', () => div.remove());
        const input = div.querySelector('.image-url-input');
        const img = div.querySelector('img');
        input.addEventListener('input', () => {
            img.src = input.value;
            img.style.display = input.value ? 'block' : 'none';
        });
        return div;
    }

    document.getElementById('add-url-btn').addEventListener('click', () => {
        document.getElementById('image-url-container').appendChild(createImageRow());
    });

    // Enable preview update for existing inputs
    document.querySelectorAll('.image-url-input').forEach(input => {
        input.addEventListener('input', () => {
            const img = input.parentElement.querySelector('img');
            img.src = input.value;
            img.style.display = input.value ? 'block' : 'none';
        });
    });
</script>
</body>
</html>