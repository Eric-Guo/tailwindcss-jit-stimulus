import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['modal', 'itemCheckbox', 'allCheckbox', 'idsInput', 'activeCount', 'rmButton', 'readButton']

  activeIds = []
  noReadIds = []

  connect() {
    this.allCheckboxTarget.disabled = this.itemCheckboxTargets.length === 0;
  }

  removeItems(e) {
    let modal = null;
    if (this.hasModalTarget) {
      modal = this.application.getControllerForElementAndIdentifier(this.modalTarget, 'modal');
    }
    if (modal) {
      modal.open(e);
    }
  }

  activeItemCheckbox({ target }) {
    const id = target.dataset.id;
    const isRead = target.dataset.isRead === 'true';
    if (target.checked) {
      if (!this.activeIds.includes(id)) this.activeIds.push(id);
      if (!isRead && !this.noReadIds.includes(id)) this.noReadIds.push(id);
    } else {
      this.activeIds = this.activeIds.filter(item => item !== id);
      if (!isRead) this.noReadIds = this.noReadIds.filter(item => item !== id);
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
    this.refreshButtonDisabled();
  }
  
  refreshButtonDisabled() {
    this.rmButtonTarget.disabled = this.activeIds.length === 0;
    this.readButtonTarget.disabled = this.noReadIds.length === 0;
  }

  activeAllCheckbox(e) {
    e.target.indeterminate = false;
    this.itemCheckboxTargets.forEach(item => {
      item.checked = e.target.checked;
      const id = item.dataset.id;
      const isRead = item.dataset.isRead === 'true';
      if (item.checked) {
        if (!this.activeIds.includes(id)) this.activeIds.push(id);
        if (!isRead && !this.noReadIds.includes(id)) this.noReadIds.push(id);
      } else {
        this.activeIds = this.activeIds.filter(it => it !== id);
        if (!isRead) this.noReadIds = this.noReadIds.filter(item => item !== id);
      }
    });
    this.refreshIdsInputValue();
  }
}
