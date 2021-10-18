import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['list', 'toggleBtn']
  static values = {
    minHeight: Number,
    maxHeight: Number,
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
}
