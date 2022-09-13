import { Controller } from '@hotwired/stimulus';
import mrujs from 'mrujs';

export default class extends Controller {
  static targets = [
    'modal',
    'modalForm',
    'pmProjectsModal',
    'matlibProjectsModal',
    'addInternalCaseBtn',
    'casesInput',
    'casesContainer',
    'pmProjectRadio',
    'matlibProjectRadio',
  ]

  static values = {
    uploadImgPath: String,
    filePathPrefix: String,
  }

  casesData = []

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

  isThCoChange(e) {
    this.setInternalCaseStatus(e.params.value);
  }

  setInternalCaseStatus(status) {
    if (status) {
      this.addInternalCaseBtnTarget.classList.remove('hidden');
    } else {
      this.addInternalCaseBtnTarget.classList.add('hidden');
      this.casesData = this.casesData.filter(item => item.typeId !== 'pm');
      this.dispatchCasesChange();
    }
  }

  casesValueChange(e) {
    e.target.value = JSON.stringify(this.casesData);
    this.renderCases(this.casesData || []);
  }

  dispatchCasesChange() {
    const event = new InputEvent('change');
    this.casesInputTarget.dispatchEvent(event);
  }

  formSubmit(e) {
    const formData = new FormData(e.target);
    const names = [
      { key: 'name', title: '供应商名称' },
      { key: 'contactName', title: '联系人' },
      { key: 'materialID', title: '供应商类型' },
      { key: 'contactTel', title: '联系电话' },
      { key: 'cases', title: '供应商优秀案例' },
    ];
    for (const name of names) {
      const value = formData.get(name.key).trim();
      if (name.key === 'cases') {
        if (!value || /^\[\s*\]$/.test(value)) {
          e.preventDefault();
          alert(`${name.title}不能为空`);
          break;
        }
        const cases = JSON.parse(value);
        const isThCo = formData.get('isThCo') === 'true';
        let inCount = 0; // 内部案例数量
        let msg = '';
        for (const c of cases) {
          if (c.typeId !== 'thtri' && (!c.name || !c.name.trim())) {
            msg = '每个案例的项目名称不能为空';
            break;
          }
          if (!Array.isArray(c.livePhotos) || c.livePhotos.length === 0) {
            msg = '每个案例的项目图片至少上传一张图片';
            break;
          }
          if (c.typeId === 'pm') inCount++;
        }
        if (isThCo && inCount <= 0 && !msg) msg = '与天华合作过的供应商需要选择一个内部案例';
        if (msg) {
          e.preventDefault();
          alert(msg);
          break;
        }
      } else {
        if (!value) {
          e.preventDefault();
          alert(`${name.title}不能为空`);
          break;
        }
      }
    };
  }

  renderCases(data = []) {
    const html = data.map((item, index) => `
      <div class="first:mt-3 mb-3 pb-3 border-b border-gray-200">
        <div class="flex justify-between items-center">
          ${item.typeId === 'pm' ? `
            <label class="px-2 py-0.5 text-xs bg-black text-white rounded-lg">内部</label>
          ` : `
            <label class="px-2 py-0.5 text-xs bg-gray-200 text-gray-500 rounded-lg">外部</label>
          `}
          <button type="button" class="text-xs text-gray-500" data-personal-center-suppliers-index-param="${index}" data-action="click->personal-center-suppliers#removeCase">删除</button>
        </div>
        <div class="flex flex-row mt-1">
          <div class="flex-none flex flex-col gap-5" style="width: 228px;">
            ${item.typeId === 'pm' ? `
              <div>
                <label>项目编号:</label>
                <div class="border border-gray-300 bg-gray-200 h-7 leading-7 rounded px-2 text-gray-500 text-sm mt-1 truncate">
                  ${item.no}
                </div>
              </div>
              <div>
                <label>PM项目名称:</label>
                <div class="border border-gray-300 bg-gray-200 h-7 leading-7 rounded px-2 text-gray-500 text-sm mt-1 truncate" title="${item.pmProjectName}">
                  ${item.pmProjectName}
                </div>
              </div>
            ` : ''}
            ${item.typeId === 'thtri' ? `
              <div>
                <label>项目名称:</label>
                <div class="border border-gray-300 bg-gray-200 h-7 leading-7 rounded px-2 text-gray-500 text-sm mt-1 truncate" title="${item.name}">
                ${item.name}
                </div>
              </div>
            ` : `
              <div>
                <label><span class="text-red">*</span>项目名称:</label>
                <input
                  type="text"
                  class="w-full border border-gray-300 h-7 leading-7 rounded px-2 text-gray-500 focus:border-transparent focus:ring-black text-sm mt-1"
                  data-action="change->personal-center-suppliers#caseTextChange"
                  value="${item.name}"
                  data-personal-center-suppliers-index-param="${index}"
                  data-personal-center-suppliers-key-param="name"
                />
              </div>
            `}
          </div>
          <div class="flex-1" style="margin-left: 30px;">
            <label><span class="text-red">*</span>项目图片:</label>
            <div class="mt-1 grid grid-cols-3 gap-3">
              ${item.livePhotos.map((it, ind) => `
                <div class="relative" style="height: 180px;">
                  <img class="w-full h-full object-cover" src="${this.filePathPrefixValue}${it.path}" alt="${it.title}">
                  <div class="absolute top-0 left-0 w-full h-full opacity-0 hover:opacity-100">
                    <button
                      class="absolute top-2.5 right-2.5" title="删除"
                      data-action="click->personal-center-suppliers#caseRmLivePhoto"
                      data-personal-center-suppliers-index-param="${index}"
                      data-personal-center-suppliers-index2-param="${ind}"
                    >
                      <svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M8 15C11.866 15 15 11.866 15 8C15 4.13401 11.866 1 8 1C4.13401 1 1 4.13401 1 8C1 11.866 4.13401 15 8 15Z" fill="#101820"/>
                        <path d="M12.0898 7.41998H3.91992V8.59003H12.0898V7.41998Z" fill="white"/>
                      </svg>
                    </button>
                  </div>
                </div>
              `).join('')}
              <label class="flex justify-center items-center bg-gray-100 cursor-pointer" style="height: 180px;">
                <input class="hidden" type="file" accept="image/png, image/jpeg" multiple data-personal-center-suppliers-index-param="${index}" data-action="change->personal-center-suppliers#uploadImg" />
                <svg width="32" height="32" viewBox="0 0 12 12" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <path d="M6 12C9.31371 12 12 9.31371 12 6C12 2.68629 9.31371 0 6 0C2.68629 0 0 2.68629 0 6C0 9.31371 2.68629 12 6 12Z" fill="white"/>
                  <path d="M9.5 5.5H2.5V6.5H9.5V5.5Z" fill="#E0E0E0"/>
                  <path d="M6.5 2.5H5.5V9.5H6.5V2.5Z" fill="#E0E0E0"/>
                </svg>
              </label>
            </div>
          </div>
        </div>
      </div>
    `).join('');
    this.casesContainerTarget.innerHTML = html;
  }

