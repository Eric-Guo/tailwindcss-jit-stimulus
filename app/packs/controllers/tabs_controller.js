import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['tab', 'tabContent'];
  static values = {
    defaultTabName: String,
    tabActiveClass: String,
  };

  connect() {
    this.setTabActive(this.defaultTabNameValue);
  }

  activeTab(e) {
    const tabName = e.currentTarget.dataset.tabName;
    this.setTabActive(tabName);
  }

  setTabActive(tabName) {
    if (tabName) {
      const tabActClass = this.tabActiveClassValue.split(' ');
      this.tabTargets.forEach(elem => {
        if (elem.dataset.tabName === tabName) {
          tabActClass.forEach(item => elem.classList.add(item));
        } else {
          tabActClass.forEach(item => elem.classList.remove(item));
        }
      });
      this.tabContentTargets.forEach(elem => {
        if (elem.dataset.tabName === tabName) {
          elem.style.display = '';
        } else {
          elem.style.display = 'none';
        }
      });
    }
  }

  disconnect() { }
}
