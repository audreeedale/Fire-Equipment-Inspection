import { Controller } from "@hotwired/stimulus"

// Shows/hides equipment-category-specific fields on the asset form based on
// the selected category, since the spreadsheet columns vary by equipment type.
export default class extends Controller {
  static targets = ["field", "categorySelect"]

  connect() {
    this.toggle()
  }

  toggle() {
    const category = this.categorySelectTarget.value

    this.fieldTargets.forEach((field) => {
      const categories = field.dataset.categories.split(" ")
      field.classList.toggle("hidden", !categories.includes(category))
    })
  }
}
