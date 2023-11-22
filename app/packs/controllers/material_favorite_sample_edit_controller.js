import { Controller } from "@hotwired/stimulus"
import mrujs from "mrujs"

export default class extends Controller {
  static targets = [
    'form',
    'submitBtn',
    'cancelBtn',
    'partInput',
  ]

  static values = {
    id: Number,
    favoriteId: Number,
    loading: Boolean,
    favoriteSample: Object,
  }

  getTurboModalController = () => {
    if (!this._turboModalController) {
      this._turboModalController = this.application.getControllerForElementAndIdentifier(this.element, 'turbo-modal');
    }
    return this._turboModalController;
  }

  getFavoriteSample = (id) => {
    mrujs.fetch(`/admin_api/thtri/inventories/folders/${this.favoriteIdValue}/samples/${id}`).then(res => res.json()).then(res => {
      if (res.code === 0) {
        this.favoriteSampleValue = {
          id: res.data.ID,
          folderId: res.data.folderID,
          inventoryMaterialId: res.data.inventoryMaterialID,
          materialName: res.data.materialName,
          part: res.data.part,
          sampleId: res.data.sampleID,
        };
      } else {
        console.error(res);
      }
    }).catch(err => {
      console.log(err);
    });
  }

  idValueChanged(id) {
    this.getFavoriteSample(id);
  }

  favoriteSampleValueChanged(favoriteSample) {
    this.partInputTarget.value = favoriteSample.part;
  }

  dispatchRefreshFavoriteSamples() {
    const event = new CustomEvent('MaterialFavoriteSamplesRefresh');
    window.dispatchEvent(event);
  }

  submit() {
    this.formTarget.requestSubmit();
  }

  handleFormSubmit(e) {
    e.preventDefault();
    if (!this.favoriteIdValue) return;
    const formData = new FormData(e.target);
    const part = formData.get('part').trim();
    if (!part) {
      alert('收藏夹名称不能为空');
      return;
    }
    this.loadingValue = true;
    mrujs.fetch(`/admin_api/thtri/inventories/folders/${this.favoriteIdValue}/samples/${this.idValue}`, {
      method: 'PATCH',
      body: JSON.stringify({
        part,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    }).then(res => res.json()).then(res => {
      if (res.code === 0) {
        const turboModalController = this.getTurboModalController();
        turboModalController.hide();
        this.dispatchRefreshFavoriteSamples();
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
