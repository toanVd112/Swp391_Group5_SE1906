// ✅ hotel-cart-final-clean.js — BẢN GOM CHUẨN GUEST + CUSTOMER

// ---- Flag từ JSP ----
// const isCustomer = true/false đã khai báo từ JSP

// ---- Init dữ liệu ----
let selectedRooms = JSON.parse(localStorage.getItem('selectedRooms')) || [];

// ---- Thêm phòng Guest ----
function addToBooking(item) {
    if (!item.rooms) {
        const existed = selectedRooms.find(r => !r.rooms && r.roomTypeId === item.roomTypeId);
        if (existed) {
            existed.quantity += item.quantity;
        } else {
            selectedRooms.push(item);
        }
    } else {
        selectedRooms = selectedRooms.filter(x => !x.rooms);
        selectedRooms.push(item);
    }

    saveToLocalStorage();
    renderCartUI();
}

// ---- Xoá phòng Guest ----
function removeRoom(id) {
    selectedRooms = selectedRooms.filter(c => {
        if (c.rooms) {
            return c.comboId != id; // Combo Suggest
        } else {
            return c.roomTypeId != id; // Room Manual
        }
    });
    saveToLocalStorage();
    renderCartUI();
}

// ---- Thêm phòng Customer ----
function addToCustomerCart(room) {
    fetch('/AddToCustomerCartServlet', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify(room)
    })
            .then(res => res.json())
            .then(data => {
                if (data.success)
                    renderCartUI();
                else
                    alert('❌ Thêm thất bại');
            });
}

// ---- Xoá phòng Customer ----
function removeFromCustomerCart(roomTypeId) {
    fetch('/RemoveFromCustomerCartServlet', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({roomTypeId})
    })
            .then(res => res.json())
            .then(data => {
                if (data.success)
                    renderCartUI();
                else
                    alert('❌ Xoá thất bại');
            });
}

// ---- Hàm render Giỏ ----
function renderCartUI() {
    const list = document.getElementById('selectedRoomsList');
    list.innerHTML = '';
    let total = 0;
    let totalSlots = 0;
    const nights = calcNights();

    // Phòng & Combo
    selectedRooms.forEach(c => {
        let html = '';
        if (c.rooms && c.rooms.length > 0) {
            const roomsHtml = c.rooms.map(r => {
                const slotsPerRoom = r.roomCapacity || 1;
                const totalSlotRoom = r.quantity * slotsPerRoom;
                return `<li>${r.roomName} | ${slotsPerRoom} slot/phòng | Giá/phòng: ${formatCurrency(r.basePrice)}</li>`;
            }).join('');

            const slots = c.rooms.reduce((sum, r) => sum + r.quantity * (r.roomCapacity || 1), 0);
            totalSlots += slots;

            html = `
        <div class="selected-room-item">
          <h5>Combo #${c.comboId}</h5>
          <ul>${roomsHtml}</ul>
          <p><strong>Tổng Slots Combo:</strong> ${slots}</p>
          <button onclick="removeRoom(${c.comboId})" class="btn btn-sm btn-danger">Xóa Combo</button>
        </div>
      `;
            total += (c.basePrice || 0) * c.quantity * nights;
        } else {
            const slots = c.quantity * (c.roomCapacity || 1);
            totalSlots += slots;

            html = `
        <div class="selected-room-item">
          <h5>${c.roomName} ×${c.quantity}</h5>
          <p> ${slots} slot/phòng</p>
          <p>Giá/phòng: ${formatCurrency(c.basePrice)}</p>
          <button onclick="removeRoom(${c.roomTypeId})" class="btn btn-sm btn-danger">Xóa</button>
        </div>
      `;
            total += (c.basePrice || 0) * c.quantity * nights;
        }

        list.innerHTML += html;
    });

    // DỊCH VỤ
    if (selectedServices.length > 0) {
        selectedServices.forEach(s => {
            const html = `
        <div class="selected-room-item">
          <p><strong>Dịch vụ:</strong> ${s.name}</p>
          <p>Giá: ${formatCurrency(s.price)}</p>
              <button onclick="removeService(${s.serviceId})" class="btn btn-sm btn-danger">Xóa</button>
        </div>`;
            list.innerHTML += html;
            total += s.price;
        });
    }

    const tax = total * 0.1;
    const grand = total + tax;

    document.getElementById('nightsCount').textContent = `${nights} đêm`;
    document.getElementById('roomsTotal').textContent = formatCurrency(total);
    document.getElementById('taxAmount').textContent = formatCurrency(tax);
    document.getElementById('grandTotal').textContent = formatCurrency(grand);

    const guestInput = parseInt(document.getElementById('guests').value) || 0;
    const slotSummary = `
    <hr>
    <p>Slots tổng: ${totalSlots} | Khách: ${guestInput}</p>
  `;
    list.innerHTML += slotSummary;

    // Nếu KHÔNG có phòng & KHÔNG có dịch vụ ➜ Disable nút
    document.getElementById('bookingBtn').disabled = selectedRooms.length === 0 && selectedServices.length === 0;
}

