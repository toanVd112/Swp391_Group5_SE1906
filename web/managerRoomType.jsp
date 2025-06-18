<%-- 
    Document   : newjsp
    Created on : Jun 17, 2025, 8:47:59 PM
    Author     : Arcueid
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="Form for managing room types with details and images">
        <title>Room Type Form</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                background-color: #f5f5f5;
                color: #333;
                line-height: 1.6;
            }

            .header {
                background-color: white;
                padding: 15px 30px;
                border-bottom: 1px solid #e0e0e0;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .header h1 {
                font-size: 24px;
                font-weight: 500;
                color: #333;
            }

            .nav-items {
                display: flex;
                gap: 20px;
                align-items: center;
            }

            .nav-item {
                color: #666;
                text-decoration: none;
                font-size: 14px;
                display: flex;
                align-items: center;
                gap: 5px;
                transition: color 0.3s;
            }

            .nav-item:hover, .nav-item:focus {
                color: #0066cc;
                outline: none;
            }

            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 20px;
            }

            .form-container {
                background-color: white;
                border-radius: 8px;
                overflow: hidden;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .tabs {
                display: flex;
                border-bottom: 1px solid #e0e0e0;
            }

            .tab {
                padding: 15px 25px;
                background-color: #f8f9fa;
                border: none;
                cursor: pointer;
                font-size: 14px;
                color: #666;
                border-right: 1px solid #e0e0e0;
                transition: background-color 0.3s, color 0.3s;
            }

            .tab.active, .tab:hover, .tab:focus {
                background-color: #0066cc;
                color: white;
                outline: none;
            }

            .form-content, .images-content {
                padding: 30px;
                display: none;
            }

            .form-content.active, .images-content.active {
                display: block;
            }

            .form-group {
                margin-bottom: 25px;
            }

            .form-label {
                display: block;
                margin-bottom: 8px;
                font-weight: 500;
                color: #333;
                font-size: 14px;
            }

            .form-input {
                width: 100%;
                max-width: 500px;
                padding: 12px 15px;
                border: 2px solid #e0e0e0;
                border-radius: 4px;
                font-size: 14px;
                transition: border-color 0.3s;
            }

            .form-input:focus {
                outline: none;
                border-color: #0066cc;
            }

            .form-input.invalid, .description-textarea.invalid {
                border-color: #dc3545;
            }

            .error-message {
                color: #dc3545;
                font-size: 12px;
                margin-top: 5px;
                display: none;
            }

            .description-group {
                margin-bottom: 25px;
            }

            .editor-toolbar {
                background-color: #f8f9fa;
                border: 2px solid #e0e0e0;
                border-bottom: none;
                padding: 10px 15px;
                display: flex;
                gap: 10px;
                align-items: center;
            }

            .toolbar-btn {
                background: none;
                border: none;
                padding: 5px 8px;
                cursor: pointer;
                border-radius: 3px;
                color: #666;
                font-size: 14px;
                transition: background-color 0.3s;
            }

            .toolbar-btn:hover, .toolbar-btn:focus {
                background-color: #e9ecef;
                outline: none;
            }

            .description-textarea {
                width: 100%;
                height: 200px;
                padding: 15px;
                border: 2px solid #e0e0e0;
                border-top: none;
                border-radius: 0 0 4px 4px;
                font-size: 14px;
                font-family: inherit;
                resize: vertical;
            }

            .description-textarea:focus {
                outline: none;
                border-color: #0066cc;
            }

            .occupancy-row {
                display: flex;
                gap: 30px;
                margin-bottom: 25px;
            }

            .occupancy-group {
                flex: 1;
                max-width: 235px;
            }

            .amenities-group {
                margin-bottom: 25px;
            }

            .amenities-list {
                display: flex;
                gap: 30px;
                flex-wrap: wrap;
                margin-top: 10px;
            }

            .amenity-item {
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .amenity-checkbox {
                width: 18px;
                height: 18px;
                border: 2px solid #0066cc;
                background-color: white;
                cursor: pointer;
                position: relative;
            }

            .amenity-checkbox.checked {
                background-color: #0066cc;
            }

            .amenity-checkbox.checked::after {
                content: '✓';
                color: white;
                position: absolute;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                font-size: 12px;
                font-weight: bold;
            }

            .amenity-label {
                font-size: 14px;
                color: #333;
                cursor: pointer;
            }

            .save-btn {
                background-color: #0066cc;
                color: white;
                padding: 12px 30px;
                border: none;
                border-radius: 4px;
                font-size: 14px;
                font-weight: 500;
                cursor: pointer;
                margin-top: 20px;
                transition: background-color 0.3s;
            }

            .save-btn:hover, .save-btn:focus {
                background-color: #0052a3;
                outline: none;
            }

            .icon {
                width: 16px;
                height: 16px;
                fill: currentColor;
            }

            .image-upload {
                display: flex;
                flex-direction: column;
                gap: 15px;
            }

            .image-preview {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
                gap: 15px;
                margin-top: 20px;
            }

            .image-item {
                position: relative;
                border: 2px solid #e0e0e0;
                border-radius: 4px;
                overflow: hidden;
            }

            .image-item img {
                width: 100%;
                height: 150px;
                object-fit: cover;
            }

            .remove-image {
                position: absolute;
                top: 5px;
                right: 5px;
                background-color: rgba(0,0,0,0.7);
                color: white;
                border: none;
                border-radius: 50%;
                width: 24px;
                height: 24px;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .visually-hidden {
                position: absolute;
                width: 1px;
                height: 1px;
                padding: 0;
                margin: -1px;
                overflow: hidden;
                clip: rect(0, 0, 0, 0);
                border: 0;
            }
        </style>
    </head>
    <body>
        <header class="header">
            <h1>Room Type Form</h1>
            <nav class="nav-items" aria-label="Main navigation">
                <a href="#" class="nav-item" aria-label="Dashboard">
                    <span class="icon">🏠</span> Dashboard
                </a>
                <a href="#" class="nav-item" aria-current="page">Room Types</a>
                <a href="#" class="nav-item">Account</a>
            </nav>
        </header>

        <main class="container">
            <div class="form-container">
                <div class="tabs" role="tablist">
                    <button class="tab active" role="tab" aria-selected="true" aria-controls="details-panel" id="details-tab">Details</button>
                    <button class="tab" role="tab" aria-selected="false" aria-controls="images-panel" id="images-tab">Images</button>
                </div>

                <div id="details-panel" class="form-content active" role="tabpanel" aria-labelledby="details-tab">
                    <form id="room-type-form" action="ManageRomType" method="post" novalidate>
                        <c:if test="${not empty roomType}">
                            <input type="hidden" name="roomTypeID" value="${roomType.roomTypeID}" />
                        </c:if>

                        <div class="form-group">
                            <label class="form-label" for="name">Tên loại phòng</label>
                            <input type="text" class="form-input" id="name" name="name" required aria-describedby="name-error" value="${roomType.name}" />
                            <span id="name-error" class="error-message">Vui lòng nhập tên loại phòng</span>
                        </div>

                        <div class="description-group">
                            <label class="form-label" for="description">Mô tả</label>
                            <div class="editor-toolbar" role="toolbar"></div>
                            <div class="description-textarea" contenteditable="true" id="description" name="description" aria-label="Description editor">${roomType.description}</div>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="basePrice">Giá cơ bản</label>
                            <input type="number" step="0.01" class="form-input" id="basePrice" name="basePrice" min="0" required aria-describedby="basePrice-error" value="${roomType.basePrice}" />
                            <span id="basePrice-error" class="error-message">Vui lòng nhập giá hợp lệ</span>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="roomDetail">Chi tiết loại phòng</label>
                            <textarea id="roomDetail" name="roomDetail" class="form-input" rows="5" aria-describedby="roomDetail-error">${roomType.roomDetail}</textarea>
                            <span id="roomDetail-error" class="error-message">Vui lòng nhập chi tiết</span>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="imageUrl">Ảnh đại diện (URL)</label>
                            <input type="text" id="imageUrl" name="imageUrl" class="form-input" value="${roomType.imageUrl}" />
                        </div>

                        <div class="amenities-group">
                            <label class="form-label">Tiện ích</label>
                            <div class="amenities-list" role="group" aria-label="Amenities selection">
                                <div class="amenity-item">
                                    <input type="checkbox" id="tv" name="amenities" value="tv" class="visually-hidden" />
                                    <div class="amenity-checkbox" data-checkbox="tv" role="checkbox" aria-checked="false" tabindex="0"></div>
                                    <label class="amenity-label" for="tv">TV</label>
                                </div>
                                <div class="amenity-item">
                                    <input type="checkbox" id="wifi" name="amenities" value="wifi" class="visually-hidden" />
                                    <div class="amenity-checkbox" data-checkbox="wifi" role="checkbox" aria-checked="false" tabindex="0"></div>
                                    <label class="amenity-label" for="wifi">Wi-Fi</label>
                                </div>
                                <div class="amenity-item">
                                    <input type="checkbox" id="airConditioner" name="amenities" value="airConditioner" class="visually-hidden" />
                                    <div class="amenity-checkbox" data-checkbox="airConditioner" role="checkbox" aria-checked="false" tabindex="0"></div>
                                    <label class="amenity-label" for="airConditioner">Điều hòa</label>
                                </div>
                                <div class="amenity-item">
                                    <input type="checkbox" id="balcony" name="amenities" value="balcony" class="visually-hidden" />
                                    <div class="amenity-checkbox" data-checkbox="balcony" role="checkbox" aria-checked="false" tabindex="0"></div>
                                    <label class="amenity-label" for="balcony">Ban công</label>
                                </div>
                                <div class="amenity-item">
                                    <input type="checkbox" id="minibar" name="amenities" value="minibar" class="visually-hidden" />
                                    <div class="amenity-checkbox" data-checkbox="minibar" role="checkbox" aria-checked="false" tabindex="0"></div>
                                    <label class="amenity-label" for="minibar">Mini Bar</label>
                                </div>
                            </div>
                        </div>

                        <button type="submit" class="save-btn">Lưu</button>
                    </form>
                </div>

                <div id="images-panel" class="images-content" role="tabpanel" aria-labelledby="images-tab">
                    <div class="image-upload">
                        <label class="form-label" for="image-upload">Tải ảnh</label>
                        <input type="file" id="image-upload" accept="image/*" multiple class="form-input" aria-describedby="image-upload-error" />
                        <span id="image-upload-error" class="error-message">Vui lòng chọn ảnh hợp lệ</span>
                        <div id="image-preview" class="image-preview"></div>
                    </div>
                </div>
            </div>
        </main>
        <script>
            const tabs = document.querySelectorAll('.tab');
            const panels = document.querySelectorAll('[role="tabpanel"]');

            tabs.forEach(tab => {
                tab.addEventListener('click', () => {
                    tabs.forEach(t => {
                        t.classList.remove('active');
                        t.setAttribute('aria-selected', 'false');
                    });
                    tab.classList.add('active');
                    tab.setAttribute('aria-selected', 'true');

                    panels.forEach(panel => panel.classList.remove('active'));
                    document.getElementById(tab.getAttribute('aria-controls')).classList.add('active');
                });
            });

            // Form validation on save button click
            const form = document.getElementById('room-type-form');
            form.addEventListener('submit', e => {
                e.preventDefault();
                let isValid = true;
                let firstInvalidField = null;

                const fields = [
                    {element: document.getElementById('title'), errorId: 'title-error', type: 'input'},
                    {element: document.getElementById('slug'), errorId: 'slug-error', type: 'input'},
                    {element: document.getElementById('shortCode'), errorId: 'shortCode-error', type: 'input'},
                    {element: document.getElementById('description'), errorId: 'description-error', type: 'editor'},
                    {element: document.getElementById('baseOccupancy'), errorId: 'baseOccupancy-error', type: 'input'},
                    {element: document.getElementById('higherOccupancy'), errorId: 'higherOccupancy-error', type: 'input'},
                    {element: document.getElementById('basePrice'), errorId: 'basePrice-error', type: 'input'}
                ];

                fields.forEach(field => {
                    const {element, errorId, type} = field;
                    const error = document.getElementById(errorId);
                    let invalid = false;

                    if (type === 'editor') {
                        invalid = !element.textContent.trim();
                    } else {
                        invalid = !element.value.trim() || (element.pattern && !new RegExp(element.pattern).test(element.value));
                    }

                    if (invalid) {
                        element.classList.add('invalid');
                        error.style.display = 'block';
                        isValid = false;
                        if (!firstInvalidField) {
                            firstInvalidField = element;
                        }
                    } else {
                        element.classList.remove('invalid');
                        error.style.display = 'none';
                    }
                });

                if (isValid) {
                    const formData = new FormData(form);
                    formData.append('description', document.getElementById('description').innerHTML);
                    console.log('Form submitted:', Object.fromEntries(formData));
                    // Add actual submission logic here
                } else if (firstInvalidField) {
                    firstInvalidField.focus();
                }
            });

            // Rich text editor
            const editor = document.getElementById('description');
            const toolbarButtons = document.querySelectorAll('.toolbar-btn');

            toolbarButtons.forEach(button => {
                button.addEventListener('click', () => {
                    const command = button.dataset.command;
                    const value = button.dataset.value || null;

                    if (command === 'insertImage') {
                        const url = prompt('Enter image URL:');
                        if (url)
                            document.execCommand('insertImage', false, url);
                    } else if (command === 'createLink') {
                        const url = prompt('Enter link URL:');
                        if (url)
                            document.execCommand('createLink', false, url);
                    } else {
                        document.execCommand(command, false, value);
                    }
                    editor.focus();
                });
            });

            // Custom checkbox handling
            const checkboxes = document.querySelectorAll('.amenity-checkbox');
            checkboxes.forEach(checkbox => {
                const toggleCheckbox = () => {
                    const input = document.getElementById(checkbox.dataset.checkbox);
                    input.checked = !input.checked;
                    checkbox.classList.toggle('checked');
                    checkbox.setAttribute('aria-checked', input.checked.toString());
                };

                checkbox.addEventListener('click', toggleCheckbox);
                checkbox.addEventListener('keypress', e => {
                    if (e.key === 'Enter' || e.key === ' ') {
                        e.preventDefault();
                        toggleCheckbox();
                    }
                });
            });

            // Image upload handling
            const imageUpload = document.getElementById('image-upload');
            const imagePreview = document.getElementById('image-preview');
            const imageError = document.getElementById('image-upload-error');

            imageUpload.addEventListener('change', () => {
                imageError.style.display = 'none';
                const files = Array.from(imageUpload.files);

                if (files.every(file => file.type.startsWith('image/'))) {
                    files.forEach(file => {
                        const reader = new FileReader();
                        reader.onload = e => {
                            const div = document.createElement('div');
                            div.className = 'image-item';
                            div.innerHTML = `
                                <img src="${e.target.result}" alt="Uploaded image">
                                <button class="remove-image" aria-label="Remove image">×</button>
                            `;
                            imagePreview.appendChild(div);

                            div.querySelector('.remove-image').addEventListener('click', () => {
                                div.remove();
                            });
                        };
                        reader.readAsDataURL(file);
                    });
                } else {
                    imageError.style.display = 'block';
                }
            });

            // Initialize accessibility
            editor.addEventListener('input', () => {
                if (!editor.textContent.trim()) {
                    editor.classList.add('empty');
                } else {
                    editor.classList.remove('empty');
                }
            });
        </script>
    </body>
</html>
