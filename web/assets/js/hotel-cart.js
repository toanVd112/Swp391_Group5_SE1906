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

    // Lọc bỏ phòng có id trùng
    cart = cart.filter(r => parseInt(r.id) !== parseInt(roomId));

    // Cập nhật lại localStorage
    localStorage.setItem("roomCart", JSON.stringify(cart));

    // Gửi lại dữ liệu mới lên servlet để cập nhật session & chuyển trang
    fetch("myrooms", {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify(cart)
    })
            .then(res => {
                if (res.redirected) {
                    window.location.href = res.url; // Servlet chuyển sang myrooms_db.jsp
                } else {
                    window.location.href = "myrooms_db.jsp";
                }
            })
            .catch(err => {
                alert("❌ Lỗi gửi lại danh sách phòng");
                console.error(err);
            });
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
        type: button.getAttribute("data-type") || '', // đúng key
        price: parseFloat(button.getAttribute("data-price")), // đúng key
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
                window.location.href = 'myrooms';
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
function addRoomToDatabase(button) {
    const roomId = button.getAttribute("data-id");

    fetch("addRoomToDB", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body: `roomId=${roomId}`
    })
            .then(res => res.text())
            .then(msg => {
                Swal.fire({
                    icon: 'success',
                    title: 'Phòng đã được thêm!',
                    text: msg || 'Bạn có thể xem lại ở mục "My Rooms"',
                    showCancelButton: true,
                    confirmButtonText: 'Xem phòng đã chọn',
                    cancelButtonText: 'Tiếp tục chọn phòng'
                }).then((result) => {
                    if (result.isConfirmed) {
                        window.location.href = 'myrooms';
                    }
                });
            })
            .catch(err => {
                console.error("Lỗi khi thêm phòng vào DB:", err);
                Swal.fire({
                    icon: 'error',
                    title: 'Lỗi',
                    text: 'Không thể thêm phòng vào danh sách.'
                });
            });
}

function sendRoomCartToServerAndRedirect() {
    const cart = JSON.parse(localStorage.getItem("roomCart")) || [];

    if (cart.length === 0) {
        Swal.fire("Chưa có phòng nào", "Vui lòng chọn ít nhất một phòng.", "warning");
        return;
    }

    fetch("MyRoomsServlet", {
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
                console.error("❌ Lỗi gửi cart:", err);
                Swal.fire("Lỗi", "Không thể gửi giỏ phòng lên server", "error");
            });
}