import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = [ "navbar" ]

  onScroll() {
    if (window.scrollY > 1) {
      this.navbarTarget.classList.add('sticky');
      this.navbarTarget.classList.add('bg-white');
      this.navbarTarget.classList.add('top-0');
      this.navbarTarget.classList.add('z-10');
      this.navbarTarget.classList.remove('text-white');
      this.navbarTarget.classList.add('text-black6c');
    } else {
      this.navbarTarget.classList.remove('text-black6c');
      this.navbarTarget.classList.add('text-white');
      this.navbarTarget.classList.remove('z-10');
      this.navbarTarget.classList.remove('top-0');
      this.navbarTarget.classList.remove('bg-white');
      this.navbarTarget.classList.remove('sticky');
    }
  }
}
