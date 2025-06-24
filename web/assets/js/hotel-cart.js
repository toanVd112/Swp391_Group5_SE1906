// Global variables to store booking data
let selectedRooms = [];
let guestCounts = {};

// Initialize guest counts for all rooms
document.addEventListener('DOMContentLoaded', function () {
    // Initialize guest counts for each room
    const roomCards = document.querySelectorAll('.room-card');
    roomCards.forEach(card => {
        const roomTypeId = card.getAttribute('data-room-type-id');
        if (!guestCounts[roomTypeId]) {
            guestCounts[roomTypeId] = {
                adults: 2,
                children: 0
            };
        }
        updateGuestDisplay(roomTypeId);
    });

    // Set default dates if not set
    const today = new Date();
    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);

    const checkInInput = document.getElementById('checkInDate');
    const checkOutInput = document.getElementById('checkOutDate');

    if (!checkInInput.value) {
        checkInInput.value = today.toISOString().split('T')[0];
    }
    if (!checkOutInput.value) {
        checkOutInput.value = tomorrow.toISOString().split('T')[0];
    }

    calculateTotal();
});

// Function to change guest count
function changeGuest(roomTypeId, guestType, change) {
    if (!guestCounts[roomTypeId]) {
        guestCounts[roomTypeId] = {adults: 2, children: 0};
    }

    const currentCount = guestCounts[roomTypeId][guestType];
    const newCount = currentCount + change;

    // Validation
    if (guestType === 'adults' && newCount < 1)
        return;
    if (guestType === 'children' && newCount < 0)
        return;

    // Get max guest limit from room card
    const roomCard = document.querySelector(`[data-room-type-id="${roomTypeId}"]`);
    const maxGuestText = roomCard.querySelector('.room-details div').textContent;
    const maxGuest = parseInt(maxGuestText.match(/\d+/)[0]);

    const totalGuests = (guestType === 'adults' ? newCount : guestCounts[roomTypeId].adults) +
            (guestType === 'children' ? newCount : guestCounts[roomTypeId].children);

    if (totalGuests > maxGuest) {
        alert(`Số lượng khách không được vượt quá ${maxGuest} người`);
        return;
    }

    guestCounts[roomTypeId][guestType] = newCount;
    updateGuestDisplay(roomTypeId);

    // Update selected room if it exists
    const selectedRoom = selectedRooms.find(room => room.roomTypeId === roomTypeId);
    if (selectedRoom) {
        selectedRoom.adults = guestCounts[roomTypeId].adults;
        selectedRoom.children = guestCounts[roomTypeId].children;
        updateSelectedRoomsDisplay();
        calculateTotal();
    }
    saveToLocalStorage();
}

// Function to update guest display
function updateGuestDisplay(roomTypeId) {
    const adultsElement = document.getElementById(`adults_${roomTypeId}`);
    const childrenElement = document.getElementById(`children_${roomTypeId}`);

    if (adultsElement) {
        adultsElement.textContent = guestCounts[roomTypeId].adults;
    }
    if (childrenElement) {
        childrenElement.textContent = guestCounts[roomTypeId].children;
    }
}

// Function to add room to booking
function addToBooking(roomTypeId) {
    const roomCard = document.querySelector(`[data-room-type-id="${roomTypeId}"]`);
    if (!roomCard)
        return;

    // Check if room is already selected
    const existingRoom = selectedRooms.find(room => room.roomTypeId === roomTypeId);
    if (existingRoom) {
        alert('Phòng này đã được thêm vào đặt phòng');
        return;
    }

    // Extract room information
    const roomName = roomCard.querySelector('h3').textContent.replace('Phòng loại: ', '');
    const priceText = roomCard.querySelector('.price-amount').textContent;
    const basePrice = parseInt(priceText.replace(/[^\d]/g, ''));
    const imageUrl = roomCard.querySelector('img').src;
    const maxGuestText = roomCard.querySelector('.room-details div').textContent;
    const maxGuest = parseInt(maxGuestText.match(/\d+/)[0]);

    // Create room object
    const roomData = {
        roomTypeId: roomTypeId,
        roomName: roomName,
        basePrice: basePrice,
        imageUrl: imageUrl,
        maxGuest: maxGuest,
        adults: guestCounts[roomTypeId].adults,
        children: guestCounts[roomTypeId].children || 0,
        quantity: 1
    };

    // Add to selected rooms
    selectedRooms.push(roomData);

    // Update displays
    updateSelectedRoomsDisplay();
    calculateTotal();
    saveToLocalStorage();
    // Show success message
    showNotification('Đã thêm phòng vào đặt phòng thành công!', 'success');
}

// Function to remove room from booking
function removeFromBooking(roomTypeId) {
    selectedRooms = selectedRooms.filter(room => room.roomTypeId !== roomTypeId);
    updateSelectedRoomsDisplay();
    calculateTotal();
    saveToLocalStorage();
    showNotification('Đã xóa phòng khỏi đặt phòng', 'info');
}