function removeService(id) {
    selectedServices = selectedServices.filter(s => s.serviceId !== id);
    localStorage.setItem('selectedServices', JSON.stringify(selectedServices));
    // Tự tắt checkbox trong Tab dịch vụ (nếu muốn)
    const checkbox = document.querySelector(`input[type="checkbox"][value="${id}"]`);
    if (checkbox)
        checkbox.checked = false;
    renderCartUI();
}


// ---- Save local ----
function saveToLocalStorage() {
    localStorage.setItem('selectedRooms', JSON.stringify(selectedRooms));
}

// ---- Helpers ----
function formatCurrency(v) {
    return v.toLocaleString('vi-VN') + ' VND';
}

function calcNights() {
    const checkIn = document.getElementById('checkin').value;
    const checkOut = document.getElementById('checkout').value;
    const start = new Date(checkIn);
    const end = new Date(checkOut);
    const diff = Math.ceil((end - start) / (1000 * 60 * 60 * 24));
    return diff > 0 ? diff : 1;
}

// ---- Proceed Booking ----


// ---- Handle Combo ----
function handleComboSelection(idx) {
    const row = document.querySelector(`.combo-row[data-index='${idx}']`);
    const roomTypeIds = row.querySelectorAll("input[name='roomTypeId']");
    const quantities = row.querySelectorAll("input[name='quantity']");

    let totalBasePrice = 0;
    const rooms = [];

    for (let i = 0; i < roomTypeIds.length; i++) {
        const price = parseInt(roomTypeIds[i].dataset.basePrice || '0');
        const qty = parseInt(quantities[i].value);
        const slotsPerRoom = parseInt(roomTypeIds[i].dataset.roomCapacity || '1'); // ✅ FIX: Đúng chỗ

        rooms.push({
            roomTypeId: parseInt(roomTypeIds[i].value),
            roomName: roomTypeIds[i].dataset.roomName,
            quantity: qty,
            basePrice: price,
            roomCapacity: slotsPerRoom // ✅ Slot từng room
        });

        totalBasePrice += price * qty;
    }

    const combo = {
        comboId: idx,
        rooms: rooms,
        quantity: 1,
        basePrice: totalBasePrice
    };

    // Ghi đè combo cũ
    selectedRooms = selectedRooms.filter(item => !item.rooms);
    selectedRooms.push(combo);

    saveToLocalStorage();
    renderCartUI();
    return false;
}









// ---- Handle Manual ----
function handleManualSelection(form) {
    const room = {
        roomTypeId: parseInt(form.roomTypeId.value),
        roomName: form.roomName ? form.roomName.value : 'Room Manual',
        quantity: parseInt(form.quantity.value),
        basePrice: parseFloat(form.roomPrice.value),
        roomCapacity: parseInt(form.roomCapacity.value)
    };

    addToBooking(room);
    return false;
}



// ---- Helpers ----
function normalizeDate(dmy) {
    if (!dmy)
        return '';
    const parts = dmy.split('/');
    const dd = parts[0].padStart(2, '0');
    const mm = parts[1].padStart(2, '0');
    const yyyy = parts[2];
    return `${dd}/${mm}/${yyyy}`;
}

