/**
 * Hotel Booking Interface JavaScript
 * Handles all interactive functionality for the hotel booking system
 */

// Global variables
let isFilterPanelVisible = true
let currentActiveTab = "suggestions"

// Declare gtag and fbq variables
const gtag = window.gtag || (() => {
})
const fbq = window.fbq || (() => {
})

// DOM Content Loaded Event
document.addEventListener("DOMContentLoaded", () => {
    initializeBookingInterface()
})

/**
 * Initialize all functionality when page loads
 */
function initializeBookingInterface() {
    setupStickyActionBar()
    setupFormValidation()
    setupDateInputs()
    setupSmoothScrolling()
    setupKeyboardNavigation()
    setupLoadingStates()

    console.log("Hotel booking interface initialized successfully")
}

/**
 * Sticky action bar functionality
 */
function setupStickyActionBar() {
    const actionBar = document.getElementById("actionBar")
    if (!actionBar)
        return

    let ticking = false

    function updateStickyBar() {
        const scrollPosition = window.scrollY

        if (scrollPosition > 200) {
            actionBar.classList.add("sticky")
        } else {
            actionBar.classList.remove("sticky")
        }
        ticking = false
    }

    function requestTick() {
        if (!ticking) {
            requestAnimationFrame(updateStickyBar)
            ticking = true
        }
    }

    window.addEventListener("scroll", requestTick, {passive: true})
}

/**
 * Tab switching functionality
 * @param {string} tabName - Name of the tab to switch to
 */
function switchTab(tabName) {
    // Validate tab name
    if (!["suggestions", "manual"].includes(tabName)) {
        console.error("Invalid tab name:", tabName)
        return
    }

    try {
        // Hide all tab contents
        document.querySelectorAll(".tab-content").forEach((content) => {
            content.classList.remove("active")
        })

        // Remove active class from all tab buttons
        document.querySelectorAll(".tab-btn").forEach((btn) => {
            btn.classList.remove("active")
        })

        // Show selected tab content
        const targetContent = document.getElementById(tabName + "Content")
        const targetButton = document.getElementById(tabName + "Tab")

        if (targetContent && targetButton) {
            targetContent.classList.add("active")
            targetButton.classList.add("active")
            currentActiveTab = tabName

            // Announce tab change for screen readers
            announceToScreenReader(`Switched to ${tabName} tab`)

            // Track tab switching for analytics (if needed)
            trackEvent("tab_switch", {tab: tabName})
        } else {
            console.error("Tab elements not found for:", tabName)
        }
    } catch (error) {
        console.error("Error switching tabs:", error)
    }
}

/**
 * Filter panel toggle functionality
 */
function toggleFilters() {
    const filterPanel = document.getElementById("filterPanel")
    if (!filterPanel)
        return

    try {
        if (isFilterPanelVisible) {
            filterPanel.style.display = "none"
            isFilterPanelVisible = false
            announceToScreenReader("Filters hidden")
        } else {
            filterPanel.style.display = "block"
            isFilterPanelVisible = true
            announceToScreenReader("Filters shown")
        }

        // Update button text/icon if needed
        const filterButton = document.querySelector('[onclick="toggleFilters()"]')
        if (filterButton) {
            const icon = filterButton.querySelector("i")
            if (icon) {
                icon.className = isFilterPanelVisible ? "fas fa-filter" : "fas fa-filter-slash"
            }
        }
    } catch (error) {
        console.error("Error toggling filters:", error)
    }
}

/**
 * Form validation setup
 */
function setupFormValidation() {
    const checkinInput = document.getElementById("checkin")
    const checkoutInput = document.getElementById("checkout")
    const guestsInput = document.getElementById("guests")

    if (!checkinInput || !checkoutInput)
        return

    // Set minimum dates
    const today = new Date().toISOString().split("T")[0]
    checkinInput.min = today
    checkoutInput.min = today

    // Check-in date change handler
    checkinInput.addEventListener("change", function () {
        const checkinDate = new Date(this.value)
        const nextDay = new Date(checkinDate)
        nextDay.setDate(nextDay.getDate() + 1)

        checkoutInput.min = nextDay.toISOString().split("T")[0]

        // Auto-adjust checkout if it's before new checkin
        if (checkoutInput.value && new Date(checkoutInput.value) <= checkinDate) {
            checkoutInput.value = nextDay.toISOString().split("T")[0]
        }

        validateDateRange()
    })

    // Check-out date change handler
    checkoutInput.addEventListener("change", validateDateRange)

    // Guests input validation
    if (guestsInput) {
        guestsInput.addEventListener("input", function () {
            const value = Number.parseInt(this.value)
            if (value < 1) {
                this.value = 1
            } else if (value > 20) {
                this.value = 20
                showNotification("Maximum 20 guests allowed", "warning")
            }
        })
    }
}

/**
 * Validate date range
 */
