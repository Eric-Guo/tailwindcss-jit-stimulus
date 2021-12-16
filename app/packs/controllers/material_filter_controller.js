import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    'activePanel',
    'selectAllMaterials', 'selectMaterialItem',
    'selectAllLocations', 'selectLocationItem',
    'materialSpan', 'materialIconSvg',
    'materialTypeDiv',
    'materialDetailDiv', 'additionalDiv',
    'matTypeLink'
  ]
  static values = {
    materialBarOpen: Boolean,
    indeterminateMaterial: Boolean,
    indeterminateLocation: Boolean,
  }

  connect() {
    if (this.indeterminateMaterialValue) {
      this.selectAllMaterialsTarget.indeterminate  = true;
    }
    if (this.indeterminateLocationValue) {
      this.selectAllLocationsTarget.indeterminate  = true;
    }
  }

  disconnect() {
  }

  remove(e) {
    const check_box = document.getElementById(e.target.dataset.checkId);
    check_box.checked = false;
    const form = document.getElementById('material-form');
    form.submit();
  }

  select_all_materials(e) {
    if(this.selectAllMaterialsTarget.checked) {
      this.selectMaterialItemTargets.map(function(t) { t.checked = true; });
    } else {
      this.selectMaterialItemTargets.map(function(t) { t.checked = false; });
    }
    const form = document.getElementById('material-form');
    form.submit();
    e.preventDefault();
  }

  select_all_locations(e) {
    if(this.selectAllLocationsTarget.checked) {
      this.selectLocationItemTargets.map(function(t) { t.checked = true; });
    } else {
      this.selectLocationItemTargets.map(function(t) { t.checked = false; });
    }
    const form = document.getElementById('material-form');
    form.submit();
    e.preventDefault();
  }

  expend_material(e) {
    if (this.materialBarOpenValue) {
      this.closeMaterialPanel();
      this.activePanelTarget.value = '';
    } else {
      this.materialSpanTarget.classList.add('under-text-border');
      this.materialIconSvgTarget.innerHTML = `<path fill="currentColor" d="M20 16H4L12 8L20 16Z"></path>`;
      this.materialTypeDivTarget.classList.remove('hidden');
      this.materialDetailDivTarget.classList.remove('hidden');
      this.additionalDivTarget.classList.remove('hidden');
      this.materialBarOpenValue = true;
      this.activePanelTarget.value = 'material';
    }
    e.preventDefault();
  }

  checkbox_submit(e) {
    const form = document.getElementById('material-form');
    form.submit();
  }

  clean_active(e) {
    this.matTypeLinkTargets.map(function(a) { a.classList.remove('font-bold'); });
  }

  closeMaterialPanel() {
    this.materialSpanTarget.classList.remove('under-text-border');
    this.materialIconSvgTarget.innerHTML = `<path fill="currentColor" d="M20 8H4L12 16L20 8Z"></path>`;
    this.materialTypeDivTarget.classList.add('hidden');
    this.materialDetailDivTarget.classList.add('hidden');
    this.additionalDivTarget.classList.add('hidden');
    this.materialBarOpenValue = false;
  }
}
