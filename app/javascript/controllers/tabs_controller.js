import { Controller } from "@hotwired/stimulus"

// Generic tab switcher: click a [data-tabs-target="tab"] button (with a
// data-tab-name) to show the [data-tabs-target="panel"] with the matching name.
export default class extends Controller {
  static targets = ["tab", "panel"]

  show(event) {
    const name = event.currentTarget.dataset.tabName

    this.tabTargets.forEach((tab) => {
      const active = tab.dataset.tabName === name
      tab.classList.toggle("bg-nav", active)
      tab.classList.toggle("text-white", active)
      tab.classList.toggle("text-muted", !active)
    })

    this.panelTargets.forEach((panel) => {
      panel.classList.toggle("hidden", panel.dataset.tabName !== name)
    })
  }
}
