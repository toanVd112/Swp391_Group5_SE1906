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
    
    console.log("Hotel booking interface initialized successfully")
}

/**
 * Sticky action bar functionality
 */

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

/**
 * Validate date range
 */

/**
 * Setup date inputs with better UX


/**
 * Setup smooth scrolling for anchor links
 */


/**
 * Setup keyboard navigation
 */


/**
 * Setup loading states for forms
 */

/**
 * Show loading state on button
 * @param {HTMLElement} button - Button element to show loading state
 */

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


/**
 * Handle combo selection
 * @param {number} comboId - ID of the selected combo


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

/**
 * Throttle function to limit function calls
 * @param {Function} func - Function to throttle
 * @param {number} limit - Time limit in milliseconds
 * @returns {Function} Throttled function
 */


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
window.switchTab = switchTab;
window.toggleFilters = toggleFilters;
window.showNotification = showNotificatio