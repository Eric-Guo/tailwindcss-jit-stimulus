import { Controller } from "@hotwired/stimulus"
import { debounce } from "lodash-es";
import mrujs from "mrujs";

export default class extends Controller {
  static targets = [
    'form',
    'projectSelect',
    'submitBtn',
    'cancelBtn',
  ]

  static values = {
    projects: Array,
    loading: Boolean,
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

  getFavoriteModalController = () => {
    if (!this._favoriteModalController) {
      this._favoriteModalController = this.application.getControllerForElementAndIdentifier(this.element, 'material-favorite-modal');
    }
    return this._favoriteModalController;
  }

  getFavoriteFormController = () => {
    if (!this._favoriteFormController) {
      this._favoriteFormController = this.application.getControllerForElementAndIdentifier(this.element, 'material-favorite-form');
    }
    return this._favoriteFormController;
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
    this.loadingValue = true;
    mrujs.fetch('/admin_api/thtri/inventories/folders', {
      method: 'POST',
      body: JSON.stringify({
        name,
        projectNo,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    }).then(res => res.json()).then(res => {
      if (res.code === 0) {
        const modalController = this.getFavoriteModalController();
        modalController.newFavoriteOpenValue = false;
        const formController = this.getFavoriteFormController();
        formController.getFavorites();
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
