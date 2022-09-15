import { Controller } from '@hotwired/stimulus';
import mrujs from 'mrujs';

export default class extends Controller {
  static targets = [
    'modal',
    'pmProjectsModal',
    'matlibProjectsModal',
    'addInternalCaseBtn',
    'casesContainer',
    'pmProjectRadio',
    'matlibProjectRadio',
  ]

  static values = {
    createProjectPath: String,
    createProjectImagePath: String,
  }

  showPmProjectsModal(e) {
    let modal = null;
    if (this.hasPmProjectsModalTarget) {
      modal = this.application.getControllerForElementAndIdentifier(this.pmProjectsModalTarget, 'modal');
    }
    if (modal) {
      modal.open(e);
    }
  }

  hidePmProjectsModal(e) {
    let modal = null;
    if (this.hasPmProjectsModalTarget) {
      modal = this.application.getControllerForElementAndIdentifier(this.pmProjectsModalTarget, 'modal');
    }
    if (modal) {
      modal.close(e);
    }
  }

  showMatlibProjectsModal(e) {
    let modal = null;
    if (this.hasMatlibProjectsModalTarget) {
      modal = this.application.getControllerForElementAndIdentifier(this.matlibProjectsModalTarget, 'modal');
    }
    if (modal) {
      modal.open(e);
    }
  }

  hideMatlibProjectsModal(e) {
    let modal = null;
    if (this.hasMatlibProjectsModalTarget) {
      modal = this.application.getControllerForElementAndIdentifier(this.matlibProjectsModalTarget, 'modal');
    }
    if (modal) {
      modal.close(e);
    }
  }

  isThCoChange({ params: { value } }) {
    this.setInternalCaseStatus(value);
  }

  setInternalCaseStatus(status) {
    if (status) {
      this.addInternalCaseBtnTarget.classList.remove('hidden');
    } else {
      this.addInternalCaseBtnTarget.classList.add('hidden');
      Array.from(this.casesContainerTarget.children).forEach(elem => {
        if (elem.dataset.typeId === 'pm') elem.remove();
      });
    }
  }

  addCase(data) {
    const formData = new FormData();
    formData.append('type_id', data.typeId);
    formData.append('pm_project_name', data.pmProjectName);
    formData.append('name', data.name);
    formData.append('case_id', data.caseID);
    formData.append('no', data.no);
    mrujs.fetch(this.createProjectPathValue, {
      body: formData,
      method: 'POST',
    })
    .then(res => res.text())
    .then(res => {
      this.casesContainerTarget.insertAdjacentHTML('beforeend', res);
    })
    .catch(err => alert(err.message));
  }

  // 选择内部案例
  selectInternalCase(e) { 
    const activeRadio = this.pmProjectRadioTargets.find(item => item.checked);
    if (!activeRadio) return alert('请选择一个项目');
    const json = JSON.parse(decodeURIComponent(activeRadio.dataset.json));
    const data = {
      typeId: 'pm',
      name: json.title,
      pmProjectName: json.title,
      no: json.code,
      caseID: '',
      // livePhotos: [], // { title: "title", path: "path" }[]
    };
    this.addCase(data);
    this.hidePmProjectsModal(e);
  }
  
  // 选择外部案例
  selectExternalCase(e) {
    const activeRadio = this.matlibProjectRadioTargets.find(item => item.checked);
    if (!activeRadio) return alert('请选择一个项目');
    const json = JSON.parse(decodeURIComponent(activeRadio.dataset.json));
    const data = {
      typeId: 'thtri',
      name: json.title,
      pmProjectName: json.title,
      no: json.code,
      caseID: json.id,
      // livePhotos: [], // { title: "title", path: "path" }[]
    };
    this.addCase(data);
    this.hideMatlibProjectsModal(e);
  }

  // 添加外部案例
  addExternalCase() {
    const data = {
      typeId: 'add',
      name: '',
      pmProjectName: '',
      no: '',
      caseID: '',
      // livePhotos: [], // { title: "title", path: "path" }[]
    };
    this.addCase(data);
  }

  removeCase({ params: { hashCode } }) {
    if (confirm('确定要删除么？')) {
      Array.from(this.casesContainerTarget.children).forEach(elem => {
        if (elem.dataset.hashCode === hashCode.toString()) elem.remove();
      });
    }
  }

  createProjectImage({ params: { hashCode }, target }) {
    const files = Array.from(target.files);
    files.forEach(file => {
      if (file) {
        const formData = new FormData();
        formData.append('file', file);
        formData.append('hash_code', hashCode.toString());
        mrujs.fetch(this.createProjectImagePathValue, {
          body: formData,
          method: 'POST',
        })
        .then(res => res.text())
        .then(res => {
          target.parentElement.insertAdjacentHTML('beforebegin', res);
        })
        .catch(err => alert(err.message));
      }
    });
    target.value = '';
  }

  caseRmLivePhoto({ currentTarget }) {
    if (confirm('确定要删除么？')) {
      currentTarget.parentElement.parentElement.remove();
    }
  }
}