// ---- Detect Checkin/Checkout Change ----
function checkIfDatesChanged() {
    const params = new URLSearchParams(window.location.search);
    const checkin = params.get('checkin');
    const checkout = params.get('checkout');

    const oldCheckin = localStorage.getItem('lastCheckin');
    const oldCheckout = localStorage.getItem('lastCheckout');

    const checkinNorm = normalizeDate(checkin);
    const checkoutNorm = normalizeDate(checkout);
    const oldCheckinNorm = normalizeDate(oldCheckin);
    const oldCheckoutNorm = normalizeDate(oldCheckout);

    if (oldCheckinNorm && oldCheckoutNorm) {
        if (checkinNorm !== oldCheckinNorm || checkoutNorm !== oldCheckoutNorm) {
            // 🔥 KHÁC ➜ XÓA GIỎ luôn, không hỏi
            localStorage.removeItem('selectedRooms');
            selectedRooms = []; // ✅ Xóa RAM luôn!
        }
    }

    if (checkinNorm && checkoutNorm) {
        localStorage.setItem('lastCheckin', checkinNorm);
        localStorage.setItem('lastCheckout', checkoutNorm);
    }
}
function proceedToBooking() {
    // Lấy room/service từ localStorage
    const selectedRooms = JSON.parse(localStorage.getItem('selectedRooms')) || [];
    const selectedServices = JSON.parse(localStorage.getItem('selectedServices')) || [];
    if (selectedRooms.length === 0 && selectedServices.length > 0) {
        alert("⚠️ Bạn phải chọn ít nhất 1 phòng trước khi thanh toán! Dịch vụ không thể thanh toán riêng.");
        return;
    }
    // Tính tổng slots
    const guests = parseInt(document.getElementById('guests').value) || 0;
    let totalSlots = 0;
    selectedRooms.forEach(item => {
        if (item.rooms && item.rooms.length > 0) {
            item.rooms.forEach(r => {
                totalSlots += r.quantity * (r.roomCapacity || 1);
            });
        } else {
            totalSlots += item.quantity * (item.roomCapacity || 1);
        }
    });

    if (totalSlots - guests > 2) {
        alert("⚠️ Slot lệch quá lớn!");
        return;
    }

    // Tính tổng tiền từ UI hiển thị
    const total = parseFloat(
            document.getElementById('grandTotal').textContent.replace(/[^\d]/g, '')
            ) || 0;

    // Nếu là Guest ➜ mở modal nhập info
    if (!isCustomer) {
        document.getElementById('guestInfoModal').style.display = 'block';
        return;
    }

    // Nếu là Customer ➜ gán hidden & submit luôn
    document.getElementById('selectedRoomsJSON').value = JSON.stringify(selectedRooms);
    document.getElementById('selectedServicesJSON').value = JSON.stringify(selectedServices);
    document.getElementById('hiddenCheckin').value = document.getElementById('checkin').value;
    document.getElementById('hiddenCheckout').value = document.getElementById('checkout').value;
    document.getElementById('hiddenGuests').value = guests;
    document.getElementById('totalAmount').value = total;
    localStorage.removeItem('selectedRooms');
    localStorage.removeItem('selectedServices');

    document.getElementById('bookingForm').submit();
}


function confirmGuestInfo() {
    const name = document.getElementById('guestFullName').value.trim();
    const email = document.getElementById('guestEmail').value.trim();
    const phone = document.getElementById('guestPhone').value.trim();

    if (!name || !email || !phone) {
        alert("Vui lòng nhập đầy đủ thông tin!");
        return;
    }

    // Load lại room/service từ localStorage
    const selectedRooms = JSON.parse(localStorage.getItem('selectedRooms')) || [];
    const selectedServices = JSON.parse(localStorage.getItem('selectedServices')) || [];

    // Slot & guest check
    const guests = parseInt(document.getElementById('guests').value) || 0;

    // 👉 Lấy tổng từ UI hiển thị
    const total = parseFloat(
            document.getElementById('grandTotal').textContent.replace(/[^\d]/g, '')
            ) || 0;

    // Gán hidden fields
    document.getElementById('selectedRoomsJSON').value = JSON.stringify(selectedRooms);
    document.getElementById('selectedServicesJSON').value = JSON.stringify(selectedServices);
    document.getElementById('hiddenGuests').value = guests;
    document.getElementById('hiddenCheckin').value = document.getElementById('checkin').value;
    document.getElementById('hiddenCheckout').value = document.getElementById('checkout').value;
    document.getElementById('totalAmount').value = total;

    document.getElementById('fullName').value = name;
    document.getElementById('email').value = email;
    document.getElementById('phone').value = phone;

    // Ẩn modal
    document.getElementById('guestInfoModal').style.display = 'none';

    // Submit form
    localStorage.removeItem('selectedRooms');
    localStorage.removeItem('selectedServices');

    document.getElementById('bookingForm').submit();
}

let selectedServices = JSON.parse(localStorage.getItem('selectedServices')) || [];
function formatCurrency(v) {
    return v.toLocaleString('vi-VN') + ' VND';
}
function toggleService(el) {
    const id = parseInt(el.value);
    const name = el.dataset.name;
    const price = parseInt(el.dataset.price);

    const index = selectedServices.findIndex(s => s.serviceId === id);
    if (index >= 0) {
        selectedServices.splice(index, 1);
    } else {
        selectedServices.push({serviceId: id, name, price});
    }

    localStorage.setItem('selectedServices', JSON.stringify(selectedServices));
    renderCartUI();
}

localStorage.setItem('selectedServices', JSON.stringify(selectedServices));

// === Init Service Branch ===
document.addEventListener('DOMContentLoaded', function () {
    renderCartServices();
});
document.addEventListener('DOMContentLoaded', function () {
    checkIfDatesChanged();
    renderCartUI();
});
// ---- Init ----
document.addEventListener('DOMContentLoaded', renderCartUI);
window.handleComboSelection = handleComboSelection;
window.handleManualSelection = handleManualSelection;