<%@page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý Loại Phòng</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"/>
        <style>
            .editor-toolbar button {
                margin-right: 5px;
            }
            .description-editor {
                border: 1px solid #ced4da;
                padding: 10px;
                min-height: 200px;
                border-radius: .25rem;
            }
            .tab-btn.active {
                background-color: #007bff;
                color: white;
            }
            .tab-btn {
                border: none;
                padding: 10px 20px;
                margin-right: 5px;
                cursor: pointer;
                border-radius: 5px;
                background: #f0f0f0;
            }
            .image-url-row {
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .image-url-row input {
                flex: 1;
                max-width: 80%;
            }
            .image-url-row img {
                height: 120px;
                width: auto;
                max-width: 200px;
            }
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
                    <form id="room-type-form" action="ManageRoomType" method="post" novalidate>
                        <c:if test="${not empty roomType}">
                            <input type="hidden" name="roomTypeID" value="${roomType.roomTypeID}" />
                        </c:if>

                        <!-- TAB CHI TIẾT -->
                        <div id="details" class="tab-content active">
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

                            <!-- Tiện ích -->
                            <div class="form-group mt-4">
                                <label>Tiện ích (Amenity)</label>
                                <div id="amenity-list">
                                    <c:forEach var="a" items="${roomType.amenities}">
                                        <div class="d-flex align-items-center mb-2 amenity-item" data-id="${a.amenityId}">
                                            <c:choose>
                                                <c:when test="${fn:startsWith(a.icon, 'http')}">
                                                    <img src="${a.icon}" alt="icon" style="width: 24px; height: 24px; margin-right: 8px;">
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="${a.icon}" style="font-size: 24px; margin-right: 8px;"></i>
                                                </c:otherwise>
                                            </c:choose>
                                            <span>${a.amenityName}</span>
                                            <button type="button" class="btn btn-sm btn-danger ml-2 delete-amenity" data-id="${a.amenityId}">×</button>
                                        </div>
                                    </c:forEach>
                                </div>

                                <!-- Nút + khung nhập tiện ích mới -->
                                <button type="button" class="btn btn-outline-primary btn-sm" id="add-amenity-btn">+ Thêm tiện ích</button>
                                <div id="amenity-form" class="mt-2" style="display: none;">
                                    <input type="text" id="amenityName" class="form-control mb-2" placeholder="Tên tiện ích" />
                                    <input type="text" id="amenityIcon" class="form-control mb-2" placeholder="URL icon (VD: https://...png)" />
                                    <button type="button" class="btn btn-success btn-sm" id="save-amenity">Lưu tiện ích</button>
                                </div>
                            </div>
                        </div>

                        <!-- TAB HÌNH ẢNH -->
                        <div id="images" class="tab-content" style="display: none;">
                            <!-- Ảnh đại diện -->
                            <div class="form-group">
                                <label for="imageUrl">URL ảnh đại diện</label>
                                <input type="text" id="imageUrl" name="imageUrl" class="form-control" value="${roomType.imageUrl}" />
                                <img id="main-image-preview" src="${roomType.imageUrl}" class="image-preview" onerror="this.style.display='none'" />
                            </div>

                            <!-- Ảnh chi tiết -->
                            <label>Ảnh chi tiết (URL)</label>
                            <div id="image-url-container">
                                <c:forEach var="image" items="${roomType.images}">
                                    <div class="d-flex align-items-start mb-3 image-url-row">
                                        <input type="text" name="imageUrls[]" class="form-control image-url-input" value="${image.imageUrl}" />
                                        <img src="${image.imageUrl}" onerror="this.style.display='none'" />
                                        <button type="button" class="btn btn-danger btn-sm ml-2 remove-url" data-imageid="${image.imageID}">×</button>
                                    </div>
                                </c:forEach>
                            </div>
                            <button type="button" id="add-url-btn" class="btn btn-outline-primary btn-sm mt-2">+ Thêm URL ảnh</button>
                        </div>

                        <div class="mt-4 text-right">
                            <button type="submit" class="btn btn-success">Lưu</button>
                        </div>
                    </form>
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

            const mainInput = document.getElementById('imageUrl');
            const mainPreview = document.getElementById('main-image-preview');
            if (!mainInput.value.trim()) {
                mainPreview.style.display = 'none';
            }
            mainInput.addEventListener('input', () => {
                mainPreview.src = mainInput.value;
                mainPreview.style.display = mainInput.value ? 'block' : 'none';
            });

            function createImageRow(url = '') {
                const div = document.createElement('div');
                div.className = 'd-flex align-items-start mb-3 image-url-row';
                div.innerHTML = `
                    <input type="text" name="imageUrls[]" class="form-control image-url-input" placeholder="https://..." value="${url}">
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

            document.querySelectorAll('.image-url-input').forEach(input => {
                input.addEventListener('input', () => {
                    const img = input.parentElement.querySelector('img');
                    img.src = input.value;
                    img.style.display = input.value ? 'block' : 'none';
                });
            });

            document.querySelectorAll('.remove-url').forEach(btn => {
                btn.addEventListener('click', () => {
                    const imageId = btn.getAttribute('data-imageid');
                    const row = btn.closest('.image-url-row');

                    if (!imageId || isNaN(imageId) || Number(imageId) <= 0) {
                        row.remove();
                        return;
                    }

                    fetch('ManageRoomType', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                        body: new URLSearchParams({deleteImageId: imageId})
                    })
                            .then(res => res.ok ? row.remove() : alert('Xóa ảnh thất bại'))
                            .catch(() => alert('Không thể kết nối server để xóa ảnh'));
                });
            });

            document.getElementById('add-amenity-btn').addEventListener('click', () => {
                document.getElementById('amenity-form').style.display = 'block';
            });

            document.getElementById('save-amenity').addEventListener('click', () => {
                const name = document.getElementById('amenityName').value.trim();
                const icon = document.getElementById('amenityIcon').value.trim();
                const roomTypeID = document.querySelector('input[name="roomTypeID"]').value;

                if (!name || !icon) {
                    alert('Vui lòng nhập tên và icon');
                    return;
                }

                const formData = new URLSearchParams();
                formData.append('amenityAction', 'add');
                formData.append('amenityName', name);
                formData.append('icon', icon);
                formData.append('roomTypeID', roomTypeID);

                fetch('ManageRoomType', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: formData.toString()
                })
                        .then(res => res.text())
                        .then(msg => {
                            alert(msg);
                            location.reload();
                        });
            });

            document.querySelectorAll('.delete-amenity').forEach(btn => {
                btn.addEventListener('click', () => {
                    const amenityId = btn.dataset.id;

                    const formData = new URLSearchParams();
                    formData.append('amenityAction', 'delete');
                    formData.append('amenityId', amenityId);

                    fetch('ManageRoomType', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                        body: formData.toString()
                    })
                            .then(res => res.text())
                            .then(msg => {
                                alert(msg);
                                btn.closest('.amenity-item').remove();
                            });
                });
            });
        </script>
    </body>
</html>
