import { Controller } from '@hotwired/stimulus';
import mrujs from 'mrujs';

export default class extends Controller {
  static targets = [
    'modal',
    'modalForm',
    'pmProjectsModal',
    'matlibProjectsModal',
    'detailModal',
    'addInternalCaseBtn',
    'casesInput',
    'casesContainer',
    'pmProjectsSearchInput',
    'pmProjectsContainer',
    'pmPagesContainer',
    'pmProjectRadio',
    'matlibProjectsSearchInput',
    'matlibProjectsContainer',
    'matlibPagesContainer',
    'matlibProjectRadio',
  ]

  static values = {
    uploadImgPath: String,
    pmProjectsPath: String,
    matlibProjectsPath: String,
    filePathPrefix: String,
  }

  casesData = []

  showFormModal(e) {
    let modal = null;
    if (this.hasModalTarget) {
      modal = this.application.getControllerForElementAndIdentifier(this.modalTarget, 'modal');
    }
    if (modal) {
      modal.open(e);
    }
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

  showDetailModal(e) {
    let modal = null;
    if (this.hasDetailModalTarget) {
      modal = this.application.getControllerForElementAndIdentifier(this.detailModalTarget, 'modal');
    }
    if (modal) {
      modal.open(e);
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
      { key: 'reason', title: '推荐理由' },
      { key: 'materialID', title: '供应商类型' },
      { key: 'contactTel', title: '联系电话' },
      { key: 'cases', title: '供应商优秀案例' },
    ];
    for (const name of names) {
      const value = formData.get(name.key).trim();
      if (!value || (name.key === 'cases' && /^\[\s*\]$/.test(value))) {
        e.preventDefault();
        alert(`${name.title}不能为空`);
        break;
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
                <div class="border border-gray-300 bg-gray-200 h-8 rounded px-2 py-1.5 text-gray-500 text-sm mt-1 truncate">
                  ${item.no}
                </div>
              </div>
              <div>
                <label>PM项目名称:</label>
                <div class="border border-gray-300 bg-gray-200 h-8 rounded px-2 py-1.5 text-gray-500 text-sm mt-1 truncate" title="${item.pmProjectName}">
                  ${item.pmProjectName}
                </div>
              </div>
            ` : ''}
            ${item.typeId === 'add' ? `
              <label>
                <span>项目名称:</span>
                <input
                  type="text"
                  class="border border-gray-300 h-8 rounded px-2 text-gray-500 focus:border-none focus:ring-black mt-1"
                  data-action="change->personal-center-suppliers#caseTextChange"
                  value="${item.name}"
                  data-personal-center-suppliers-index-param="${index}"
                  data-personal-center-suppliers-key-param="name"
                />
              </label>
            ` : `
              <div>
                <label>项目名称:</label>
                <div class="border border-gray-300 bg-gray-200 h-8 rounded px-2 py-1.5 text-gray-500 text-sm mt-1 truncate" title="${item.name}">
                  ${item.name}
                </div>
              </div>
            `}
          </div>
          <div class="flex-1" style="margin-left: 30px;">
            <label>实景照:</label>
            <div class="mt-1 grid grid-cols-3 gap-3">
              ${item.livePhotos.map(it => `
                <div style="height: 180px;">
                  <img class="w-full h-full object-cover" src="${this.filePathPrefixValue}${it.path}" alt="${it.title}">
                </div>
              `).join('')}
              <label class="flex justify-center items-center bg-gray-100 cursor-pointer" style="height: 180px;">
                <input class="hidden" type="file" accept="image/png, image/jpeg" data-personal-center-suppliers-index-param="${index}" data-action="change->personal-center-suppliers#uploadImg" />
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
    const file = target.files[0];
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
    target.value = '';
  }

  caseTextChange({ params: { index, key }, target }) {
    this.casesData[index][key] = target.value;
    this.dispatchCasesChange();
  }

  pmProjectInputEnter(e) {
    if (['Enter', 'NumpadEnter'].includes(e.code)) {
      this.searchPmProjects();
    }
  }

  searchPmProjects() {
    const keywords = this.pmProjectsSearchInputTarget.value.trim();
    this.fetchPmProjects({ keywords, page: 1, pageSize: 10 });
  }

  fetchPmProjects({ keywords = '', page = 1, pageSize = 10 }) {
    if (!keywords) return alert('请输入关键词搜索！');
    const url = new URL(this.pmProjectsPathValue, window.location.origin);
    url.searchParams.set('page', page);
    url.searchParams.set('pageSize', pageSize);
    url.searchParams.set('keywords', keywords);
    mrujs.fetch(url.toString(), {
      method: 'GET',
    })
    .then(res => res.json())
    .then(res => {
      this.renderPmProjects(res.list);
      this.renderPages(this.pmPagesContainerTarget, {
        page,
        pageSize,
        total: res.total,
        type: 'pmProjects',
        keywords,
      });
    })
    .catch(err => alert(err.message));
  }

  renderPmProjects(projects = []) {
    const html = projects.map(project => `
      <tr class="border-b">
        <td class="text-base">
          <div class="flex items-center justify-center">
            <div class="matlib-form-radio icon-checked">
              <input
                type="radio"
                value="${project.code}"
                name="pm_project_code"
                id="pm_project_${project.code}"
                data-personal-center-suppliers-target="pmProjectRadio"
                data-json="${encodeURIComponent(JSON.stringify(project))}"
              />
              <label for="pm_project_${project.code}"></label>
            </div>
          </div>
        </td>
        <td class="py-5 truncate">${project.code}</td>
        <td class="py-5 truncate">${project.title}</td>
        <td class="py-5 truncate">${project.company}</td>
        <td class="py-5 truncate">${project.department}</td>
      </tr>
    `).join('');
    this.pmProjectsContainerTarget.innerHTML = html;
  }

  getPagination(page = 1, pageSize = 10, total = 0, showPages = 5) {
    const pageTotal = Math.ceil(total / pageSize)
    let minPageRange = page,
        maxPageRange = page,
        leftShowPages = Math.ceil((showPages - 1) / 2),
        rightShowPages = showPages - leftShowPages - 1;
    if (page + rightShowPages > pageTotal) {
      leftShowPages += (page + rightShowPages - pageTotal)
    }
    while (leftShowPages > 0) {
      minPageRange -= 1
      if (minPageRange <= 1) {
        minPageRange = 1
        rightShowPages += leftShowPages
        leftShowPages = 0
      } else {
        leftShowPages -= 1
      }
    }
    while (rightShowPages > 0) {
      maxPageRange += 1
      if (maxPageRange >= pageTotal) {
        maxPageRange = pageTotal
        rightShowPages = 0
      } else {
        rightShowPages -= 1
      }
    }
    return {
      pageTotal: pageTotal,
      range: new Array(maxPageRange - minPageRange + 1).fill(null).map((_, i) => minPageRange + i),
      firstPage: minPageRange > 1 && 1,
      lastPage: maxPageRange < pageTotal && pageTotal,
      backward: page > 1,
      backwardMore: minPageRange > 2 && (page - showPages >= 1 ? page - showPages : 1),
      forward: page < pageTotal,
      forwardMore: maxPageRange < pageTotal - 1 && (page + showPages <= pageTotal ? page + showPages : pageTotal ),
    };
  }

  renderPages(container, { page = 1, pageSize = 10, total = 0, showPages = 5, keywords = '', type = '' }) {
    if (!container) return;
    const pagination = this.getPagination(page, pageSize, total, showPages);
    const html = `
      <ul class="flex justify-end items-center gap-1 text-sm">
        <li class="text-gray-400">总计 ${total} 条结果</li>
        <li
          class="px-1 h-6 flex items-center rounded ${pagination.backward ? 'hover:text-white hover:bg-gray-200 cursor-pointer' : 'text-gray-300 cursor-not-allowed'}"
          data-personal-center-suppliers-type-param="${type}"
          data-personal-center-suppliers-page-param="${page - 1}"
          data-personal-center-suppliers-keywords-param="${keywords}"
          ${pagination.backward ? `data-action="click->personal-center-suppliers#changePage"` : ''}
        >
          <svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" fill="currentColor" viewBox="0 0 16 16">
            <path fill-rule="evenodd" d="M11.354 1.646a.5.5 0 0 1 0 .708L5.707 8l5.647 5.646a.5.5 0 0 1-.708.708l-6-6a.5.5 0 0 1 0-.708l6-6a.5.5 0 0 1 .708 0z" />
          </svg>
        </li>
        ${pagination.firstPage ? `
          <li
            class="px-2 h-6 flex items-center rounded hover:text-white hover:bg-gray-200 cursor-pointer"
            data-personal-center-suppliers-type-param="${type}"
            data-personal-center-suppliers-page-param="${pagination.firstPage}"
            data-personal-center-suppliers-keywords-param="${keywords}"
            data-action="click->personal-center-suppliers#changePage"
          >${pagination.firstPage}</li>
        ` : ''}
        ${pagination.backwardMore ? `
          <li
            class="px-2 h-6 flex items-center rounded hover:text-white hover:bg-gray-200 cursor-pointer"
            data-personal-center-suppliers-type-param="${type}"
            data-personal-center-suppliers-page-param="${pagination.backwardMore}"
            data-personal-center-suppliers-keywords-param="${keywords}"
            data-action="click->personal-center-suppliers#changePage"
          >...</li>
        ` : ''}
        ${pagination.range.map((p) => `
          <li
            class="px-2 h-6 flex items-center rounded ${page === p ? 'text-white bg-gray-400 cursor-default' : 'text-black bg-white hover:text-white hover:bg-gray-200 cursor-pointer'}"
            data-personal-center-suppliers-type-param="${type}"
            data-personal-center-suppliers-page-param="${p}"
            data-personal-center-suppliers-keywords-param="${keywords}"
            ${page === p ? '' : `data-action="click->personal-center-suppliers#changePage"`}
          >${p}</li>
        `).join('')}
        ${pagination.forwardMore ? `
          <li
            class="px-2 h-6 flex items-center rounded hover:text-white hover:bg-gray-200 cursor-pointer"
            data-personal-center-suppliers-type-param="${type}"
            data-personal-center-suppliers-page-param="${pagination.forwardMore}"
            data-personal-center-suppliers-keywords-param="${keywords}"
            data-action="click->personal-center-suppliers#changePage"
          >...</li>
        ` : ''}
        ${pagination.lastPage ? `
          <li
            class="px-2 h-6 flex items-center rounded hover:text-white hover:bg-gray-200 cursor-pointer"
            data-personal-center-suppliers-type-param="${type}"
            data-personal-center-suppliers-page-param="${pagination.lastPage}"
            data-personal-center-suppliers-keywords-param="${keywords}"
            data-action="click->personal-center-suppliers#changePage"
          >${pagination.lastPage}</li>
        ` : ''}
        <li
          class="px-1 h-6 flex items-center rounded ${pagination.forward ? 'hover:text-white hover:bg-gray-200 cursor-pointer' : 'text-gray-300 cursor-not-allowed'}"
          data-personal-center-suppliers-type-param="${type}"
          data-personal-center-suppliers-page-param="${page + 1}"
          data-personal-center-suppliers-keywords-param="${keywords}"
          ${pagination.forward ? `data-action="click->personal-center-suppliers#changePage"` : ''}
        >
          <svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" fill="currentColor" viewBox="0 0 16 16">
            <path fill-rule="evenodd" d="M4.646 1.646a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1 0 .708l-6 6a.5.5 0 0 1-.708-.708L10.293 8 4.646 2.354a.5.5 0 0 1 0-.708z" />
          </svg>
        </li>
      </ul>
    `;
    container.innerHTML = html;
  }

  changePage({ params }) {
    if (params.type === 'pmProjects') {
      this.fetchPmProjects({ keywords: params.keywords, page: params.page });
    }
    if (params.type === 'matlibProjects') {
      this.fetchMatlibProjects({ keywords: params.keywords, page: params.page });
    }
  }

  matlibProjectInputEnter(e) {
    if (['Enter', 'NumpadEnter'].includes(e.code)) {
      this.searchMatlibProjects();
    }
  }

  searchMatlibProjects() {
    const keywords = this.matlibProjectsSearchInputTarget.value.trim();
    this.fetchMatlibProjects({ keywords, page: 1, pageSize: 10 });
  }

  fetchMatlibProjects({ keywords = '', page = 1, pageSize = 10 }) {
    if (!keywords) return alert('请输入关键词搜索！');
    const url = new URL(this.matlibProjectsPathValue, window.location.origin);
    url.searchParams.set('page', page);
    url.searchParams.set('pageSize', pageSize);
    url.searchParams.set('keywords', keywords);
    mrujs.fetch(url.toString(), {
      method: 'GET',
    })
    .then(res => res.json())
    .then(res => {
      this.renderMatlibProjects(res.list);
      this.renderPages(this.matlibPagesContainerTarget, {
        page,
        pageSize,
        total: res.total,
        type: 'matlibProjects',
        keywords,
      });
    })
    .catch(err => alert(err.message));
  }

  renderMatlibProjects(projects = []) {
    const html = projects.map(project => `
      <tr class="border-b">
        <td class="text-base">
          <div class="flex items-center justify-center">
            <div class="matlib-form-radio icon-checked">
              <input
                type="radio"
                value="${project.code}"
                name="matlib_project_code"
                id="matlib_project_${project.id}"
                data-personal-center-suppliers-target="matlibProjectRadio"
                data-json="${encodeURIComponent(JSON.stringify(project))}"
              />
              <label for="matlib_project_${project.id}"></label>
            </div>
          </div>
        </td>
        <td class="py-5 truncate">${project.title}</td>
        <td class="py-5 truncate">
          <div class="bg-gray-300" style="width: 140px; height: 105px;"></div>
        </td>
      </tr>
    `).join('');
    this.matlibProjectsContainerTarget.innerHTML = html;
  }
}
