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
    favoriteId: Number,
    projects: Array,
    loading: Boolean,
    favorite: Object,
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

  getFavorite = (favoriteId) => {
    mrujs.fetch(`/admin_api/thtri/inventories/folders/${favoriteId}`).then(res => res.json()).then(res => {
      if (res.code === 0) {
        this.favoriteValue = {
          id: res.data.ID,
          name: res.data.name,
          projectNo: res.data.projectNo,
          projectName: res.data.projectName,
          cover: res.data.isManualCover && res.data.cover?.[0] || '',
        };
      } else {
        console.error(res);
      }
    }).catch(err => {
      console.error(err);
    });
  }

  favoriteIdValueChanged(favoriteId) {
    if (!favoriteId) return;
    this.getFavorite(favoriteId);
  }

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

  favoriteValueChanged(favorite) {
    if (!favorite || !favorite.id) return;
    this.nameInputTarget.value = favorite.name;
    const projectSearchSelectController = this.getProjectSearchSelectController();
    if (projectSearchSelectController) {
      if (favorite.projectNo) {
        projectSearchSelectController.optionItemsValue = [{ label: favorite.projectName, value: favorite.projectNo }];
      } else {
        this.getProjects();
      }
      projectSearchSelectController.valueValue = favorite.projectNo;
    }
    const coverPickerController = this.getCoverPickerController();
    if (coverPickerController) {
      coverPickerController.valueValue = favorite.cover;
    }
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
    if (!this.favoriteIdValue) return;
    const formData = new FormData(e.target);
    const name = formData.get('name').trim();
    const projectNo = formData.get('project_code').trim();
    if (!name) {
      alert('收藏夹名称不能为空');
      return;
    }
    const cover = formData.get('cover').trim();
    this.loadingValue = true;
    mrujs.fetch(`/admin_api/thtri/inventories/folders/${this.favoriteIdValue}`, {
      method: 'PATCH',
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
