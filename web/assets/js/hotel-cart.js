// ✅ hotel-cart-final-clean.js — BẢN GOM CHUẨN GUEST + CUSTOMER

// ---- Flag từ JSP ----
// const isCustomer = true/false đã khai báo từ JSP

// ---- Init dữ liệu ----
let selectedRooms = JSON.parse(localStorage.getItem('selectedRooms')) || [];

// ---- Thêm phòng Guest ----
function addToBooking(room) {
  selectedRooms.push(room);
  saveToLocalStorage();
  renderCartUI();
}

// ---- Xoá phòng Guest ----
function removeRoom(roomTypeId) {
  selectedRooms = selectedRooms.filter(r => r.roomTypeId != roomTypeId);
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
    if (data.success) renderCartUI();
    else alert('❌ Thêm thất bại');
  });
}

// ---- Xoá phòng Customer ----
function removeFromCustomerCart(roomTypeId) {
  fetch('/RemoveFromCustomerCartServlet', {
    method: 'POST',
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify({ roomTypeId })
  })
  .then(res => res.json())
  .then(data => {
    if (data.success) renderCartUI();
    else alert('❌ Xoá thất bại');
  });
}

// ---- Hàm render Giỏ ----
function renderCartUI() {
  const list = document.getElementById('selectedRoomsList');
  list.innerHTML = '';
  let total = 0;

  if (selectedRooms.length === 0) {
    list.innerHTML = '<p>Chưa có phòng nào được chọn</p>';
  }

  selectedRooms.forEach(r => {
    const html = `
      <div class="selected-room-item">
        <h4>${r.name} x${r.quantity}</h4>
        <button onclick="${isCustomer ? `removeFromCustomerCart(${r.roomTypeId})` : `removeRoom(${r.roomTypeId})`}">X</button>
      </div>`;
    list.innerHTML += html;
    total += r.basePrice * r.quantity;
  });

  const nights = calcNights();
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
  if (isCustomer) return true;
  const row = document.querySelector(`.combo-row[data-index='${idx}']`);
  const roomTypeId = row.querySelector("input[name='roomTypeId']").value;
  const quantity = row.querySelector("input[name='quantity']").value;
  const room = {
    roomTypeId: parseInt(roomTypeId),
    name: `Combo #${idx}`,
    quantity: parseInt(quantity),
    basePrice: 500000 * idx
  };
  addToBooking(room);
  return false;
}

// ---- Handle Manual ----
function handleManualSelection(form) {
  if (isCustomer) return true;
  const room = {
    roomTypeId: parseInt(form.roomTypeId.value),
    name: 'Room Manual',
    quantity: parseInt(form.quantity.value),
    basePrice: 500000
  };
  addToBooking(room);
  return false;
}

// ---- Init ----
document.addEventListener('DOMContentLoaded', renderCartUI);
