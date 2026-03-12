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
        handle: ".drag-handle",
        forceFallback: true,
        onEnd: this.onEnd.bind(this)
      })
    } catch (e) {
      console.error("Failed to initialize Sortable:", e)
    }
  }

  onEnd(event) {
    const items = Array.from(this.element.querySelectorAll('.reorder-item')).map((child, index) => {
      return {
        id: child.dataset.id,
        type: child.dataset.type,
        position: index + 1
      }
    })
    
    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content

    fetch(this.urlValue, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-CSRF-Token": csrfToken
      },
      body: JSON.stringify({ positions: items })
    })
  }

  disconnect() {
    this.sortable.destroy()
  }
}
