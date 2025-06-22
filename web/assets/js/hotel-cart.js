// Hiển thị danh sách phòng đã chọn từ localStorage
function renderCart() {
    const cartRaw = localStorage.getItem("roomCart");
    const cart = cartRaw ? JSON.parse(cartRaw) : [];
    const container = document.getElementById("selectedRoomsContainer");
    let totalPrice = 0;

    container.innerHTML = "";

    if (!Array.isArray(cart) || cart.length === 0) {
        container.innerHTML = "<p>⚠ Danh sách phòng trống.</p>";
        document.getElementById("totalRooms").textContent = "0";
        document.getElementById("totalPrice").textContent = "$0.00";
        return;
    }

    cart.forEach(room => {
        const roomNumber = room.roomNumber ?? 'N/A';
        const roomType = room.type ?? '';
        const roomFloor = room.floor ?? 'Không rõ';
        const roomPrice = typeof room.price === 'number' ? room.price.toFixed(2) : '0.00';
        const roomImage = room.image ? encodeURI(room.image) : 'assets/images/no-image.jpg';

        const roomDiv = document.createElement("div");
        roomDiv.className = "room-card";

        roomDiv.innerHTML = `
            <img src="${roomImage}" alt="Room Image" width="120" height="90">
            <div class="room-info">
                <h3>Phòng ${roomNumber}</h3>
                <p>Loại: ${roomType}</p>
                <p>Tầng: ${roomFloor}</p>
                <p>Giá/đêm: $${roomPrice}</p>
                <span class="remove-btn" onclick="removeRoom(${room.id})">
                    <i class="fa fa-trash"></i> Xoá phòng này
                </span>
            </div>
        `;

        container.appendChild(roomDiv);
        totalPrice += room.price || 0;
    });

    document.getElementById("totalRooms").textContent = cart.length;
    document.getElementById("totalPrice").textContent = `$${totalPrice.toFixed(2)}`;
}

// Xoá 1 phòng khỏi localStorage
function removeRoom(roomId) {
    let cart = JSON.parse(localStorage.getItem("roomCart")) || [];
    cart = cart.filter(r => r.id !== roomId);
    localStorage.setItem("roomCart", JSON.stringify(cart));
    renderCart();
}

// Xoá toàn bộ danh sách phòng
function clearRoomCart() {
    if (confirm("Bạn có chắc muốn xoá tất cả phòng đã chọn không?")) {
        localStorage.removeItem("roomCart");
        renderCart();
    }
}

// Thêm phòng từ button HTML có data-attribute
function addRoomFromElement(button) {
    const room = {
        id: parseInt(button.getAttribute("data-id")),
        roomNumber: button.getAttribute("data-roomnumber"),
        floor: parseInt(button.getAttribute("data-floor")),
        type: button.getAttribute("data-type") || '',           // đúng key
        price: parseFloat(button.getAttribute("data-price")),   // đúng key
        image: button.getAttribute("data-image") || ''
    };
    addRoomToCart(room);
}

// Thêm phòng vào localStorage
function addRoomToCart(room) {
    let cart = JSON.parse(localStorage.getItem("roomCart")) || [];

    if (!cart.some(r => r.id === room.id)) {
        cart.push(room);
        localStorage.setItem("roomCart", JSON.stringify(cart));
        updateRoomCount();

        Swal.fire({
            icon: 'success',
            title: 'Phòng đã được thêm!',
            text: 'Bạn có thể xem lại ở mục "My Rooms"',
            showCancelButton: true,
            confirmButtonText: 'Xem phòng đã chọn',
            cancelButtonText: 'Tiếp tục chọn phòng'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = 'myrooms.jsp';
            }
        });
    } else {
        Swal.fire({
            icon: 'info',
            title: 'Phòng này đã có trong danh sách',
            text: 'Bạn có thể chỉnh sửa trong "My Rooms"',
        });
    }
}

// Cập nhật hiển thị số lượng phòng đã chọn (giỏ)
function updateRoomCount() {
    const cart = JSON.parse(localStorage.getItem("roomCart")) || [];
    const badge = document.getElementById("roomCountBadge");
    if (badge) {
        badge.textContent = cart.length;
    }
}
