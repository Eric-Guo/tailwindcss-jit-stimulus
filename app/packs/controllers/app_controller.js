import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  openNeedRegisterModal(e) {
    const modalElems = Array.from(document.querySelectorAll('[data-controller~="modal"]'));
    const needRegisterModalElem = modalElems.find(elem => elem.dataset.controller.includes('need-register'));
    if (needRegisterModalElem) {
      const slideoverElems = Array.from(document.querySelectorAll('[data-controller~="slideover"]'));
      modalElems.forEach(elem => {
        if (elem !== needRegisterModalElem) {
          const modalController = this.application.getControllerForElementAndIdentifier(elem, 'modal');
          if (modalController && modalController.containerTarget) modalController.close();
        }
      });
      slideoverElems.forEach(elem => {
        const slideoverController = this.application.getControllerForElementAndIdentifier(elem, 'slideover');
        if (slideoverController) slideoverController.openValue = false;
      });
      const needRegisterModalController = this.application.getControllerForElementAndIdentifier(needRegisterModalElem, 'modal');
      if (needRegisterModalController && needRegisterModalController.containerTarget) needRegisterModalController.open(e);
    }
  }
}