function validateDateRange() {
    const checkinInput = document.getElementById("checkin")
    const checkoutInput = document.getElementById("checkout")

    if (!checkinInput || !checkoutInput || !checkinInput.value || !checkoutInput.value)
        return

    const checkinDate = new Date(checkinInput.value)
    const checkoutDate = new Date(checkoutInput.value)
    const diffTime = checkoutDate - checkinDate
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24))

    if (diffDays <= 0) {
        showNotification("Check-out date must be after check-in date", "error")
        return false
    }

    if (diffDays > 30) {
        showNotification("Maximum stay is 30 days", "warning")
        return false
    }

    return true
}

/**
 * Setup date inputs with better UX
 */
function setupDateInputs() {
    const dateInputs = document.querySelectorAll('input[type="date"]')

    dateInputs.forEach((input) => {
        // Add placeholder text for better UX
        input.addEventListener("focus", function () {
            this.showPicker && this.showPicker()
        })

        // Format display for better readability
        input.addEventListener("change", function () {
            if (this.value) {
                const date = new Date(this.value)
                const formattedDate = date.toLocaleDateString("vi-VN", {
                    weekday: "short",
                    year: "numeric",
                    month: "short",
                    day: "numeric",
                })
                this.title = formattedDate
            }
        })
    })
}

/**
 * Setup smooth scrolling for anchor links
 */
function setupSmoothScrolling() {
    document.querySelectorAll('a[href^="#"]').forEach((anchor) => {
        anchor.addEventListener("click", function (e) {
            e.preventDefault()
            const target = document.querySelector(this.getAttribute("href"))
            if (target) {
                const headerOffset = 100
                const elementPosition = target.getBoundingClientRect().top
                const offsetPosition = elementPosition + window.pageYOffset - headerOffset

                window.scrollTo({
                    top: offsetPosition,
                    behavior: "smooth",
                })
            }
        })
    })
}

/**
 * Setup keyboard navigation
 */
function setupKeyboardNavigation() {
    document.addEventListener("keydown", (e) => {
        // Tab switching with keyboard shortcuts
        if (e.ctrlKey || e.metaKey) {
            switch (e.key) {
                case "1":
                    e.preventDefault()
                    switchTab("suggestions")
                    break
                case "2":
                    e.preventDefault()
                    switchTab("manual")
                    break
                case "f":
                    e.preventDefault()
                    toggleFilters()
                    break
            }
        }

        // Escape key to close modals/filters
        if (e.key === "Escape") {
            if (isFilterPanelVisible) {
                toggleFilters()
            }
        }
    })
}

/**
 * Setup loading states for forms
 */
function setupLoadingStates() {
    const forms = document.querySelectorAll("form")

    forms.forEach((form) => {
        form.addEventListener("submit", function () {
            const submitButton = this.querySelector('button[type="submit"]')
            if (submitButton) {
                showLoadingState(submitButton)
            }
        })
    })
}

/**
 * Show loading state on button
 * @param {HTMLElement} button - Button element to show loading state
 */
function showLoadingState(button) {
    if (!button)
        return

    const originalText = button.innerHTML
    button.innerHTML = '<i class="spinner"></i> Đang xử lý...'
    button.disabled = true

    // Reset after 10 seconds as fallback
    setTimeout(() => {
        button.innerHTML = originalText
        button.disabled = false
    }, 10000)
}

/**
 * Show notification to user
 * @param {string} message - Message to display
 * @param {string} type - Type of notification (success, error, warning, info)
 */
function showNotification(message, type = "info") {
    // Remove existing notifications
    const existingNotifications = document.querySelectorAll(".notification")
    existingNotifications.forEach((notification) => notification.remove())

    // Create notification element
    const notification = document.createElement("div")
    notification.className = `notification alert alert-${type}`
    notification.innerHTML = `
        <div style="display: flex; align-items: center; justify-content: space-between;">
            <span>${message}</span>
            <button onclick="this.parentElement.parentElement.remove()" style="background: none; border: none; font-size: 1.2rem; cursor: pointer;">&times;</button>
        </div>
    `

    // Add to page
    document.body.appendChild(notification)

    // Position notification
    notification.style.position = "fixed"
    notification.style.top = "20px"
    notification.style.right = "20px"
    notification.style.zIndex = "9999"
    notification.style.maxWidth = "400px"
    notification.style.animation = "slideInRight 0.3s ease-out"

    // Auto remove after 5 seconds
    setTimeout(() => {
        if (notification.parentElement) {
            notification.style.animation = "slideOutRight 0.3s ease-out"
            setTimeout(() => notification.remove(), 300)
        }
    }, 5000)
}

/**
 * Announce message to screen readers
 * @param {string} message - Message to announce
 */
function announceToScreenReader(message) {
    const announcement = document.createElement("div")
    announcement.setAttribute("aria-live", "polite")
    announcement.setAttribute("aria-atomic", "true")
    announcement.className = "sr-only"
    announcement.textContent = message

    document.body.appendChild(announcement)

    setTimeout(() => {
        document.body.removeChild(announcement)
    }, 1000)
}

