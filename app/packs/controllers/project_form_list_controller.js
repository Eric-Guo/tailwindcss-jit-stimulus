import { Controller } from '@hotwired/stimulus';
import { debounce } from 'lodash-es';

export default class extends Controller {
  static targets = [
    'form',
    'list',
    'submitBtn',
    'panel',
    'materialPanelControl',
    'materialPanel',
    'areaPanelControl',
    'areaPanel',
    'material1',
    'material2List',
    'materialAllCheckbox',
    'materialItemCheckbox',
    'areaAllCheckbox',
    'areaItemCheckbox',
  ]

  mat_ids = []
  material1Id = null
  material2s = []

  area_ids = []

  connect() {
    const activeMaterial1Target = this.material1Targets.find(item => item.classList.contains('font-bold'));
    if (activeMaterial1Target) {
      this.material1Id = activeMaterial1Target.dataset.id;
      this.setMaterial2s(JSON.parse(activeMaterial1Target.dataset.children));
    }
  }

  togglePanel(e) {
    const currentControl = e.currentTarget;
    const otherControl = this.materialPanelControlTarget === currentControl ? this.areaPanelControlTarget : this.materialPanelControlTarget;
    const currentPanel = this.materialPanelControlTarget === currentControl ? this.materialPanelTarget : this.areaPanelTarget;
    const otherPanel = this.materialPanelControlTarget === currentControl ? this.areaPanelTarget : this.materialPanelTarget;
    if (currentControl.dataset.expanded === 'true') {
      this.panelTarget.classList.add('hidden');
      currentControl.dataset.expanded = 'false';
      otherControl.dataset.expanded = 'false';
      currentPanel.classList.add('hidden');

      const span = currentControl.querySelector('span');
      const svg = currentControl.querySelector('svg');
      const otherSpan = otherControl.querySelector('span');
      const otherSvg = otherControl.querySelector('svg');

      span.classList.remove('under-text-border');
      svg.classList.remove('rotate-180');
      otherSpan.classList.remove('under-text-border');
      otherSvg.classList.remove('rotate-180');
    } else {
      this.panelTarget.classList.remove('hidden');
      currentControl.dataset.expanded = 'true';
      currentPanel.classList.remove('hidden');
      otherControl.dataset.expanded = 'false';
      otherPanel.classList.add('hidden');

      const span = currentControl.querySelector('span');
      const svg = currentControl.querySelector('svg');
      const otherSpan = otherControl.querySelector('span');
      const otherSvg = otherControl.querySelector('svg');

      span.classList.add('under-text-border');
      svg.classList.add('rotate-180');
      otherSpan.classList.remove('under-text-border');
      otherSvg.classList.remove('rotate-180');
    }
  }

  activeMaterial1(e) {
    const isActive = e.currentTarget.classList.contains('font-bold');
    if (!isActive) {
      this.material1Targets.forEach(item => item.classList.remove('font-bold'));
      e.currentTarget.classList.add('font-bold');
      this.material1Id = e.currentTarget.dataset.id;
      this.setMaterial2s(JSON.parse(e.currentTarget.dataset.children));
    }
  }

  setMaterial2s(data) {
    this.material2s = data;
    this.mat_ids = [];
    this.renderMaterial2s();
  }

  renderMaterial2s() {
    const html = this.material2s.map(item => `
      <div class="my-2.5 flex items-start">
        <input
          id="material_${item.id}"
          name="ms[]"
          value="${item.id}"
          type="checkbox"
          ${this.mat_ids.includes(item.id) ? 'checked' : ''}
          class="mt-1 focus:ring-gray-50 text-gray-600 border-gray-300"
          data-project-form-list-target="materialItemCheckbox"
          data-action="change->project-form-list#changeMaterialItemCheckbox"
        >
        <label for="material_${item.id}" class="text-gray-700 ml-2 mt-px">${item.title}</label>
      </div>
    `).join('');
    this.material2ListTarget.innerHTML = html;
    this.updateMaterialCheckboxStatus();
  }
  
  updateMaterialCheckboxStatus() {
    this.materialAllCheckboxTarget.disabled = this.materialItemCheckboxTargets.length === 0;
    if (this.mat_ids.length > 0) {
      if (this.mat_ids.length === this.materialItemCheckboxTargets.length) {
        this.materialAllCheckboxTarget.checked = true;
        this.materialAllCheckboxTarget.indeterminate = false;
      } else {
        this.materialAllCheckboxTarget.checked = false;
        this.materialAllCheckboxTarget.indeterminate = true;
      }
    } else {
      this.materialAllCheckboxTarget.checked = false;
      this.materialAllCheckboxTarget.indeterminate = false;
    }
  }

  changeMaterialItemCheckbox(e) {
    const id = Number(e.target.value);
    const checked = e.target.checked;
    if (checked) {
      if (!this.mat_ids.includes(id)) this.mat_ids.push(id);
    } else {
      this.mat_ids = this.mat_ids.filter(item => item != id);
    }
    this.updateMaterialCheckboxStatus();
    this.debounceSubmitForm();
  }

  changeMaterialAllCheckbox(e) {
    const checked = e.target.checked;
    this.mat_ids = checked ? this.material2s.map(item => item.id) : [];
    this.renderMaterial2s();
    this.debounceSubmitForm();
  }

  updateAreaCheckboxStatus() {
    this.areaAllCheckboxTarget.disabled = this.areaItemCheckboxTargets.length === 0;
    const checkedTarget = this.areaItemCheckboxTargets.filter(item => item.checked);
    if (checkedTarget.length > 0) {
      if (checkedTarget.length === this.areaItemCheckboxTargets.length) {
        this.areaAllCheckboxTarget.checked = true;
        this.areaAllCheckboxTarget.indeterminate = false;
      } else {
        this.areaAllCheckboxTarget.checked = false;
        this.areaAllCheckboxTarget.indeterminate = true;
      }
    } else {
      this.areaAllCheckboxTarget.checked = false;
      this.areaAllCheckboxTarget.indeterminate = false;
    }
  }

  changeAreaItemCheckbox() {
    this.updateAreaCheckboxStatus();
    this.debounceSubmitForm();
  }

  changeAreaAllCheckbox(e) {
    const checked = e.target.checked;
    this.areaItemCheckboxTargets.forEach(item => {
      item.checked = checked;
    });
    this.updateAreaCheckboxStatus();
    this.debounceSubmitForm();
  }

  debounceSubmitForm = debounce(this.submitForm, 300)

  submitForm() {
    this.formTarget.requestSubmit();
  }

  setFormPageSize(e) {
    const url = e.detail.url;
    const pageSize = url.searchParams.get('page_size') || '';
    const pageSizeInput = this.formTarget.querySelector('input[name=page_size]');
    if (pageSizeInput) pageSizeInput.value = pageSize;
  }
}
