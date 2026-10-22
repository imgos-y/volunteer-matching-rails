import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="nav"
export default class extends Controller {
  static targets = [ "button" , "menu"]

  toggle() {
    const isOpen = this.menuTarget.classList.toggle("is-open")
    this.buttonTarget.setAttribute("aria-expanded" , isOpen)
  }
}
