let currentForm = null;



function submitAndStay() {
    document.getElementById("confirmModal").style.display = "none";
    currentForm.action = "addToGuestCart?redirect=Home";
    currentForm.submit();
}

function submitAndGo() {
    document.getElementById("confirmModal").style.display = "none";
    currentForm.action = "addToGuestCart?redirect=myrooms_db.jsp";
    currentForm.submit();
}
function showCustomAlert(message) {
    document.getElementById("customAlertMessage").innerText = message;
    document.getElementById("customAlert").style.display = "flex";
}

function closeCustomAlert() {
    document.getElementById("customAlert").style.display = "none";
}
function confirmAddRoom(form) {
    const roomTypeId = form.querySelector('input[name="roomTypeId"]').value;

    // Kiểm tra nếu đã có trong guestCart thì không thêm nữa
    const alreadyExists = guestCart.some(item => item.roomTypeId === roomTypeId);

    if (alreadyExists) {
        showCustomAlert("Phòng này đã có trong danh sách phòng đã chọn.");
        return false; // Ngăn submit
    }

    // Nếu chưa có thì hiển thị modal xác nhận
    currentForm = form;
    document.getElementById("confirmModal").style.display = "block";
    return false; // Chờ người dùng chọn tiếp hay xem phòng
}
function showCustomAlert(message) {
    document.getElementById("customAlertMessage").innerText = message;
    document.getElementById("customAlert").style.display = "flex";
}

function closeCustomAlert() {
    document.getElementById("customAlert").style.display = "none";
}
