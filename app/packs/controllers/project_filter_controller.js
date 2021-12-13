import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
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
  }

  connect() {
    this.selectAllMaterialsTarget.indeterminate  = true;
    this.selectAllLocationsTarget.indeterminate  = true;
  }

  disconnect() {
  }

  remove(e) {
    e.target.parentNode.remove();
    e.preventDefault();
  }

  select_all_materials(e) {
    if(this.selectAllMaterialsTarget.checked) {
      this.selectMaterialItemTargets.map(function(t) { t.checked = true; });
    } else {
      this.selectMaterialItemTargets.map(function(t) { t.checked = false; });
    }
    e.preventDefault();
  }

  select_all_locations(e) {
    if(this.selectAllLocationsTarget.checked) {
      this.selectLocationItemTargets.map(function(t) { t.checked = true; });
    } else {
      this.selectLocationItemTargets.map(function(t) { t.checked = false; });
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
      this.locationDetailDivTarget.classList.add('hidden');
      this.additionalDivTarget.classList.add('hidden');
      this.areaBarOpenValue = false;
    } else {
      this.areaSpanTarget.classList.add('under-text-border');
      this.areaIconSvgTarget.innerHTML = `<path fill="currentColor" d="M20 16H4L12 8L20 16Z"></path>`;
      this.locationDetailDivTarget.classList.remove('hidden');
      this.additionalDivTarget.classList.remove('hidden');
      this.areaBarOpenValue = true;
    }
    console.log(this.areaBarOpenValue);
    e.preventDefault();
  }

  checkbox_submit(e) {
    const form = document.getElementById('project-form');
    form.submit();
  }

  clean_active(e) {
    this.matTypeLinkTargets.map(function(a) { a.classList.remove('font-bold'); });
  }
}
