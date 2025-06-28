/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


/**
 * room-selection.js
 * Kiểm soát sức chứa và số lượng phòng trước khi thêm vào giỏ.
 */

// Config buffer cho phép thừa 1–2 chỗ
const CAPACITY_BUFFER = 1;

// Biến này bạn cần render từ JSP
// Ví dụ: <script>const TOTAL_GUESTS = ${param.guests};</script>
let TOTAL_GUESTS = window.TOTAL_GUESTS || 1;

// Biến này bạn nên render: tổng sức chứa các phòng đã chọn
let CURRENT_CART_CAPACITY = window.CURRENT_CART_CAPACITY || 0;

function validateRoomSelection(form) {
  const roomCapacity = parseInt(form.closest('form').dataset.roomCapacity);
  const quantity = parseInt(form.querySelector('input[name="quantity"]').value);

  const addedCapacity = roomCapacity * quantity;

  const newTotal = CURRENT_CART_CAPACITY + addedCapacity;

  if (newTotal > TOTAL_GUESTS + CAPACITY_BUFFER) {
    alert(`⚠️ Bạn đang chọn vượt quá số khách cần đặt.
Tổng sức chứa mới: ${newTotal} > Số khách: ${TOTAL_GUESTS}.
Hãy giảm số lượng phòng hoặc chọn loại khác.`);
    return false;
  }

  // Trường hợp Single Room: không được chọn quá số khách
  if (roomCapacity === 1 && quantity > TOTAL_GUESTS) {
    alert(`⚠️ Bạn chỉ cần tối đa ${TOTAL_GUESTS} phòng Single Room.`);
    return false;
  }

  return true;
}
