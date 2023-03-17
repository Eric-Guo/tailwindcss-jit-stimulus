import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['form']

  submit() {
    if (this.hasFormTarget) {
      const formData = new FormData(this.formTarget);
      const keys = [...formData.keys()].filter(item => /^cases/.test(item));
      if (keys.length === 0) {
        alert('案例不能为空');
        return;
      }
      if (keys.some(item => /\[name\]$/.test(item) && !formData.get(item).trim())) {
        alert('案例的项目名称不能为空');
        return;
      }
      const caseIds = Array.from(keys.reduce((set, item) => {
        const id = item.match(/^cases\[(\d+)\]/)[1];
        set.add(id);
        return set;
      }, new Set()));
      if (caseIds.some(item => !keys.some(it => it.startsWith(`cases[${item}][livePhotos]`)))) {
        alert('案例的项目图片不能为空');
        return;
      }
      this.formTarget.requestSubmit();
    }
  }
}
