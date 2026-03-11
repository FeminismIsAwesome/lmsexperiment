import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="memory-match"
export default class extends Controller {
  static targets = ["grid", "attempts", "status"]
  static values = { words: Array, gameId: Number }

  connect() {
    this.reset()
    this.hasEngaged = false
    this.hasCompleted = false
    this.recordEvent("start")
  }

  reset() {
    this.attempts = 0
    this.attemptsTarget.textContent = this.attempts
    this.statusTarget.textContent = ""
    this.firstCard = null
    this.secondCard = null
    this.lockBoard = false
    this.matches = 0
    
    this.setupGrid()
  }

  setupGrid() {
    const cards = [...this.wordsValue, ...this.wordsValue]
    this.shuffle(cards)
    
    this.gridTarget.innerHTML = ""
    cards.forEach((word, index) => {
      const card = this.createCardElement(word, index)
      this.gridTarget.appendChild(card)
    })
  }

  shuffle(array) {
    for (let i = array.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [array[i], array[j]] = [array[j], array[i]]
    }
  }

  createCardElement(word, index) {
    const card = document.createElement("div")
    card.classList.add("memory-card")
    card.dataset.word = word
    card.dataset.action = "click->memory-match#flip"
    
    card.style.height = "100px"
    card.style.border = "1px solid #e2e8f0"
    card.style.borderRadius = "0.5rem"
    card.style.display = "flex"
    card.style.alignItems = "center"
    card.style.justifyContent = "center"
    card.style.cursor = "pointer"
    card.style.backgroundColor = "white"
    card.style.color = "transparent"
    card.style.fontSize = "0.875rem"
    card.style.fontWeight = "500"
    card.style.textAlign = "center"
    card.style.padding = "0.5rem"
    card.style.boxShadow = "0 1px 2px 0 rgb(0 0 0 / 0.05)"
    card.style.transition = "all 0.2s"
    
    card.innerHTML = `<span style="display: none;">${word}</span>`
    
    return card
  }

  flip(event) {
    if (this.lockBoard) return
    const clickedCard = event.currentTarget
    if (clickedCard === this.firstCard) return

    clickedCard.style.backgroundColor = "white"
    clickedCard.style.color = "var(--primary-color)"
    clickedCard.style.borderColor = "var(--primary-color)"
    clickedCard.style.boxShadow = "var(--shadow-md)"
    clickedCard.querySelector("span").style.display = "block"

    if (!this.firstCard) {
      this.firstCard = clickedCard
      return
    }

    this.secondCard = clickedCard
    this.checkForMatch()
  }

  checkForMatch() {
    this.attempts++
    this.attemptsTarget.textContent = this.attempts
    
    if (this.attempts > 3 && !this.hasEngaged) {
      this.hasEngaged = true
      this.recordEvent("engaged")
    }

    const isMatch = this.firstCard.dataset.word === this.secondCard.dataset.word

    if (isMatch) {
      this.disableCards()
    } else {
      this.unflipCards()
    }
  }

  disableCards() {
    this.firstCard.removeEventListener("click", this.flip)
    this.secondCard.removeEventListener("click", this.flip)
    
    this.firstCard.style.borderColor = "#10b981"
    this.secondCard.style.borderColor = "#10b981"
    this.firstCard.style.backgroundColor = "#ecfdf5"
    this.secondCard.style.backgroundColor = "#ecfdf5"
    this.firstCard.style.color = "#059669"
    this.secondCard.style.color = "#059669"
    this.firstCard.style.cursor = "default"
    this.secondCard.style.cursor = "default"

    this.resetBoard()
    this.matches++
    
    if (this.matches === this.wordsValue.length) {
      this.statusTarget.textContent = "Congratulations! You matched them all!"
      if (!this.hasCompleted) {
        this.hasCompleted = true
        this.recordEvent("completed")
      }
    }
  }

  unflipCards() {
    this.lockBoard = true
    
    setTimeout(() => {
      this.firstCard.style.backgroundColor = "white"
      this.firstCard.style.color = "transparent"
      this.firstCard.style.borderColor = "#e2e8f0"
      this.firstCard.style.boxShadow = "var(--shadow-sm)"
      this.firstCard.querySelector("span").style.display = "none"
      
      this.secondCard.style.backgroundColor = "white"
      this.secondCard.style.color = "transparent"
      this.secondCard.style.borderColor = "#e2e8f0"
      this.secondCard.style.boxShadow = "var(--shadow-sm)"
      this.secondCard.querySelector("span").style.display = "none"
      
      this.resetBoard()
    }, 1000)
  }

  resetBoard() {
    this.firstCard = null
    this.secondCard = null
    this.lockBoard = false
  }

  recordEvent(type) {
    if (!this.gameIdValue) return

    fetch("/events", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')?.content
      },
      body: JSON.stringify({
        event: {
          game_id: this.gameIdValue,
          event_type: type
        }
      })
    })
  }
}