/**
 * Track events for analytics
 * @param {string} eventName - Name of the event
 * @param {Object} eventData - Additional event data
 */
function trackEvent(eventName, eventData = {}) {
    // Implement your analytics tracking here
    console.log("Event tracked:", eventName, eventData)

    // Example: Google Analytics 4
    if (typeof gtag !== "undefined") {
        gtag("event", eventName, eventData)
    }

    // Example: Facebook Pixel
    if (typeof fbq !== "undefined") {
        fbq("track", eventName, eventData)
}
}

/**
 * Handle room selection
 * @param {number} roomId - ID of the selected room
 * @param {number} quantity - Quantity of rooms
 */
function handleRoomSelection(roomId, quantity = 1) {
    try {
        showLoadingState(event.target)

        // Track room selection
        trackEvent("room_selected", {
            room_id: roomId,
            quantity: quantity,
            tab: currentActiveTab,
        })

        // Show confirmation if needed
        if (quantity > 1) {
            const confirmed = confirm(`Bạn có chắc chắn muốn đặt ${quantity} phòng?`)
            if (!confirmed) {
                return false
            }
        }

        showNotification("Đang thêm phòng vào giỏ hàng...", "info")

        return true
    } catch (error) {
        console.error("Error handling room selection:", error)
        showNotification("Có lỗi xảy ra khi chọn phòng", "error")
        return false
}
}

/**
 * Handle combo selection
 * @param {number} comboId - ID of the selected combo
 */
function handleComboSelection(comboId) {
    try {
        showLoadingState(event.target)

        // Track combo selection
        trackEvent("combo_selected", {
            combo_id: comboId,
        })

        showNotification("Đang thêm tổ hợp phòng vào giỏ hàng...", "info")

        return true
    } catch (error) {
        console.error("Error handling combo selection:", error)
        showNotification("Có lỗi xảy ra khi chọn tổ hợp", "error")
        return false
    }
}

/**
 * Format currency for display
 * @param {number} amount - Amount to format
 * @param {string} currency - Currency code
 * @returns {string} Formatted currency string
 */
function formatCurrency(amount, currency = "USD") {
    try {
        return new Intl.NumberFormat("vi-VN", {
            style: "currency",
            currency: currency,
        }).format(amount)
    } catch (error) {
        return `${currency} ${amount}`
}
}

/**
 * Debounce function to limit function calls
 * @param {Function} func - Function to debounce
 * @param {number} wait - Wait time in milliseconds
 * @returns {Function} Debounced function
 */
function debounce(func, wait) {
    let timeout
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout)
            func(...args)
        }
        clearTimeout(timeout)
        timeout = setTimeout(later, wait)
    }
}

/**
 * Throttle function to limit function calls
 * @param {Function} func - Function to throttle
 * @param {number} limit - Time limit in milliseconds
 * @returns {Function} Throttled function
 */
function throttle(func, limit) {
    let inThrottle
    return function () {
        const args = arguments

        if (!inThrottle) {
            func.apply(this, args)
            inThrottle = true
            setTimeout(() => (inThrottle = false), limit)
        }
    }
}

// Add CSS animations for notifications
const style = document.createElement("style")
style.textContent = `
    @keyframes slideInRight {
        from {
            transform: translateX(100%);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
    
    @keyframes slideOutRight {
        from {
            transform: translateX(0);
            opacity: 1;
        }
        to {
            transform: translateX(100%);
            opacity: 0;
        }
    }
    
    .sr-only {
        position: absolute;
        width: 1px;
        height: 1px;
        padding: 0;
        margin: -1px;
        overflow: hidden;
        clip: rect(0, 0, 0, 0);
        white-space: nowrap;
        border: 0;
    }
`

var magnificPopupImageView = function () {
    if (checkSelectorExistence('.magnific-image')) {
        jQuery('.magnific-image').magnificPopup({
            type: 'image',
            gallery: {
                enabled: true
            }
        });
    }
};


  document.addEventListener("DOMContentLoaded", function() {
    const rows = document.querySelectorAll(".combo-row");
    const showMoreBtn = document.getElementById("showMoreBtn");
    const showLessBtn = document.getElementById("showLessBtn");
    const limit = 5;

    rows.forEach((row, idx) => {
      if (idx >= limit) row.style.display = "none";
    });

    if (rows.length <= limit) {
      showMoreBtn.style.display = "none";
    }

    window.showMoreCombos = function() {
      rows.forEach(row => row.style.display = "");
      showMoreBtn.style.display = "none";
      showLessBtn.style.display = "";
    };

    window.showLessCombos = function() {
      rows.forEach((row, idx) => {
        if (idx >= limit) row.style.display = "none";
      });
      showMoreBtn.style.display = "";
      showLessBtn.style.display = "none";
    };
  });

document.head.appendChild(style)

// Export functions for global access
window.switchTab = switchTab
window.toggleFilters = toggleFilters
window.handleRoomSelection = handleRoomSelection
window.handleComboSelection = handleComboSelection
window.showNotification = showNotification
window.formatCurrency = formatCurrency