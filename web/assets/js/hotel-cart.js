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

    if (selectedRooms.length === 0) {
        list.innerHTML = '<p>Chưa có phòng nào được chọn</p>';
        return;
    }

    const nights = calcNights();

   selectedRooms.forEach(c => {
  let roomsHtml = '';

  if (c.rooms && c.rooms.length > 0) {
    roomsHtml = c.rooms.map(r => `<div>${r.roomName} ×${r.quantity}</div>`).join('');
  } else if (c.roomName) {
    roomsHtml = `<div>${c.roomName} ×${c.quantity}</div>`;
  }

  const html = `
    <div class="selected-room-item">
      <h4>${c.rooms ? `Combo #${c.comboId}` : `Room #${c.roomTypeId}`} ×${c.quantity}</h4>
      ${roomsHtml}
      <button onclick="removeRoom(${c.comboId || c.roomTypeId})">X</button>
    </div>`;
  list.innerHTML += html;

  total += c.basePrice * c.quantity * nights;
});



    const tax = total * 0.1;
    const grand = total + tax;

    document.getElementById('nightsCount').textContent = `${nights} đêm`;
    document.getElementById('roomsTotal').textContent = formatCurrency(total);
    document.getElementById('taxAmount').textContent = formatCurrency(tax);
    document.getElementById('grandTotal').textContent = formatCurrency(grand);

    document.getElementById('bookingBtn').disabled = selectedRooms.length === 0;
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
function proceedToBooking() {
    if (isCustomer) {
        window.location.href = '/CheckoutServlet';
    } else {
        saveToLocalStorage();
        window.location.href = '/GuestCheckout.jsp';
    }
}

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
        rooms.push({
            roomTypeId: parseInt(roomTypeIds[i].value),
            roomName: roomTypeIds[i].dataset.roomName,
            quantity: qty,
            basePrice: price
        });
        totalBasePrice += price * qty;
    }

    const combo = {
        comboId: idx,
        rooms: rooms,
        quantity: 1,
        basePrice: totalBasePrice
    };

    selectedRooms = selectedRooms.filter(item => !item.rooms);
    selectedRooms.push(combo);
    saveToLocalStorage();
    renderCartUI();
    return false;
}








// ---- Handle Manual ----
function handleManualSelection(form) {
    if (isCustomer)
        return true;
    const room = {
        roomTypeId: parseInt(form.roomTypeId.value),
        roomName: form.roomName ? form.roomName.value : 'Room Manual',
        quantity: parseInt(form.quantity.value),
        basePrice: 500000
    };

    addToBooking(room);
    return false;
}


// ---- Init ----
document.addEventListener('DOMContentLoaded', renderCartUI);
window.handleComboSelection = handleComboSelection;
window.handleManualSelection = handleManualSelection;