  // 选择内部案例
  selectInternalCase(e) { 
    const activeRadio = this.pmProjectRadioTargets.find(item => item.checked);
    if (!activeRadio) return alert('请选择一个项目');
    const json = JSON.parse(decodeURIComponent(activeRadio.dataset.json));
    this.casesData = [
      ...this.casesData,
      {
        typeId: 'pm',
        name: json.title,
        pmProjectName: json.title,
        no: json.code,
        livePhotos: [], // { title: "title", path: "path" }[]
      }
    ];
    this.dispatchCasesChange();
    this.hidePmProjectsModal(e);
  }
  
  // 选择外部案例
  selectExternalCase(e) {
    const activeRadio = this.matlibProjectRadioTargets.find(item => item.checked);
    if (!activeRadio) return alert('请选择一个项目');
    const json = JSON.parse(decodeURIComponent(activeRadio.dataset.json));
    this.casesData = [
      ...this.casesData,
      {
        typeId: 'thtri',
        name: json.title,
        pmProjectName: json.title,
        no: json.code,
        caseID: json.id,
        livePhotos: [], // { title: "title", path: "path" }[]
      }
    ];
    this.dispatchCasesChange();
    this.hideMatlibProjectsModal(e);
  }

  // 添加外部案例
  addExternalCase() {
    this.casesData = [
      ...this.casesData,
      {
        typeId: 'add',
        name: '',
        pmProjectName: '',
        no: '',
        caseID: '',
        livePhotos: [], // { title: "title", path: "path" }[]
      }
    ];
    this.dispatchCasesChange();
  }

  removeCase({ params: { index } }) {
    if (confirm('确定要删除么？')) {
      this.casesData = this.casesData.filter((_, ind) => index !== ind);
      this.dispatchCasesChange();
    }
  }

  uploadImg({ params: { index }, target }) {
    const files = Array.from(target.files);
    files.forEach(file => {
      if (file) {
        const formData = new FormData();
        formData.append('file', file);
        mrujs.fetch(this.uploadImgPathValue, {
          body: formData,
          method: 'POST',
        })
        .then(res => res.json())
        .then(res => {
          this.casesData[index].livePhotos.push({
            title: res.name,
            path: res.url,
          });
          this.dispatchCasesChange();
        })
        .catch(err => alert(err.message));
      }
    });
    target.value = '';
  }

  caseTextChange({ params: { index, key }, target }) {
    this.casesData[index][key] = target.value;
    this.dispatchCasesChange();
  }

  caseRmLivePhoto({ params: { index, index2 } }) {
    if (confirm('确定要删除么？')) {
      this.casesData[index]['livePhotos'] = this.casesData[index]['livePhotos'].filter((_, ind) => ind !== index2);
      this.dispatchCasesChange();
    }
  }
}
