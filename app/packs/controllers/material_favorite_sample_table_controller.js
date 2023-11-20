import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    'selectAll',
    'selectItem',
  ]

  static values = {
    value: Array,
  }

  valueValueChanged(value) {
    this.selectItemTargets.forEach(item => {
      item.checked = value.includes(item.value);
    });
    if (value.length === this.selectItemTargets.length) {
      this.selectAllTarget.checked = true;
      this.selectAllTarget.indeterminate = false;
    } else if (value.length > 0) {
      this.selectAllTarget.checked = false;
      this.selectAllTarget.indeterminate = true;
    } else {
      this.selectAllTarget.checked = false;
      this.selectAllTarget.indeterminate = false;
    }
  }

  handleSelectAllChange(e) {
    if (e.target.checked) {
      this.valueValue = this.selectItemTargets.map(item => item.value);
    } else {
      this.valueValue = [];
    }
  }

  handleSelectItemChange(e) {
    const itemValue = e.target.value;
    if (e.target.checked) {
      if (!this.valueValue.includes(itemValue)) {
        this.valueValue = [...this.valueValue, itemValue];
      }
    } else {
      this.valueValue = this.valueValue.filter(value => value !== itemValue);
    }
  }
}
