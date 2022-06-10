import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['modal', 'modalForm', 'pmProjectsModal', 'matlibProjectsModal']

  showFormModal(e) {
    console.log(123)
    let modal = null;
    if (this.hasModalTarget) {
      modal = this.application.getControllerForElementAndIdentifier(this.modalTarget, 'modal');
    }
    if (modal) {
      modal.open(e);
    }
  }

  showPmProjectsModal(e) {
    let modal = null;
    if (this.hasPmProjectsModalTarget) {
      modal = this.application.getControllerForElementAndIdentifier(this.pmProjectsModalTarget, 'modal');
    }
    if (modal) {
      modal.open(e);
    }
  }

  showMatlibProjectsModal(e) {
    let modal = null;
    if (this.hasMatlibProjectsModalTarget) {
      modal = this.application.getControllerForElementAndIdentifier(this.matlibProjectsModalTarget, 'modal');
    }
    if (modal) {
      modal.open(e);
    }
  }
}
