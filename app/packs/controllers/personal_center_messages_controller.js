import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['modal', 'modalRmForm']
  
  setRmId(e) {
    const formPath = e.target.dataset.formPath;
    let modal = null;
    if (this.hasModalTarget) {
      modal = this.application.getControllerForElementAndIdentifier(this.modalTarget, 'modal');
    }
    if (modal) {
      modal.open(e);
    }
    if (formPath && this.hasModalRmFormTarget) {
      console.log(formPath);

      this.modalRmFormTarget.action = formPath;
    }
  }
}