// Function to update selected rooms display
function updateSelectedRoomsDisplay() {
    const selectedRoomsList = document.getElementById('selectedRoomsList');

    if (selectedRooms.length === 0) {
        selectedRoomsList.innerHTML = `
            <div class="empty-selection">
                <i class="fas fa-bed" style="font-size: 2rem; color: #d1d5db; margin-bottom: 10px;"></i>
                <p style="color: #6b7280; margin: 0;">Chưa có phòng nào được chọn</p>
            </div>
        `;
        return;
    }

    selectedRoomsList.innerHTML = selectedRooms.map(room => `
        <div class="selected-room-item" data-room-id="${room.roomTypeId}">
            <div class="selected-room-info">
                <img src="${room.imageUrl}" alt="${room.roomName}" style="width: 60px; height: 45px; object-fit: cover; border-radius: 4px;">
                <div class="selected-room-details">
                   <h4>${room.roomName} <span style="font-weight: normal;">x${room.quantity}</span></h4>
                    <div class="guest-info">
                        <i class="fas fa-users"></i> 
                        ${room.adults} người lớn${room.children > 0 ? `, ${room.children} trẻ em` : ''}
                    </div>
                </div>
            </div>
            <div class="selected-room-price">
                <span class="price">${formatPrice(room.basePrice)} VND</span>
                <button type="button" class="remove-btn" onclick="removeFromBooking('${room.roomTypeId}')" title="Xóa phòng">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        </div>
    `).join('');
}

// Function to calculate total price
function calculateTotal() {
    const checkInDate = document.getElementById('checkInDate').value;
    const checkOutDate = document.getElementById('checkOutDate').value;

    if (!checkInDate || !checkOutDate)
        return;

    const checkIn = new Date(checkInDate);
    const checkOut = new Date(checkOutDate);
    const nights = Math.ceil((checkOut - checkIn) / (1000 * 60 * 60 * 24));

    if (nights <= 0) {
        alert('Ngày trả phòng phải sau ngày nhận phòng');
        return;
    }

    // Update nights display
    document.getElementById('nightsCount').textContent = `${nights} đêm`;

    // Calculate room total
    let roomsTotal = 0;
    selectedRooms.forEach(room => {
        roomsTotal += room.basePrice * nights * room.quantity;
    });

    // Calculate tax (10%)
    const taxAmount = Math.round(roomsTotal * 0.1);
    const grandTotal = roomsTotal + taxAmount;

    // Update price display
    document.getElementById('roomsTotal').textContent = formatPrice(roomsTotal) + ' VND';
    document.getElementById('taxAmount').textContent = formatPrice(taxAmount) + ' VND';
    document.getElementById('grandTotal').textContent = formatPrice(grandTotal) + ' VND';

    // Enable/disable booking button
    const bookingBtn = document.getElementById('bookingBtn');
    if (selectedRooms.length > 0 && nights > 0) {
        bookingBtn.disabled = false;
        bookingBtn.classList.remove('disabled');
    } else {
        bookingBtn.disabled = true;
        bookingBtn.classList.add('disabled');
    }
}

// Function to format price with thousand separators
function formatPrice(price) {
    return price.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
}

// Function to proceed to booking
function proceedToBooking() {
    if (selectedRooms.length === 0) {
        alert('Vui lòng chọn ít nhất một phòng');
        return;
    }

    const checkInDate = document.getElementById('checkInDate').value;
    const checkOutDate = document.getElementById('checkOutDate').value;

    if (!checkInDate || !checkOutDate) {
        alert('Vui lòng chọn ngày nhận phòng và trả phòng');
        return;
    }

    // Prepare booking data
    const bookingData = {
        checkInDate: checkInDate,
        checkOutDate: checkOutDate,
        selectedRooms: selectedRooms,
        totalAmount: document.getElementById('grandTotal').textContent.replace(/[^\d]/g, '')
    };

    // Store in session storage for next page
    sessionStorage.setItem('bookingData', JSON.stringify(bookingData));

    // Redirect to booking confirmation page
    window.location.href = 'booking-confirmation.jsp';
}

// Function to show notifications
function showNotification(message, type = 'info') {
    // Remove existing notifications
    const existingNotification = document.querySelector('.booking-notification');
    if (existingNotification) {
        existingNotification.remove();
    }

    // Create notification element
    const notification = document.createElement('div');
    notification.className = `booking-notification ${type}`;
    notification.innerHTML = `
        <div class="notification-content">
            <i class="fas ${type === 'success' ? 'fa-check-circle' : type === 'error' ? 'fa-exclamation-circle' : 'fa-info-circle'}"></i>
            <span>${message}</span>
            <button type="button" class="notification-close" onclick="this.parentElement.parentElement.remove()">
                <i class="fas fa-times"></i>
            </button>
        </div>
    `;

    // Add to page
    document.body.appendChild(notification);

    // Auto remove after 3 seconds
    setTimeout(() => {
        if (notification.parentElement) {
            notification.remove();
        }
    }, 3000);
}

