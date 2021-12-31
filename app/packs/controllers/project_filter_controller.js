import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    'activePanel',
    'selectAllMaterials', 'selectMaterialItem',
    'selectAllLocations', 'selectLocationItem',
    'materialSpan', 'areaSpan', 'materialIconSvg', 'areaIconSvg',
    'materialTypeDiv',
    'materialDetailDiv', 'locationDetailDiv', 'additionalDiv',
    'matTypeLink'
  ]

  static values = {
    materialBarOpen: Boolean,
    areaBarOpen: Boolean,
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
    const form = document.getElementById('project-form');
    form.submit();
  }

  select_all_materials(e) {
    if(this.selectAllMaterialsTarget.checked) {
      this.selectMaterialItemTargets.map(function(t) { t.checked = true; });
    } else {
      this.selectMaterialItemTargets.map(function(t) { t.checked = false; });
    }
    const form = document.getElementById('project-form');
    form.submit();
    e.preventDefault();
  }

  select_all_locations(e) {
    if(this.selectAllLocationsTarget.checked) {
      this.selectLocationItemTargets.map(function(t) { t.checked = true; });
    } else {
      this.selectLocationItemTargets.map(function(t) { t.checked = false; });
    }
    const form = document.getElementById('project-form');
    form.submit();
    e.preventDefault();
  }

  expend_material(e) {
    if (this.materialBarOpenValue) {
      this.closeMaterialPanel();
      this.additionalDivTarget.classList.add('hidden');
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
    this.closeAreaPanel();
    e.preventDefault();
  }

  expend_area(e) {
    if (this.areaBarOpenValue) {
      this.closeAreaPanel();
      this.additionalDivTarget.classList.add('hidden');
      this.activePanelTarget.value = '';
    } else {
      this.areaSpanTarget.classList.add('under-text-border');
      this.areaIconSvgTarget.innerHTML = `<path fill="currentColor" d="M20 16H4L12 8L20 16Z"></path>`;
      this.locationDetailDivTarget.classList.remove('hidden');
      this.additionalDivTarget.classList.remove('hidden');
      this.areaBarOpenValue = true;
      this.activePanelTarget.value = 'area';
    }
    this.closeMaterialPanel();
    e.preventDefault();
  }

  checkbox_submit(e) {
    const form = document.getElementById('project-form');
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
    this.materialBarOpenValue = false;
  }

  closeAreaPanel() {
    this.areaSpanTarget.classList.remove('under-text-border');
    this.areaIconSvgTarget.innerHTML = `<path fill="currentColor" d="M20 8H4L12 16L20 8Z"></path>`;
    this.locationDetailDivTarget.classList.add('hidden');
    this.areaBarOpenValue = false;
  }
}
