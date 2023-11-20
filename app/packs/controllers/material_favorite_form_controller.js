import { Controller } from "@hotwired/stimulus"
import mrujs from "mrujs";

export default class extends Controller {
  static targets = [
    'form',
    'favoriteSelect',
    'sampleTable',
    'projectCode',
    'projectName',
    'submitBtn',
    'cancelBtn',
  ]

  static values = {
    materialId: Number,
    favorites: Array,
    currentFavoriteId: Number,
    loading: Boolean,
  }

  /**
   * 样品表格控制器
   */
  sampleTableController = null

  turboModalController = null

  connect() {
    this.getFavorites();
  }

  /**
   * 获取样品表格控制器
   */
  getSampleTableController = () => {
    if (!this.sampleTableController) {
      this.sampleTableController = this.application.getControllerForElementAndIdentifier(this.sampleTableTarget, 'material-favorite-sample-table');
    }
    return this.sampleTableController;
  }

  getTurboModalController = () => {
    if (!this.turboModalController) {
      this.turboModalController = this.application.getControllerForElementAndIdentifier(this.element, 'turbo-modal');
    }
    return this.turboModalController;
  }

  /**
   * 获取收藏夹列表
   */
  getFavorites() {
    mrujs.fetch('/admin_api/thtri/inventories/folders').then(res => res.json()).then(res => {
      if (res.code === 0) {
        this.favoritesValue = res.data.list.map(item => ({
          id: item.ID,
          name: item.name,
          projectName: item.projectName,
          projectNo: item.projectNo,
        }));
        this.currentFavoriteIdValue = this.favoritesValue[0].id;
      } else {
        console.error(res);
      }
    }).catch((reason) => {
      console.error(reason);
    });
  }

  /**
   * 获取样品列表
   * @param {number} materialId 
   */
  getSamples(materialId) {
    mrujs.fetch(`/admin_api/thtri/materials/${materialId}/samples`).then(res => res.json()).then(res => {
      if (res.code === 0) {

      } else {

      }
    }).catch((reason) => {
      console.error(reason);
    });
  }

  /**
   * 获取材料样品选择情况
   * @param {number} favoriteId 
   * @param {number} materialId 
   */
  getInventories(favoriteId, materialId) {
    mrujs.fetch(`/admin_api/thtri/inventories/folders/${favoriteId}/materials/${materialId}`).then(res => res.json()).then(res => {
      if (res.code === 0) {
        const sampleTableController = this.getSampleTableController();
        sampleTableController.valueValue = res.data.samples.filter(item => Boolean(item.sampleID)).map(item => item.sampleID.toString());
      } else {
        console.error(res);
      }
    }).catch((reason) => {
      console.error(reason);
    });
  }

  materialIdValueChanged(materialId) {
    this.getSamples(materialId);
  }

  currentFavoriteIdValueChanged(favoriteId) {
    if (favoriteId) {
      this.getInventories(favoriteId, this.materialIdValue);
    }
    const favorite = this.favoritesValue.find(item => item.id === favoriteId);
    this.projectCodeTarget.value = favorite?.projectNo || '';
    this.projectNameTarget.value = favorite?.projectName || '';
  }

  favoritesValueChanged(favorites) {
    this.favoriteSelectTarget.innerHTML = '';
    favorites.forEach(favorite => {
      const option = document.createElement('option');
      option.value = favorite.id;
      option.textContent = favorite.name;
      this.favoriteSelectTarget.appendChild(option);
    });
  }

  loadingValueChanged(loading) {
    this.submitBtnTarget.disabled = loading;
    this.cancelBtnTarget.disabled = loading;
  }

  handleFavoriteChange(e) {
    this.currentFavoriteIdValue = e.target.value;
  }

  submit() {
    this.formTarget.requestSubmit();
  }

  handleFormSubmit(e) {
    e.preventDefault();
    const formData = new FormData(e.target);
    const favoriteId = formData.get('favorite_id');
    const sampleTableController = this.getSampleTableController();
    const sampleIds = sampleTableController.valueValue;
    this.loadingValue = true;
    mrujs.fetch(`/admin_api/thtri/inventories/folders/${favoriteId}/materials`, {
      method: 'POST',
      body: JSON.stringify({
        materialId: this.materialIdValue,
        inventorySamples: sampleIds.map(item => ({
          sampleID: Number(item),
        })),
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    }).then(res => res.json()).then(res => {
      if (res.code === 0) {
        const turboModalController = this.getTurboModalController();
        turboModalController.hide();
        setTimeout(() => {
          window.alert('收藏成功！');
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
