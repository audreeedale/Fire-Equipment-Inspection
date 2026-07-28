import { Controller } from "@hotwired/stimulus"

// Filters [data-search-filter-target="item"] elements by their data-search
// attribute (falls back to text content) matching the input value.
export default class extends Controller {
  static targets = ["input", "item"]

  filter() {
    const query = this.inputTarget.value.toLowerCase().trim()

    this.itemTargets.forEach((item) => {
      const haystack = (item.dataset.search || item.textContent).toLowerCase()
      item.classList.toggle("hidden", !haystack.includes(query))
    })
  }
}
