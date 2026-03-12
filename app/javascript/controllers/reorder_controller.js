import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

// Connects to data-controller="reorder"
export default class extends Controller {
  static values = {
    url: String
  }

  connect() {
    try {
      this.sortable = Sortable.create(this.element, {
        animation: 150,
        ghostClass: "bg-gray-100",
        // handle: ".drag-handle", // Removed handle to allow dragging from anywhere in the item
        forceFallback: false,
        onEnd: this.onEnd.bind(this)
      })
      this.statusIndicator = this.element.querySelector('.status-indicator')
      this.isUpdating = false
    } catch (e) {
      console.error("Failed to initialize Sortable:", e)
    }
  }

  showStatus(type, text) {
    if (!this.statusIndicator) return
    this.statusIndicator.textContent = text
    this.statusIndicator.className = `status-indicator ${type}`
    
    if (type === 'saved') {
      setTimeout(() => {
        if (this.statusIndicator.classList.contains('saved')) {
          this.statusIndicator.style.display = 'none'
        }
      }, 3000)
    }
  }

  async onEnd(event) {
    if (this.isUpdating) return
    
    const items = Array.from(this.element.querySelectorAll('.reorder-item')).map((child, index) => {
      return {
        id: child.dataset.id,
        type: child.dataset.type,
        position: index + 1
      }
    })
    
    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content
    
    this.showStatus('saving', 'Saving order...')
    this.isUpdating = true

    try {
      const response = await fetch(this.urlValue, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "X-CSRF-Token": csrfToken
        },
        body: JSON.stringify({ positions: items })
      })

      if (response.ok) {
        this.showStatus('saved', 'Order saved!')
      } else {
        this.showStatus('error', 'Error saving order')
      }
    } catch (error) {
      console.error("Update failed:", error)
      this.showStatus('error', 'Network error')
    } finally {
      this.isUpdating = false
    }
  }

  disconnect() {
    this.sortable.destroy()
  }
}
