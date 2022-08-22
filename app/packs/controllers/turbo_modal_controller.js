import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    autoShow: Boolean,
  };

  modal = null;
  turboFrameElem = null;

  connect() {
    this.element.style.background = "rgba(0, 0, 21, .5)";
    this.turboFrameElem = this.element.parentElement;
    this.modal = this.application.getControllerForElementAndIdentifier(this.element, 'modal');
    if (this.autoShowValue) this.show();
  }

  show = (e) => {
    this.modal.open(e || { target: document.documentElement, preventDefault: () => {} });
  };

  hide = (e) => {
    this.modal.close(e || { target: document.documentElement, preventDefault: () => {} });
    this.turboFrameElem.removeAttribute("src");
    this.element.remove();
  };

  hideHandle = (e) => {
    if (e.target === this.element) {
      this.turboFrameElem.removeAttribute("src");
    }
  };

  hiddenHandle = (e) => {
    if (e.target === this.element) {
      this.element.remove();
    }
  };

  formSubmitSuccessHide = (e) => {
    if (e.detail.success) {
      this.hide();
    }
  };

  disconnect() {
    this.turboFrameElem.removeAttribute("src");
  }
}
