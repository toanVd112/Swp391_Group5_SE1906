<%@page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link href="https://cdn.jsdelivr.net/npm/remixicon@2.5.0/fonts/remixicon.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

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
            .amenity-row {
                display: flex;
                align-items: center;
                gap: 8px;
                margin-bottom: 8px;
                flex-wrap: nowrap;
            }
            .amenity-row input[name="amenityNames[]"],
            .amenity-row input[name="amenityIcons[]"] {
                width: 150px;
                font-size: 13px;
                padding: 4px 8px;
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
                max-width: 50%;
            }
            .image-url-row select {
                max-width: 25%;
            }
            .image-url-row img {
                height: 120px;
                width: auto;
                max-width: 200px;
            }
            .badge-remove {
                cursor: pointer;
                margin-left: 5px;
                color: white;
            }
            .category-item {
                display: inline-flex !important;
                align-items: center;
                margin-bottom: 5px;
                margin-right: 5px;
                padding: 5px 10px;
                border: 1px solid #ccc;
                border-radius: 5px;
                background-color: #6c757d;
                color: white;
            }
            .table td {
                white-space: nowrap;
                text-overflow: ellipsis;
                overflow: hidden;
                max-width: 200px;
            }
            .error-message {
                color: red;
                font-size: 12px;
                margin-left: 5px;
                display: none;
            }
            .is-invalid {
                border-color: red !important;
            }
        </style>
    </head>
    <body class="bg-light" style="padding: 0;">
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
                    <form id="room-type-form" action="${roomType != null ? 'UpdateRoomType' : 'AddRoomType'}" method="post">
                        <c:if test="${roomType != null && roomType.roomTypeID != 0}">
                            <input type="hidden" name="roomTypeID" value="${roomType.roomTypeID}" />
                        </c:if>
                        <input type="hidden" name="description" id="descriptionHidden">
                        <input type="hidden" name="categorySync" id="categorySync">
                        <!-- Tab Chi tiết -->
                        <div id="details" class="tab-content">
                            <div class="form-group">
                                <c:if test="${not empty error}">
                                    <div class="alert alert-danger">${error}</div>
                                </c:if>
                                <label for="name">Tên loại phòng</label>
                                <input type="text" id="name" name="name" class="form-control" value="${roomType.name}" required />
                                <span class="error-message" id="name-error"></span>
                            </div>
                            <div class="form-group">
                                <label for="description">Mô tả</label>
                                <div class="editor-toolbar mb-2">
                                    <button type="button" data-cmd="bold" class="btn btn-light btn-sm"><b>B</b></button>
                                    <button type="button" data-cmd="italic" class="btn btn-light btn-sm"><i>I</i></button>
                                    <button type="button" data-cmd="underline" class="btn btn-light btn-sm"><u>U</u></button>
                                </div>
                                <div id="description" class="description-editor" contenteditable="true">${roomType.description}</div>
                                <span class="error-message" id="description-error"></span>
                            </div>
                            <div class="form-group">
                                <label for="basePrice">Giá cơ bản</label>
                                <input type="number" step="0.01" id="basePrice" name="basePrice" class="form-control" value="${roomType.basePrice}" required />
                                <span class="error-message" id="basePrice-error"></span>
                            </div>
                            <div class="form-group">
                                <label for="roomDetail">Chi tiết loại phòng</label>
                                <textarea id="roomDetail" name="roomDetail" class="form-control" rows="4">${roomType.roomDetail}</textarea>
                            </div>
                            <div class="form-group">
                                <label for="maxGuests">Số người tối đa</label>
                                <input type="number" id="maxGuests" name="maxGuests" class="form-control" value="${roomType.maxGuests}" required />
                                <span class="error-message" id="maxGuests-error"></span>
                            </div>
                            <div class="form-group">
                                <label>Tiện ích</label>
                                <div id="amenity-list">
                                    <c:forEach var="a" items="${roomType.amenities}">
                                        <div class="amenity-row">
                                            <input type="text" name="amenityNames[]" class="form-control" placeholder="Tên tiện ích" value="${a.amenityName}" />
                                            <input type="text" name="amenityIcons[]" class="form-control icon-input" placeholder="Icon (vd: ri-wifi-line)" value="${a.icon}" />
                                            <span class="amenity-preview"><i class="${a.icon}"></i></span>
                                            <button type="button" class="btn btn-danger btn-sm remove-amenity">×</button>
                                        </div>
                                    </c:forEach>
                                </div>
                                <button type="button" class="btn btn-outline-primary btn-sm" id="add-amenity">+ Thêm tiện ích</button>
                            </div>
                        </div>
                        <!-- Tab Hình ảnh -->
                        <div id="images" class="tab-content" style="display:none;">
                            <div class="form-group">
                                <label for="imageUrl">URL ảnh đại diện</label>
                                <input type="text" id="imageUrl" name="imageUrl" class="form-control" value="${roomType.imageUrl}" />
                                <span class="error-message" id="imageUrl-error"></span>
                                <img id="main-image-preview" src="${roomType.imageUrl}" class="image-preview" onerror="this.style.display='none'" />
                            </div>
                            <div class="form-group">
                                <label>Danh mục ảnh chi tiết</label>
                                <div id="category-list">
                                    <c:forEach var="cat" items="${roomType.categoryList}">
                                        <div class="d-inline-flex align-items-center mb-2 mr-2 px-2 py-1 border rounded bg-secondary text-white category-item">
                                            <input type="hidden" name="categoryList[]" value="${cat}">
                                            <span>${cat}</span>
                                            <button type="button" class="btn btn-sm btn-light ml-2 py-0 px-2 remove-category" data-cat="${cat}">×</button>
                                        </div>
                                    </c:forEach>
                                </div>
                                <div class="input-group mt-2">
                                    <input type="text" id="newCategory" class="form-control" placeholder="Tên danh mục mới">
                                    <div class="input-group-append">
                                        <button type="button" class="btn btn-outline-primary btn-sm" id="add-category">+ Thêm danh mục</button>
                                    </div>
                                </div>
                            </div>
                            <label>Ảnh chi tiết</label>
                            <div id="image-url-container">
                                <c:forEach var="image" items="${roomType.images}" varStatus="status">
                                    <div class="d-flex align-items-start mb-3 image-url-row" data-image-id="${image.imageID}">
                                        <input type="text" name="imageUrls[]" class="form-control image-url-input" value="${image.imageUrl}" />
                                        <select name="imageCategories${status.index}" class="form-control" multiple>
                                            <c:forEach var="cat" items="${roomType.categoryList}">
                                                <option value="${cat}" <c:if test="${fn:contains(image.categoriesAsString, cat)}">selected</c:if>>${cat}</option>
                                            </c:forEach>
                                        </select>
                                        <img src="${image.imageUrl}" class="image-preview" onerror="this.style.display='none'">
                                        <button type="button" class="btn btn-danger btn-sm ml-2 remove-url" data-image-id="${image.imageID}">×</button>
                                    </div>
                                </c:forEach>
                            </div>
                            <button type="button" id="add-url-btn" class="btn btn-outline-primary btn-sm mt-2">+ Thêm URL ảnh</button>
                        </div>
                        <button type="submit" class="btn btn-success mt-4">Lưu</button>
                    </form>
                </div>
            </div>
        </div>
        <script>
            document.addEventListener('DOMContentLoaded', () => {
                // Tab switching
                document.querySelectorAll('.tab-btn').forEach(btn => {
                    btn.addEventListener('click', () => {
                        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
                        btn.classList.add('active');
                        document.querySelectorAll('.tab-content').forEach(tc => tc.style.display = 'none');
                        document.getElementById(btn.dataset.tab).style.display = 'block';
                    });
                });

                // Form validate đơn giản (giữ UX tốt, không lặp xử lý server)
                function validateForm() {
                    let isValid = true;
                    let firstError = null;

                    const name = document.getElementById('name');
                    const basePrice = document.getElementById('basePrice');
                    const maxGuests = document.getElementById('maxGuests');
                    const description = document.getElementById('description');

                    document.querySelectorAll('.is-invalid').forEach(e => e.classList.remove('is-invalid'));
                    document.querySelectorAll('.error-message').forEach(e => {
                        e.style.display = 'none';
                        e.textContent = '';
                    });

                    if (!name.value.trim()) {
                        isValid = false;
                        name.classList.add('is-invalid');
                        document.getElementById('name-error').textContent = 'Không được để trống';
                        document.getElementById('name-error').style.display = 'block';
                        firstError = name;
                    }

                    if (!description.innerText.trim()) {
                        isValid = false;
                        description.classList.add('is-invalid');
                        document.getElementById('description-error').textContent = 'Không được để trống';
                        document.getElementById('description-error').style.display = 'block';
                        firstError = firstError || description;
                    }

                    if (!basePrice.value.trim() || parseFloat(basePrice.value) <= 0) {
                        isValid = false;
                        basePrice.classList.add('is-invalid');
                        document.getElementById('basePrice-error').textContent = 'Giá phải > 0';
                        document.getElementById('basePrice-error').style.display = 'block';
                        firstError = firstError || basePrice;
                    }

                    if (!maxGuests.value.trim() || parseInt(maxGuests.value) <= 0) {
                        isValid = false;
                        maxGuests.classList.add('is-invalid');
                        document.getElementById('maxGuests-error').textContent = 'Số người > 0';
                        document.getElementById('maxGuests-error').style.display = 'block';
                        firstError = firstError || maxGuests;
                    }

                    if (firstError) {
                        firstError.scrollIntoView({behavior: 'smooth'});
                        firstError.focus();
                    }
                    return isValid;
                }

                // Submit
                document.getElementById('room-type-form').addEventListener('submit', e => {
                    if (!validateForm()) {
                        e.preventDefault();
                        return;
                    }

                    // Đồng bộ contenteditable và danh mục
                    document.getElementById('descriptionHidden').value = document.getElementById('description').innerHTML;
                    const categories = [...document.querySelectorAll('input[name="categoryList[]"]')].map(el => el.value.trim());
                    document.getElementById('categorySync').value = categories.join(',');

                    // Đồng bộ name cho select danh mục ảnh
                    document.querySelectorAll('.image-url-row').forEach((row, i) => {
                        const select = row.querySelector('select');
                        if (select)
                            select.name = 'imageCategories' + i;
                    });
                });

                // Thêm tiện ích
                document.getElementById('add-amenity').addEventListener('click', () => {
                    const div = document.createElement('div');
                    div.className = 'amenity-row';
                    div.innerHTML = `
                    <input type="text" name="amenityNames[]" class="form-control" placeholder="Tên tiện ích" />
                    <input type="text" name="amenityIcons[]" class="form-control icon-input" placeholder="Icon" />
                    <span class="amenity-preview"><i></i></span>
                    <button type="button" class="btn btn-danger btn-sm remove-amenity">×</button>`;
                    div.querySelector('.remove-amenity').addEventListener('click', () => div.remove());
                    div.querySelector('.icon-input').addEventListener('input', e => {
                        div.querySelector('.amenity-preview i').className = e.target.value.trim();
                    });
                    document.getElementById('amenity-list').appendChild(div);
                });

                // Gỡ tiện ích
                document.querySelectorAll('.remove-amenity').forEach(btn => {
                    btn.addEventListener('click', () => btn.closest('.amenity-row')?.remove());
                });

                // Thêm danh mục
                document.getElementById('add-category').addEventListener('click', () => {
                    const input = document.getElementById('newCategory');
                    const newCat = input.value.trim();
                    if (!newCat)
                        return alert("Vui lòng nhập tên danh mục.");
                    const existing = Array.from(document.querySelectorAll('#category-list input[name="categoryList[]"]')).map(i => i.value.trim());
                    if (existing.includes(newCat))
                        return alert("Danh mục đã tồn tại.");

                    const div = document.createElement('div');
                    div.className = 'category-item d-inline-flex align-items-center mb-2 mr-2 px-2 py-1 border rounded bg-secondary text-white';
                    div.innerHTML = `
                    <input type="hidden" name="categoryList[]" value="${newCat}">
                    <span>${newCat}</span>
                    <button type="button" class="btn btn-sm btn-light ml-2 py-0 px-2 remove-category">×</button>`;
                    div.querySelector('.remove-category').addEventListener('click', () => {
                        div.remove();
                        updateAllCategorySelects();
                    });
                    document.getElementById('category-list').appendChild(div);
                    input.value = '';
                    updateAllCategorySelects();
                });

                function updateAllCategorySelects() {
                    const categories = Array.from(document.querySelectorAll('#category-list input[name="categoryList[]"]')).map(i => i.value.trim());
                    document.querySelectorAll('#image-url-container select').forEach(select => {
                        const selected = Array.from(select.selectedOptions).map(opt => opt.value);
                        select.innerHTML = '';
                        categories.forEach(cat => {
                            const option = document.createElement('option');
                            option.value = option.textContent = cat;
                            if (selected.includes(cat))
                                option.selected = true;
                            select.appendChild(option);
                        });
                    });
                }

                // Gắn preview ảnh đại diện
                const imageUrlInput = document.getElementById('imageUrl');
                const preview = document.getElementById('main-image-preview');
                if (imageUrlInput && preview) {
                    const updatePreview = () => {
                        const url = imageUrlInput.value.trim();
                        preview.src = url;
                        preview.style.display = url ? 'block' : 'none';
                    };
                    imageUrlInput.addEventListener('input', updatePreview);
                    updatePreview();
                }

                // Thêm ảnh chi tiết
                let imageCount = document.querySelectorAll('#image-url-container .image-url-row').length;
                document.getElementById('add-url-btn').addEventListener('click', () => {
                    const div = document.createElement('div');
                    div.className = 'd-flex align-items-start mb-3 image-url-row';
                    const selectName = 'imageCategories' + (imageCount++);
                    div.innerHTML = `
                    <input type="text" name="imageUrls[]" class="form-control image-url-input" />
                    <select name="${selectName}" class="form-control" multiple></select>
                    <img src="" class="image-preview" onerror="this.style.display='none'">
                    <button type="button" class="btn btn-danger btn-sm ml-2 remove-url">×</button>`;
                    div.querySelector('.image-url-input').addEventListener('input', e => {
                        const img = div.querySelector('img');
                        img.src = e.target.value;
                        img.style.display = e.target.value ? 'block' : 'none';
                    });
                    div.querySelector('.remove-url').addEventListener('click', () => div.remove());
                    document.getElementById('image-url-container').appendChild(div);
                    updateAllCategorySelects();
                });

                // Khởi tạo lại preview ảnh nếu có sẵn
                document.querySelectorAll('.image-url-input').forEach(input => {
                    const img = input.closest('.image-url-row').querySelector('img');
                    input.addEventListener('input', () => {
                        img.src = input.value;
                        img.style.display = input.value ? 'block' : 'none';
                    });
                });
            });
        </script>
    </body>
</html>