import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  toggle(e) {
    if (e.target.dataset.toggleClass) {
      const toggleClass = e.target.dataset.toggleClass.split(' ');
      toggleClass.forEach(item => {
        if (e.target.classList.contains(item)) {
          e.target.classList.remove(item);
        } else {
          e.target.classList.add(item);
        }
      });
    }
  }
}
