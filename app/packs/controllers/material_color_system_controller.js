import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['list', 'toggleBtn', 'navItem', 'nav']
  static values = {
    minHeight: Number,
    maxHeight: Number,
  }

  connect() {
    const activeNavItem = this.getActiveNavItem();
    if (activeNavItem) {
      activeNavItem.scrollIntoView(false)
    }
  }
  
  getActiveNavItem() {
    return this.navItemTargets.find(item => item.classList.contains('active-pill'));
  }

  toggle() {
    const currentHeight = this.listTarget.offsetHeight;
    if (currentHeight === this.minHeightValue) {
      this.listTarget.style.height = `${this.maxHeightValue}px`;
      if (!this.toggleBtnTarget.classList.contains('rotate-180')) this.toggleBtnTarget.classList.add('rotate-180');
    } else {
      this.listTarget.style.height = `${this.minHeightValue}px`;
      if (this.toggleBtnTarget.classList.contains('rotate-180')) this.toggleBtnTarget.classList.remove('rotate-180');
    }
  }

  navScroll(e) {
    if (!e.altKey) {
      const scrollLeft = this.navTarget.scrollLeft;
      const scrollWidth = this.navTarget.scrollWidth;
      const width = this.navTarget.offsetWidth;
      if ((e.deltaY > 0 && width + scrollLeft < scrollWidth) || (e.deltaY < 0 && scrollLeft > 0)) {
        e.preventDefault();
        this.navTarget.scrollTo({ left: scrollLeft + e.deltaY, behavior: 'smooth' });
      }
    }
  }
}
