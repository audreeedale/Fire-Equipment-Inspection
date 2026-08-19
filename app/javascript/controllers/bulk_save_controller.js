import { Controller } from "@hotwired/stimulus"

// Submits every equipment-record row form within this controller's element,
// reusing each row's existing per-record turbo_stream save.
export default class extends Controller {
  saveAll() {
    this.element.querySelectorAll("form").forEach((form) => form.requestSubmit())
  }
}
