import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['dropdownMenu'];
  static values = {
    opening: Boolean
  };

  click(e) {
    if (this.openingValue) {
      this.close_menu(e);
    } else {
      this.open_menu(e);
    }
  }

  open_menu(e) {
    this.dropdownMenuTarget.classList.remove('hidden');
    this.openingValue = false;
    e.preventDefault();
  }

  close_menu(e) {
    this.dropdownMenuTarget.classList.add('hidden');
    this.openingValue = true;
    e.preventDefault();
  }
}
