import { Controller } from "@hotwired/stimulus"

// Submits the closest form as soon as this controller's element changes
// (e.g. a file input immediately uploading the moment a file is chosen).
export default class extends Controller {
  submit() {
    this.element.closest("form").requestSubmit()
  }
}
