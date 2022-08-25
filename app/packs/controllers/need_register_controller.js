import { Controller } from '@hotwired/stimulus'
import mrujs from "mrujs";

export default class extends Controller {
  static targets =  [
    'materialContainer',
    'referenceContainer',
  ]
  static values = {
    submitPath: String,
  }

  modalController = null

  connect() {
    this.modalController = this.application.getControllerForElementAndIdentifier(this.element, 'modal');
  }

  cateChange(e) {
    const materials = JSON.parse(e.target.dataset.materials);
    const select = this.materialContainerTarget.querySelector('select');
    if (select) {
      if (Array.isArray(materials) && materials.length > 0) {
        const html = materials.map(item => `<option value="${item.id}">${item.name}</option>`).join('');
        select.innerHTML = html;
        this.materialContainerTarget.classList.remove('hidden');
      } else {
        select.innerHTML = '';
        this.materialContainerTarget.classList.add('hidden');
      }
    }
  }

  getFiles = () => {
    if (!this.hasReferenceContainerTarget) return [];
    const referenceController = this.application.getControllerForElementAndIdentifier(this.referenceContainerTarget, 'reference-group');
    return referenceController.getFiles();
  };

  resetFiles = () => {
    if (!this.hasReferenceContainerTarget) return;
    const referenceController = this.application.getControllerForElementAndIdentifier(this.referenceContainer, 'reference-group');
    referenceController.reset();
  };

  getValues() {
    const cateElem = this.element.querySelector('input[type="radio"][name="cate"]:checked');
    const materialElem = this.element.querySelector('select[name="material"]');
    const descriptionElem = this.element.querySelector('textarea[name="description"]');

    return {
      cate: cateElem && cateElem.value,
      material: materialElem && materialElem.value,
      description: descriptionElem.value,
      files: this.getFiles(),
    };
  }

  clearValues() {
    const cateElem = this.element.querySelector('input[type="radio"][name="cate"]:checked');
    const descriptionElem = this.element.querySelector('textarea[name="description"]');
    const materialSelect = this.materialContainerTarget.querySelector('select');
    cateElem.checked = false
    descriptionElem.value = '';
    materialSelect.innerHTML = '';
    this.materialContainerTarget.classList.add('hidden');
    this.resetFiles();
  }

  submit() {
    if (this.modalController) {
      const values = this.getValues();
      if (!values.cate) return alert('需求类型不能为空');
      if (!values.description) return alert('具体描述不能为空');
      mrujs.fetch(this.submitPathValue, {
        method: 'POST',
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify(values),
      }).then(res => {
        if (res.status !== 200) throw new Error('提交失败');
        return res.json();
      }).then(res => {
        this.clearValues();
        this.modalController.close();
        alert('提交成功');
      }).catch(err => {
        console.log(err.message);
      });
    }
  }
}
