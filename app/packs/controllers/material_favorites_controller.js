import { Controller } from "@hotwired/stimulus"
import { debounce } from "lodash-es";
import mrujs from "mrujs";

export default class extends Controller {
  static targets = [
    'form',
    'projectSelect',
    'submitBtn',
    'cancelBtn',
    'nameInput',
    'coverPicker',
  ]

  static values = {
    projects: Array,
    loading: Boolean,
    favorite: Object,
  }

  connect() {
    this.getProjects();
  }

  getProjectSearchSelectController = () => {
    if (!this._projectSearchSelectController) {
      this._projectSearchSelectController = this.application.getControllerForElementAndIdentifier(this.projectSelectTarget, 'search-select');
    }
    return this._projectSearchSelectController;
  }

  getCoverPickerController = () => {
    if (!this._coverPickerController) {
      this._coverPickerController = this.application.getControllerForElementAndIdentifier(this.coverPickerTarget, 'drag-upload');
    }
    return this._coverPickerController;
  }

  getTurboModalController = () => {
    if (!this._turboModalController) {
      this._turboModalController = this.application.getControllerForElementAndIdentifier(this.element, 'turbo-modal');
    }
    return this._turboModalController;
  }

  getProjects = debounce((keywords = '') => {
    const url = new URL('/admin_api/thtri/projects', window.location.origin);
    url.searchParams.append('page', '1');
    url.searchParams.append('pageSize', '10');
    url.searchParams.append('keywords', keywords);
    mrujs.fetch(url.toString()).then(res => res.json()).then(res => {
      if (res.code === 0) {
        this.projectsValue = (res.data.list || []).map(project => ({
          id: project.ID,
          name: project.projectName,
          code: project.projectCode,
        }));
      } else {
        console.error(res);
      }
    }).catch((reason) => {
      console.error(reason);
    });
  }, 300)

  projectsValueChanged(projects) {
    const selectController = this.getProjectSearchSelectController();
    if (!selectController) return;
    selectController.optionItemsValue = projects.map(project => ({
      label: project.name,
      value: project.code,
    }));
  }

  loadingValueChanged(loading) {
    this.submitBtnTarget.disabled = loading;
    this.cancelBtnTarget.disabled = loading;
  }

  handleSearchProjects(e) {
    const keywords = e.target.value.trim();
    this.getProjects(keywords);
  }

  dispatchRefreshFavorites() {
    const event = new CustomEvent('MaterialFavoritesRefresh');
    window.dispatchEvent(event);
  }

  submit() {
    this.formTarget.requestSubmit();
  }

  handleFormSubmit(e) {
    e.preventDefault();
    const formData = new FormData(e.target);
    const name = formData.get('name').trim();
    const projectNo = formData.get('project_code').trim();
    if (!name) {
      alert('收藏夹名称不能为空');
      return;
    }
    const cover = formData.get('cover').trim();
    this.loadingValue = true;
    mrujs.fetch(`/admin_api/thtri/inventories/folders`, {
      method: 'POST',
      body: JSON.stringify({
        name,
        projectNo,
        cover,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    }).then(res => res.json()).then(res => {
      if (res.code === 0) {
        const turboModalController = this.getTurboModalController();
        turboModalController.hide();
        this.dispatchRefreshFavorites();
        setTimeout(() => {
          alert('更新成功');
        }, 200);
      } else {
        console.error(res);
      }
    }).catch((reason) => {
      console.error(reason);
    }).finally(() => {
      this.loadingValue = false;
    });
  }
}
