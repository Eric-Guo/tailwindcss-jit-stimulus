import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    'activePanel',
    'selectMaterialItem',
    'materialSpan', 'materialIconSvg',
    'materialTypeDiv',
    'matTypeLink'
  ]
  static values = {
    materialBarOpen: Boolean,
    indeterminateMaterial: Boolean,
    indeterminateLocation: Boolean,
  }

  remove(e) {
    const check_id = e.target.dataset.checkId;
    const check_box = document.getElementById(check_id);
    if (check_box.tagName == "SELECT") {
      check_box.selectedIndex = -1;
    } else if (check_box.tagName == "INPUT") {
      check_box.value = "";
    } else {
      check_box.checked = false;
    }
    const form = document.getElementById('news-form');
    form.submit();
  }

  expend_material(e) {
    if (this.materialBarOpenValue) {
      this.closeMaterialPanel();
      this.activePanelTarget.value = '';
    } else {
      this.materialSpanTarget.classList.add('under-text-border');
      this.materialIconSvgTarget.innerHTML = `<path fill="currentColor" d="M20 16H4L12 8L20 16Z"></path>`;
      this.materialTypeDivTarget.classList.remove('hidden');
      this.materialBarOpenValue = true;
      this.activePanelTarget.value = 'material';
    }
    e.preventDefault();
  }

  checkbox_submit(e) {
    const form = document.getElementById('news-form');
    form.submit();
  }

  clean_active(e) {
    this.matTypeLinkTargets.map(function(a) { a.classList.remove('font-bold'); });
  }

  closeMaterialPanel() {
    this.materialSpanTarget.classList.remove('under-text-border');
    this.materialIconSvgTarget.innerHTML = `<path fill="currentColor" d="M20 8H4L12 16L20 8Z"></path>`;
    this.materialTypeDivTarget.classList.add('hidden');
    this.materialBarOpenValue = false;
  }
}
