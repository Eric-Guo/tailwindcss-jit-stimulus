import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['dropdownMenu'];
  static values = {
    opening: Boolean
  };

  click(e) {
    if (this.openingValue) {
      this.close_menu();
      this.openingValue = false;
    } else {
      this.open_menu();
      this.openingValue = true;
    }
    e.preventDefault();
  }

  open_menu() {
    this.dropdownMenuTarget.classList.remove('hidden');
  }

  close_menu() {
    this.dropdownMenuTarget.classList.add('hidden');
  }
}
