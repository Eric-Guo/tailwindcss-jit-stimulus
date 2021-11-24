import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    'selectAll', 'selectItem', 'materialSpan', 'areaSpan', 'materialIconSvg', 'areaIconSvg',
    'materialTypeDiv', 'materialDetailDiv', 'additionalDiv'
  ]
  static values = {
    materialBarOpen: Boolean,
    areaBarOpen: Boolean,
  }

  connect() {
    this.selectAllTarget.indeterminate  = true;
  }

  disconnect() {
  }

  remove(e) {
    e.target.parentNode.remove();
    e.preventDefault();
  }

  select_all(e) {
    if(this.selectAllTarget.checked) {
      this.selectItemTargets.map(function(t) { t.checked = true; });
    } else {
      this.selectItemTargets.map(function(t) { t.checked = false; });
    }
    e.preventDefault();
  }

  expend_material(e) {
    if (this.materialBarOpenValue) {
      this.materialSpanTarget.classList.remove('under-text-border');
      this.materialIconSvgTarget.innerHTML = `<path fill="currentColor" d="M20 8H4L12 16L20 8Z"></path>`;
      this.materialTypeDivTarget.classList.add('hidden');
      this.materialDetailDivTarget.classList.add('hidden');
      this.materialBarOpenValue = false;
    } else {
      this.materialSpanTarget.classList.add('under-text-border');
      this.materialIconSvgTarget.innerHTML = `<path fill="currentColor" d="M20 16H4L12 8L20 16Z"></path>`;
      this.materialTypeDivTarget.classList.remove('hidden');
      this.materialDetailDivTarget.classList.remove('hidden');
      this.materialBarOpenValue = true;
    }
    console.log(this.materialBarOpenValue);
    e.preventDefault();
  }

  expend_area(e) {
    if (this.areaBarOpenValue) {
      this.areaSpanTarget.classList.remove('under-text-border');
      this.areaIconSvgTarget.innerHTML = `<path fill="currentColor" d="M20 8H4L12 16L20 8Z"></path>`;
      this.additionalDivTarget.classList.add('hidden');
      this.areaBarOpenValue = false;
    } else {
      this.areaSpanTarget.classList.add('under-text-border');
      this.areaIconSvgTarget.innerHTML = `<path fill="currentColor" d="M20 16H4L12 8L20 16Z"></path>`;
      this.additionalDivTarget.classList.remove('hidden');
      this.areaBarOpenValue = true;
    }
    console.log(this.areaBarOpenValue);
    e.preventDefault();
  }
}
