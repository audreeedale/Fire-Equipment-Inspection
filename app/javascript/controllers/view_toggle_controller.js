import { Controller } from "@hotwired/stimulus"

// Switches between two representations of the same list (e.g. cards vs table).
export default class extends Controller {
  static targets = ["cards", "table", "label"]

  toggle() {
    const showingCards = !this.cardsTarget.classList.contains("hidden")
    this.cardsTarget.classList.toggle("hidden", showingCards)
    this.tableTarget.classList.toggle("hidden", !showingCards)
    this.labelTarget.textContent = showingCards ? "Table view" : "Card view"
  }
}
