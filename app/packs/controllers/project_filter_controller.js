import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['selectAll','selectItem']
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
    this.materialBarOpenValue = !this.materialBarOpenValue;
    console.log(this.materialBarOpenValue);
    e.preventDefault();
  }

  expend_area(e) {
    this.areaBarOpenValue = !this.areaBarOpenValue;
    console.log(this.areaBarOpenValue);
    e.preventDefault();
  }
}
