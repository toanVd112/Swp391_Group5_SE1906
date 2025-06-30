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
                max-width: 200px; /* hoặc phù hợp với giao diện */
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
                            </div>
                            <div class="form-group">
                                <label for="basePrice">Giá cơ bản</label>
                                <input type="number" step="0.01" id="basePrice" name="basePrice" class="form-control" value="${roomType.basePrice}" required />
                            </div>
                            <div class="form-group">
                                <label for="roomDetail">Chi tiết loại phòng</label>
                                <textarea id="roomDetail" name="roomDetail" class="form-control" rows="4">${roomType.roomDetail}</textarea>
                            </div>
                            <div class="form-group">
                                <label for="maxGuests">Số người tối đa</label>
                                <input type="number" id="maxGuests" name="maxGuests" class="form-control" value="${roomType.maxGuests}" />
                            </div>
                            <div class="form-group">
                                <label>Tiện ích</label>
                                <div id="amenity-list">
                                    <c:forEach var="a" items="${roomType.amenities}">
                                        <div class="d-flex align-items-center mb-2">
                                            <input type="text" name="amenityNames[]" class="form-control mr-2" placeholder="Tên tiện ích" value="${a.amenityName}" />
                                            <input type="text" name="amenityIcons[]" class="form-control mr-2" placeholder="Icon" value="${a.icon}" />
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
                console.log('DOM fully loaded');

                // Tab switching
                const tabs = document.querySelectorAll('.tab-btn');
                tabs.forEach(tab => {
                    tab.addEventListener('click', () => {
                        tabs.forEach(t => t.classList.remove('active'));
                        tab.classList.add('active');
                        document.querySelectorAll('.tab-content').forEach(tc => tc.style.display = 'none');
                        document.getElementById(tab.dataset.tab).style.display = 'block';
                    });
                });

                // Form submission handling
                // Form submission handling (fix sync imageUrls[] <-> imageCategoriesX)
                document.getElementById('room-type-form').addEventListener('submit', () => {
                    // Cập nhật mô tả ẩn
                    const editor = document.getElementById('description');
                    document.getElementById('descriptionHidden').value = editor ? editor.innerHTML : '';

                    // Đồng bộ danh mục (dạng ẩn)
                    const categories = Array.from(document.querySelectorAll('#category-list input[name="categoryList[]"]'))
                            .map(input => input.value.trim());
                    document.getElementById('categorySync').value = categories.join(',');

                    // Gán lại name="imageCategoriesX" theo đúng thứ tự imageUrls[]
                    document.querySelectorAll('#image-url-container .image-url-row').forEach((row, index) => {
                        const select = row.querySelector('select');
                        if (select) {
                            select.name = 'imageCategories' + index;
                        }
                    });
                });

                // Add amenity
                const addAmenityBtn = document.getElementById('add-amenity');
                if (addAmenityBtn) {
                    addAmenityBtn.addEventListener('click', () => {
                        const div = document.createElement('div');
                        div.className = 'd-flex align-items-center mb-2';
                        div.innerHTML = `<input type="text" name="amenityNames[]" class="form-control mr-2" placeholder="Tên tiện ích" />
                              <input type="text" name="amenityIcons[]" class="form-control mr-2" placeholder="Icon" />
                              <button type="button" class="btn btn-danger btn-sm remove-amenity">×</button>`;
                        div.querySelector('.remove-amenity').addEventListener('click', () => div.remove());
                        document.getElementById('amenity-list').appendChild(div);
                    });
                } else {
                    console.error('Element #add-amenity not found!');
                }

                // Add category
                const addCategoryBtn = document.getElementById('add-category');
                if (addCategoryBtn) {
                    addCategoryBtn.addEventListener('click', () => {
                        const input = document.getElementById('newCategory');
                        const newCat = input.value.trim();
                        console.log('Creating category:', newCat);

                        if (!newCat) {
                            alert("Vui lòng nhập tên danh mục.");
                            return;
                        }

                        const categories = Array.from(document.querySelectorAll('#category-list input[name="categoryList[]"]'))
                                .map(el => el.value.trim());

                        if (categories.includes(newCat)) {
                            alert("Danh mục đã tồn tại.");
                            return;
                        }

                        const div = document.createElement('div');
                        div.className = 'd-inline-flex align-items-center mb-2 mr-2 px-2 py-1 border rounded bg-secondary text-white category-item';

                        const hidden = document.createElement('input');
                        hidden.type = 'hidden';
                        hidden.name = 'categoryList[]';
                        hidden.value = newCat;

                        const span = document.createElement('span');
                        span.textContent = newCat;

                        const button = document.createElement('button');
                        button.type = 'button';
                        button.className = 'btn btn-sm btn-light ml-2 py-0 px-2 remove-category';
                        button.dataset.cat = newCat;
                        button.textContent = '×';

                        div.appendChild(hidden);
                        div.appendChild(span);
                        div.appendChild(button);

                        const categoryList = document.getElementById('category-list');
                        if (categoryList) {
                            categoryList.appendChild(div);
                            input.value = '';
                            updateAllCategorySelects();
                            console.log('Added category safely:', newCat);
                        } else {
                            console.error('Element #category-list not found!');
                        }
                    });
                } else {
                    console.error('Element #add-category not found!');
                }

                // Remove category (event delegation)
                const categoryList = document.getElementById('category-list');
                if (categoryList) {
                    categoryList.addEventListener('click', (e) => {
                        if (e.target.classList.contains('remove-category')) {
                            const item = e.target.closest('.category-item');
                            if (item) {
                                item.remove();
                                updateAllCategorySelects();
                                console.log('Removed category:', e.target.getAttribute('data-cat'));
                            }
                        }
                    });
                } else {
                    console.error('Element #category-list not found!');
                }

                // Update all category selects
                function updateAllCategorySelects() {
                    const allCategories = Array.from(document.querySelectorAll('#category-list input[name="categoryList[]"]'))
                            .map(input => input.value.trim());
                    document.querySelectorAll('#image-url-container select').forEach(select => {
                        const oldValues = Array.from(select.selectedOptions).map(opt => opt.value);
                        select.innerHTML = '';
                        allCategories.forEach(cat => {
                            const option = document.createElement('option');
                            option.value = option.textContent = cat;
                            if (oldValues.includes(cat)) {
                                option.selected = true;
                            }
                            select.appendChild(option);
                        });
                    });
                }
                const mainImageInput = document.getElementById('imageUrl');
                const mainImagePreview = document.getElementById('main-image-preview');

                if (mainImageInput && mainImagePreview) {
                    // Preview nếu người dùng thay đổi URL
                    mainImageInput.addEventListener('input', () => {
                        const url = mainImageInput.value.trim();
                        mainImagePreview.src = url;
                        mainImagePreview.style.display = url ? 'block' : 'none';
                    });

                    // Nếu đã có sẵn ảnh thì hiển thị luôn
                    if (mainImageInput.value.trim()) {
                        mainImagePreview.src = mainImageInput.value.trim();
                        mainImagePreview.style.display = 'block';
                    } else {
                        mainImagePreview.style.display = 'none';
                    }
                }
                // Add image URL
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
                    const input = div.querySelector('input');
                    const img = div.querySelector('img');
                    input.addEventListener('input', () => {
                        img.src = input.value;
                        img.style.display = input.value ? 'block' : 'none';
                    });
                    div.querySelector('.remove-url').addEventListener('click', () => {
                        div.remove();
                        updateAllCategorySelects();
                    });
                    document.getElementById('image-url-container').appendChild(div);
                    updateAllCategorySelects();
                });

                // Remove image URL (event delegation)
                document.getElementById('image-url-container').addEventListener('click', (e) => {
                    if (e.target.classList.contains('remove-url')) {
                        const row = e.target.closest('.image-url-row');
                        if (row) {
                            row.remove();
                            updateAllCategorySelects();
                        }
                    }
                });

                // Initialize existing image URL inputs for preview
                document.querySelectorAll('#image-url-container .image-url-input').forEach(input => {
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