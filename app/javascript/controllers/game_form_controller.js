import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["memoryMatch", "categorize"]

  connect() {
    this.toggleFields()
  }

  toggleFields() {
    const select = this.element.querySelector("select[name='game[game_type]']")
    if (!select) return
    const type = select.value

    if (this.hasMemoryMatchTarget) {
      this.memoryMatchTarget.style.display = type === "memory_match" ? "block" : "none"
    }
    if (this.hasCategorizeTarget) {
      this.categorizeTarget.style.display = type === "categorize" ? "block" : "none"
    }
  }
}
