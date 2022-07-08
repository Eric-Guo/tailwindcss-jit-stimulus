import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  connect() {}

  formSubmitSuccessRefresh(e) {
    if (e.detail.success) {
      this.refresh();
    }
  }

  refresh() {
    const src = this.element.getAttribute("src");
    if (src) {
      this.element.removeAttribute("src");
      this.element.setAttribute("src", src);
    }
  }

  load(src) {
    if (src) {
      this.element.setAttribute("src", src);
    }
  }

  disconnect() {}
}
