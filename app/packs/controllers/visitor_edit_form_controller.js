import { Controller } from "@hotwired/stimulus";
import dayjs from "dayjs";

export default class extends Controller {
  static targets = ['form', 'lengthen', 'time', 'timeWrapper']

  lengthenChange() {
    if (!this.hasLengthenTarget || !this.hasTimeTarget || !this.hasTimeWrapperTarget) return;
    const lengthen = this.lengthenTarget.checked;
    if (lengthen) {
      this.timeTarget.disabled = false;
      this.timeWrapperTarget.classList.remove('hidden');
    } else {
      this.timeTarget.disabled = true;
      this.timeWrapperTarget.classList.add('hidden');
    }
  }

  submit() {
    if (this.hasFormTarget) {
      this.formTarget.requestSubmit();
    }
  }
}
