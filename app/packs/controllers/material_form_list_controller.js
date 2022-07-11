import { Controller } from '@hotwired/stimulus';
import { debounce } from 'lodash-es';

export default class extends Controller {
  static targets = ['form', 'list', 'submitBtn', 'panel', 'material1', 'material2List', 'materialAllCheckbox', 'materialItemCheckbox']

  mat_ids = []
  material1Id = null
  material2s = []

  connect() {
    const activeMaterial1Target = this.material1Targets.find(item => item.classList.contains('font-bold'));
    if (activeMaterial1Target) {
      this.material1Id = activeMaterial1Target.dataset.id;
      this.setMaterial2s(JSON.parse(activeMaterial1Target.dataset.children));
    }
  }

  togglePanel(e) {
    const span = e.currentTarget.querySelector('span');
    const svg = e.currentTarget.querySelector('svg');
    if (this.panelTarget.classList.contains('hidden')) {
      this.panelTarget.classList.remove('hidden');
      span.classList.add('under-text-border');
      svg.classList.add('rotate-180');
    } else {
      this.panelTarget.classList.add('hidden');
      span.classList.remove('under-text-border');
      svg.classList.remove('rotate-180');
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
          data-material-form-list-target="materialItemCheckbox"
          data-action="change->material-form-list#changeMaterialItemCheckbox"
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
