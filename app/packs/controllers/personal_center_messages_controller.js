import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['modal', 'modalRmForm', 'itemCheckbox', 'allCheckbox', 'idsInput', 'activeCount']

  activeIds = []

  removeItems(e) {
    let modal = null;
    if (this.hasModalTarget) {
      modal = this.application.getControllerForElementAndIdentifier(this.modalTarget, 'modal');
    }
    if (modal) {
      modal.open(e);
    }
    if (this.hasModalRmFormTarget) {
      this.modalRmFormTarget.action = formPath;
    }
  }

  activeItemCheckbox({ target }) {
    const id = target.dataset.id;
    if (target.checked) {
      if (!this.activeIds.includes(id)) this.activeIds.push(id);
    } else {
      this.activeIds = this.activeIds.filter(item => item !== id);
    }
    this.refreshAllCheckbox();
  }

  refreshAllCheckbox() {
    if (this.activeIds.length > 0) {
      if (this.activeIds.length === this.itemCheckboxTargets.length) {
        this.allCheckboxTarget.indeterminate = false;
        this.allCheckboxTarget.checked = true;
      } else {
        this.allCheckboxTarget.indeterminate = true;
        this.allCheckboxTarget.checked = false;
      }
    } else {
      this.allCheckboxTarget.indeterminate = false;
      this.allCheckboxTarget.checked = false;
    }
    this.refreshIdsInputValue();
  }

  refreshIdsInputValue() {
    this.idsInputTargets.forEach(item => {
      item.value = this.activeIds.join(',');
    });
    this.activeCountTarget.textContent = this.activeIds.length;
  }

  activeAllCheckbox(e) {
    e.target.indeterminate = false;
    this.itemCheckboxTargets.forEach(item => {
      item.checked = e.target.checked;
      const id = item.dataset.id;
      if (item.checked) {
        if (!this.activeIds.includes(id)) this.activeIds.push(id);
      } else {
        this.activeIds = this.activeIds.filter(it => it !== id);
      }
    });
    this.refreshIdsInputValue();
  }
}
