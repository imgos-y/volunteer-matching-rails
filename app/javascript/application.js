// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener("turbo:load", () => {
    const toggle = document.querySelector(".navbar__toggle")
    const menu = document.querySelector("#navbar-menu")
    if (!toggle || !menu) return

    toggle.addEventListener("click", () => {
        const isOpen = menu.classList.toggle("is-open")
        toggle.setAttribute("aria-expanded", isOpen)
    })
})
