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
    card.style.border = "2px solid #333"
    card.style.borderRadius = "8px"
    card.style.display = "flex"
    card.style.alignItems = "center"
    card.style.justifyContent = "center"
    card.style.cursor = "pointer"
    card.style.backgroundColor = "#ddd"
    card.style.fontSize = "14px"
    card.style.textAlign = "center"
    card.style.padding = "5px"
    
    card.innerHTML = `<span style="display: none;">${word}</span>`
    
    return card
  }

  flip(event) {
    if (this.lockBoard) return
    const clickedCard = event.currentTarget
    if (clickedCard === this.firstCard) return

    clickedCard.style.backgroundColor = "white"
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
    
    this.firstCard.style.borderColor = "green"
    this.secondCard.style.borderColor = "green"
    this.firstCard.style.backgroundColor = "#e6ffe6"
    this.secondCard.style.backgroundColor = "#e6ffe6"

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
      this.firstCard.style.backgroundColor = "#ddd"
      this.firstCard.querySelector("span").style.display = "none"
      this.secondCard.style.backgroundColor = "#ddd"
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
