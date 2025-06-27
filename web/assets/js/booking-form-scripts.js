/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


/**
 * Modern Booking Form JavaScript
 * Handles calendar, guest selection, and form interactions
 */

class BookingForm {
  constructor() {
    this.checkinDate = null
    this.checkoutDate = null
    this.adults = 1
    this.children = 0
    this.rooms = 1
    this.isSelectingCheckout = false

    this.init()
  }

  init() {
    this.setupEventListeners()
    this.setupStickyBehavior()
    this.generateCalendar()
    this.updateDisplay()
  }

  setupEventListeners() {
    // Date input clicks
    document.getElementById("dateInput")?.addEventListener("click", () => {
      this.toggleCalendar()
    })

    // Guest input clicks
    document.getElementById("guestInput")?.addEventListener("click", () => {
      this.toggleGuestDropdown()
    })

    // Calendar tab switching
    document.querySelectorAll(".calendar-tab").forEach((tab) => {
      tab.addEventListener("click", (e) => {
        this.switchCalendarTab(e.target.dataset.tab)
      })
    })

    // Guest counter buttons
    document.querySelectorAll(".guest-counter-btn").forEach((btn) => {
      btn.addEventListener("click", (e) => {
        const action = e.target.dataset.action
        const type = e.target.dataset.type
        this.updateGuestCount(type, action)
      })
    })

    // Close dropdowns when clicking outside
    document.addEventListener("click", (e) => {
      if (!e.target.closest(".booking-input-group")) {
        this.closeAllDropdowns()
      }
    })

    // Form submission
    document.getElementById("bookingForm")?.addEventListener("submit", (e) => {
      this.handleFormSubmit(e)
    })

    // Keyboard navigation
    document.addEventListener("keydown", (e) => {
      if (e.key === "Escape") {
        this.closeAllDropdowns()
      }
    })
  }

  setupStickyBehavior() {
    const bookingContainer = document.querySelector(".booking-form-container")
    if (!bookingContainer) return

    let lastScrollY = window.scrollY

    window.addEventListener(
      "scroll",
      () => {
        const currentScrollY = window.scrollY

        if (currentScrollY > 100) {
          bookingContainer.classList.add("scrolled")
        } else {
          bookingContainer.classList.remove("scrolled")
        }

        lastScrollY = currentScrollY
      },
      { passive: true },
    )
  }

  toggleCalendar() {
    const dropdown = document.getElementById("calendarDropdown")
    const input = document.getElementById("dateInput")

    if (dropdown && input) {
      const isActive = dropdown.classList.contains("active")

      this.closeAllDropdowns()

      if (!isActive) {
        dropdown.classList.add("active")
        input.classList.add("active")
        this.generateCalendar()
      }
    }
  }

  toggleGuestDropdown() {
    const dropdown = document.getElementById("guestDropdown")
    const input = document.getElementById("guestInput")

    if (dropdown && input) {
      const isActive = dropdown.classList.contains("active")

      this.closeAllDropdowns()

      if (!isActive) {
        dropdown.classList.add("active")
        input.classList.add("active")
      }
    }
  }

  closeAllDropdowns() {
    document.querySelectorAll(".calendar-dropdown, .guest-dropdown").forEach((dropdown) => {
      dropdown.classList.remove("active")
    })

    document.querySelectorAll(".booking-input-group").forEach((input) => {
      input.classList.remove("active")
    })
  }

  switchCalendarTab(tab) {
    document.querySelectorAll(".calendar-tab").forEach((t) => {
      t.classList.remove("active")
    })

    document.querySelector(`[data-tab="${tab}"]`).classList.add("active")

    if (tab === "flexible") {
      this.showFlexibleOptions()
    } else {
      this.generateCalendar()
    }
  }

