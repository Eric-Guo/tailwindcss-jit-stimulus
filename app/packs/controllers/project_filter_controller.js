import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['selectAll', 'selectItem', 'materialSpan', 'areaSpan']
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
      this.materialBarOpenValue = false;
    } else {
      this.materialSpanTarget.classList.add('under-text-border');
      this.materialBarOpenValue = true;
    }
    console.log(this.materialBarOpenValue);
    e.preventDefault();
  }

  expend_area(e) {
    if (this.areaBarOpenValue) {
      this.areaSpanTarget.classList.remove('under-text-border');
      this.areaBarOpenValue = false;
    } else {
      this.areaSpanTarget.classList.add('under-text-border');
      this.areaBarOpenValue = true;
    }
    console.log(this.areaBarOpenValue);
    e.preventDefault();
  }
}
