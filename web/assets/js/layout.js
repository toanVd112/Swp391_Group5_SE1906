// Layout JavaScript
document.addEventListener("DOMContentLoaded", () => {
  // Mobile menu toggle
  const mobileMenuBtn = document.querySelector(".mobile-menu-btn")
  const sidebar = document.querySelector(".sidebar")

  if (mobileMenuBtn) {
    mobileMenuBtn.addEventListener("click", () => {
      sidebar.classList.toggle("show")
    })
  }

  // Active menu item
  const currentPath = window.location.pathname
  const menuItems = document.querySelectorAll(".menu-item")

  menuItems.forEach((item) => {
    if (item.getAttribute("href") === currentPath) {
      item.classList.add("active")
    }
  })

  // Search functionality
  const searchInput = document.querySelector(".search-box input")
  if (searchInput) {
    searchInput.addEventListener("keypress", function (e) {
      if (e.key === "Enter") {
        // Implement search functionality
        console.log("Search:", this.value)
      }
    })
  }

  // Quick action buttons
  const quickActionBtns = document.querySelectorAll(".quick-action-btn")
  quickActionBtns.forEach((btn) => {
    btn.addEventListener("click", function () {
      const action = this.textContent.trim()
      console.log("Quick action:", action)
      // Implement quick action functionality
    })
  })
})