  generateCalendar() {
    const calendarContent = document.getElementById("calendarContent")
    if (!calendarContent) return

    const today = new Date()
    const currentMonth = new Date(today.getFullYear(), today.getMonth(), 1)
    const nextMonth = new Date(today.getFullYear(), today.getMonth() + 1, 1)

    calendarContent.innerHTML = `
      <div class="calendar-months">
        ${this.generateMonthCalendar(currentMonth)}
        ${this.generateMonthCalendar(nextMonth)}
      </div>
    `

    // Add click listeners to calendar days
    document.querySelectorAll(".calendar-day:not(.disabled)").forEach((day) => {
      day.addEventListener("click", (e) => {
        this.selectDate(e.target.dataset.date)
      })
    })
  }

  generateMonthCalendar(date) {
    const monthNames = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ]

    const dayNames = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]

    const year = date.getFullYear()
    const month = date.getMonth()
    const firstDay = new Date(year, month, 1)
    const lastDay = new Date(year, month + 1, 0)
    const today = new Date()

    // Adjust first day to start from Monday
    const startDay = firstDay.getDay() === 0 ? 6 : firstDay.getDay() - 1

    let html = `
      <div class="calendar-month">
        <div class="month-title">${monthNames[month]} ${year}</div>
        <div class="calendar-grid">
    `

    // Day headers
    dayNames.forEach((day) => {
      html += `<div class="calendar-day-header">${day}</div>`
    })

    // Empty cells for days before month starts
    for (let i = 0; i < startDay; i++) {
      html += `<div class="calendar-day"></div>`
    }

    // Days of the month
    for (let day = 1; day <= lastDay.getDate(); day++) {
      const currentDate = new Date(year, month, day)
      const dateString = currentDate.toISOString().split("T")[0]
      const isToday = currentDate.toDateString() === today.toDateString()
      const isPast = currentDate < today && !isToday
      const isSelected = this.isDateSelected(dateString)
      const isInRange = this.isDateInRange(dateString)

      let classes = "calendar-day"
      if (isPast) classes += " disabled"
      if (isSelected) classes += " selected"
      if (isInRange) classes += " in-range"

      html += `
        <div class="${classes}" data-date="${dateString}" tabindex="0">
          ${day}
        </div>
      `
    }

    html += `
        </div>
      </div>
    `

    return html
  }

  selectDate(dateString) {
    const selectedDate = new Date(dateString)

    if (!this.checkinDate || this.isSelectingCheckout) {
      if (!this.checkinDate) {
        this.checkinDate = selectedDate
        this.isSelectingCheckout = true
      } else {
        if (selectedDate > this.checkinDate) {
          this.checkoutDate = selectedDate
          this.isSelectingCheckout = false
          this.closeAllDropdowns()
        } else {
          this.checkinDate = selectedDate
          this.checkoutDate = null
        }
      }
    } else {
      this.checkinDate = selectedDate
      this.checkoutDate = null
      this.isSelectingCheckout = true
    }

    this.updateDisplay()
    this.generateCalendar()
  }

  isDateSelected(dateString) {
    const date = new Date(dateString)
    return (
      (this.checkinDate && date.getTime() === this.checkinDate.getTime()) ||
      (this.checkoutDate && date.getTime() === this.checkoutDate.getTime())
    )
  }

  isDateInRange(dateString) {
    if (!this.checkinDate || !this.checkoutDate) return false

    const date = new Date(dateString)
    return date > this.checkinDate && date < this.checkoutDate
  }

  updateGuestCount(type, action) {
    const increment = action === "increment"

    switch (type) {
      case "adults":
        if (increment && this.adults < 20) {
          this.adults++
        } else if (!increment && this.adults > 1) {
          this.adults--
        }
        break
      case "children":
        if (increment && this.children < 10) {
          this.children++
        } else if (!increment && this.children > 0) {
          this.children--
        }
        break
      case "rooms":
        if (increment && this.rooms < 10) {
          this.rooms++
        } else if (!increment && this.rooms > 1) {
          this.rooms--
        }
        break
    }

    this.updateDisplay()
    this.updateGuestCounters()
  }

  updateGuestCounters() {
    document.getElementById("adultsCount").textContent = this.adults
    document.getElementById("childrenCount").textContent = this.children
    document.getElementById("roomsCount").textContent = this.rooms

    // Update button states
    document.querySelector('[data-type="adults"][data-action="decrement"]').disabled = this.adults <= 1
    document.querySelector('[data-type="children"][data-action="decrement"]').disabled = this.children <= 0
    document.querySelector('[data-type="rooms"][data-action="decrement"]').disabled = this.rooms <= 1
  }

  updateDisplay() {
    // Update date display
    const dateDisplay = document.getElementById("dateDisplay")
    if (dateDisplay) {
      if (this.checkinDate && this.checkoutDate) {
        const checkinStr = this.formatDate(this.checkinDate)
        const checkoutStr = this.formatDate(this.checkoutDate)
        dateDisplay.innerHTML = `
          <span>${checkinStr}</span>
          <span class="date-separator">—</span>
          <span>${checkoutStr}</span>
        `
      } else if (this.checkinDate) {
        dateDisplay.innerHTML = `
          <span>${this.formatDate(this.checkinDate)}</span>
          <span class="date-separator">— Add date</span>
        `
      } else {
        dateDisplay.innerHTML = "Check-in — Check-out"
      }
    }

    // Update guest display
    const guestDisplay = document.getElementById("guestDisplay")
    if (guestDisplay) {
      const totalGuests = this.adults + this.children
      const guestText = `${totalGuests} guest${totalGuests !== 1 ? "s" : ""}`
      const roomText = `${this.rooms} room${this.rooms !== 1 ? "s" : ""}`

      guestDisplay.innerHTML = `
        <div class="guest-count">${this.adults} adults • ${this.children} children • ${this.rooms} rooms</div>
      `
    }
  }

  formatDate(date) {
    const options = {
      weekday: "short",
      day: "numeric",
      month: "short",
    }
    return date.toLocaleDateString("en-US", options)
  }

  handleFormSubmit(e) {
    e.preventDefault()

    if (!this.checkinDate || !this.checkoutDate) {
      this.showError("Please select check-in and check-out dates")
      return
    }

    const formData = new FormData()
    formData.append("checkin", this.checkinDate.toISOString().split("T")[0])
    formData.append("checkout", this.checkoutDate.toISOString().split("T")[0])
    formData.append("guests", this.adults + this.children)
    formData.append("adults", this.adults)
    formData.append("children", this.children)
    formData.append("rooms", this.rooms)

    this.submitForm(formData)
  }

  submitForm(formData) {
    const form = document.getElementById("bookingForm")
    const submitBtn = document.querySelector(".booking-search-btn")

    // Show loading state
    form.classList.add("loading")
    submitBtn.classList.add("loading")
    submitBtn.textContent = "Searching..."

    // Convert FormData to URL parameters
    const params = new URLSearchParams()
    for (const [key, value] of formData) {
      params.append(key, value)
    }

    // Redirect to search results
    window.location.href = `FindAvailableRoomsServlet?${params.toString()}`
  }

  showError(message) {
    // Create or update error message
    let errorDiv = document.querySelector(".booking-error")
    if (!errorDiv) {
      errorDiv = document.createElement("div")
      errorDiv.className = "booking-error"
      document.querySelector(".booking-form-wrapper").appendChild(errorDiv)
    }

    errorDiv.innerHTML = `
      <div style="background: #fee; color: #c33; padding: 12px; border-radius: 8px; margin-top: 12px; text-align: center;">
        ${message}
      </div>
    `

    setTimeout(() => {
      errorDiv.remove()
    }, 5000)
  }

  showFlexibleOptions() {
    const calendarContent = document.getElementById("calendarContent")
    if (!calendarContent) return

    calendarContent.innerHTML = `
      <div style="text-align: center; padding: 40px;">
        <h3>Flexible dates coming soon!</h3>
        <p>We're working on flexible date options to help you find the best deals.</p>
      </div>
    `
  }
}

// Initialize booking form when DOM is loaded
document.addEventListener("DOMContentLoaded", () => {
  new BookingForm()
})

// Export for global access
window.BookingForm = BookingForm
