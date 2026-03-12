import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="categorize"
export default class extends Controller {
  static targets = ["item", "timer", "score", "status", "startButton", "gameArea", "itemCard"]
  static values = { options: Object, gameId: Number }

  connect() {
    this.score = 0
    this.itemsLeft = []
    this.results = []
    this.isGameActive = false
    this.timerInterval = null
    this.timeLeft = this.optionsValue.time_limit || 30
    this.hasEngaged = false
    this.hasCompleted = false
    
    this.setupGame()
  }

  disconnect() {
    this.stopTimer()
  }

  setupGame() {
    this.itemsLeft = JSON.parse(JSON.stringify(this.optionsValue.items))
    this.shuffle(this.itemsLeft)
    this.score = 0
    this.results = []
    this.updateScoreDisplay()
    this.statusTarget.textContent = "Click 'Start Game' to begin!"
    this.timeLeft = this.optionsValue.time_limit || 30
    this.updateTimerDisplay()
    this.gameAreaTarget.style.display = "none"
    this.startButtonTarget.style.display = "block"
  }

  startGame() {
    this.isGameActive = true
    this.startButtonTarget.style.display = "none"
    this.gameAreaTarget.style.display = "block"
    this.statusTarget.textContent = ""
    this.startTimer()
    this.showNextItem()
    this.recordEvent("start")
  }

  startTimer() {
    this.updateTimerDisplay()
    this.timerInterval = setInterval(() => {
      this.timeLeft--
      this.updateTimerDisplay()
      if (this.timeLeft <= 0) {
        this.endGame(false)
      }
    }, 1000)
  }

  stopTimer() {
    if (this.timerInterval) {
      clearInterval(this.timerInterval)
      this.timerInterval = null
    }
  }

  updateTimerDisplay() {
    this.timerTarget.textContent = `Time: ${this.timeLeft}s`
    if (this.timeLeft <= 5) {
      this.timerTarget.style.color = "#dc2626"
    } else {
      this.timerTarget.style.color = "inherit"
    }
  }

  updateScoreDisplay() {
    this.scoreTarget.textContent = `Score: ${this.score}`
    this.statusTarget.textContent = `Current Sequence: ${this.results.join("")}`
  }

  showNextItem() {
    this.isProcessing = false
    if (this.itemsLeft.length === 0) {
      this.endGame(true)
      return
    }

    const currentItem = this.itemsLeft[0]
    this.itemCardTarget.innerHTML = `
      <div class="card" style="padding: 1rem; text-align: center; max-width: 250px; margin: 0 auto;">
        ${currentItem.image ? `<img src="${currentItem.image}" style="max-width: 100%; height: 150px; object-fit: cover; border-radius: 0.5rem; margin-bottom: 0.5rem;" />` : ''}
        <h4 style="margin: 0;">${currentItem.name}</h4>
      </div>
    `
    this.itemCardTarget.dataset.category = currentItem.category
  }

  selectCategory(event) {
    if (!this.isGameActive || this.isProcessing) return
    this.isProcessing = true

    const selectedCategoryId = event.currentTarget.dataset.categoryId
    const correctCategoryId = this.itemCardTarget.dataset.category

    if (selectedCategoryId === correctCategoryId) {
      const points = Number(this.optionsValue.points_per_item || 1)
      this.score += points
      this.results.push("1")
      this.updateScoreDisplay()
      
      // Visual feedback for correct choice
      const target = event.currentTarget
      target.style.backgroundColor = "#dcfce7"
      target.style.borderColor = "#22c55e"
      
      setTimeout(() => {
        if (target) {
          target.style.backgroundColor = "white"
          target.style.borderColor = ""
        }
        this.itemsLeft.shift()
        
        if (!this.hasEngaged && this.score >= 2) {
           this.hasEngaged = true
           this.recordEvent("engaged")
        }
        
        this.showNextItem()
      }, 500)
    } else {
      // Visual feedback for wrong choice
      this.results.push("0")
      this.updateScoreDisplay()
      const target = event.currentTarget
      target.classList.add("shake")
      target.style.backgroundColor = "#fee2e2"
      target.style.borderColor = "#ef4444"
      
      setTimeout(() => {
        if (target) {
          target.classList.remove("shake")
          target.style.backgroundColor = "white"
          target.style.borderColor = ""
        }
        
        // Even if wrong, proceed to next item but don't add points
        this.itemsLeft.shift()
        this.showNextItem()
      }, 500)
    }
  }

  endGame(completedAll) {
    this.isGameActive = false
    this.stopTimer()
    this.gameAreaTarget.style.display = "none"
    this.startButtonTarget.style.display = "block"
    this.startButtonTarget.textContent = "Play Again"

    if (completedAll) {
      this.statusTarget.textContent = `Great job! You categorized everything. Final Score: ${this.score}`
      if (!this.hasCompleted) {
        this.hasCompleted = true
        this.recordEvent("completed")
      }
    } else {
      this.statusTarget.textContent = `Time's up! Final Score: ${this.score}`
    }
  }

  shuffle(array) {
    for (let i = array.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [array[i], array[j]] = [array[j], array[i]]
    }
  }

  recordEvent(type) {
    if (!this.gameIdValue) return

    fetch("/events", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
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
