import { Controller } from "@hotwired/stimulus";
import dayjs from "dayjs";

export default class extends Controller {
  static targets = ['form', 'timeType', 'time']

  timeTypeChange() {
    if (!this.hasTimeTypeTarget || !this.hasTimeTarget) return;
    const timeType = this.timeTypeTarget.value;
    switch(timeType) {
      case 'today': {
        this.timeTarget.readOnly = true;
        this.timeTarget.value = dayjs().format('YYYY-MM-DD');
        break;
      }
      case 'week': {
        this.timeTarget.readOnly = true;
        this.timeTarget.value = dayjs().day(7).format('YYYY-MM-DD');
        break;
      }
      case 'month': {
        this.timeTarget.readOnly = true;
        this.timeTarget.value = dayjs().endOf('month').format('YYYY-MM-DD');
        break;
      }
      default: {
        this.timeTarget.readOnly = false;
      }
    }
  }

  submit() {
    if (this.hasFormTarget) {
      this.formTarget.requestSubmit();
    }
  }
}