// Function to update room quantity (if needed)
function updateRoomQuantity(roomTypeId, change) {
    const room = selectedRooms.find(r => r.roomTypeId === roomTypeId);
    if (!room)
        return;

    const newQuantity = room.quantity + change;
    if (newQuantity < 1)
        return;

    room.quantity = newQuantity;
    updateSelectedRoomsDisplay();
    calculateTotal();
    saveToLocalStorage();
}

// Event listeners for date changes
document.addEventListener('DOMContentLoaded', function () {
    const checkInInput = document.getElementById('checkInDate');
    const checkOutInput = document.getElementById('checkOutDate');

    if (checkInInput) {
        checkInInput.addEventListener('change', function () {
            // Ensure check-out is after check-in
            const checkInDate = new Date(this.value);
            const checkOutDate = new Date(checkOutInput.value);

            if (checkOutDate <= checkInDate) {
                const newCheckOut = new Date(checkInDate);
                newCheckOut.setDate(newCheckOut.getDate() + 1);
                checkOutInput.value = newCheckOut.toISOString().split('T')[0];
            }

            calculateTotal();
        });
    }

    if (checkOutInput) {
        checkOutInput.addEventListener('change', calculateTotal);
    }
});

// Function to clear all selections
function clearAllSelections() {
    selectedRooms = [];
    updateSelectedRoomsDisplay();
    calculateTotal();
    saveToLocalStorage();
    showNotification('Đã xóa tất cả phòng đã chọn', 'info');
}
function updateRoomQuantityUI(roomTypeId, change) {
    const quantityEl = document.getElementById(`quantity_${roomTypeId}`);
    let current = parseInt(quantityEl.textContent);
    const newQty = current + change;
    if (newQty < 1)
        return;
    quantityEl.textContent = newQty;

    const room = selectedRooms.find(r => r.roomTypeId === roomTypeId);
    if (room) {
        room.quantity = newQty;
        updateSelectedRoomsDisplay();
        calculateTotal();
        saveToLocalStorage();
    }
}

// Local Storage Persistence
function saveToLocalStorage() {
    localStorage.setItem('selectedRooms', JSON.stringify(selectedRooms));
    localStorage.setItem('guestCounts', JSON.stringify(guestCounts));
}

function loadFromLocalStorage() {
    const storedRooms = localStorage.getItem('selectedRooms');
    const storedGuests = localStorage.getItem('guestCounts');
    if (storedRooms)
        selectedRooms = JSON.parse(storedRooms);
    if (storedGuests)
        guestCounts = JSON.parse(storedGuests);
}

// Load data on DOM ready
document.addEventListener('DOMContentLoaded', () => {
    loadFromLocalStorage();
    updateSelectedRoomsDisplay();
    calculateTotal();
});
function addToCustomerCart(button) {

    const roomTypeId = button.dataset.roomTypeId;
    const roomName = button.dataset.roomName;
    const basePrice = parseInt(button.dataset.basePrice);
    const imageUrl = button.dataset.imageUrl;
    const maxGuest = parseInt(button.dataset.maxGuest);

    const quantity = parseInt(document.getElementById(`quantity_${roomTypeId}`)?.textContent || '1');
    const numGuests = parseInt(document.getElementById(`adults_${roomTypeId}`)?.textContent || '2');

    const payload = {
        roomTypeId: parseInt(roomTypeId),
        roomName,
        basePrice,
        imageUrl,
        maxGuest,
        quantity,
        numGuests
    };

    fetch('AddToCustomerCartServlet', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify(payload)
    })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    showConfirmModal(); // mới
                } else {
                    showNotification("Thêm thất bại", "error");
                }
            })
            .catch(err => {
                console.error(err);
                showNotification("Lỗi kết nối máy chủ", "error");
            });
}
function showConfirmModal() {
    const modal = document.getElementById('confirmModal');
    if (modal) {
        modal.style.display = 'block';
    }
}
window.onclick = function (event) {
    const modal = document.getElementById('confirmModal');
    if (event.target === modal) {
        modal.style.display = 'none';
    }
};
function submitAndStay() {
    document.getElementById('confirmModal').style.display = 'none';
}

function submitAndGo() {
    window.location.href = 'cart.jsp';
}


// Export functions for global access
window.changeGuest = changeGuest;
window.addToBooking = addToBooking;
window.removeFromBooking = removeFromBooking;
window.proceedToBooking = proceedToBooking;
window.updateRoomQuantity = updateRoomQuantity;
window.clearAllSelections = clearAllSelections;