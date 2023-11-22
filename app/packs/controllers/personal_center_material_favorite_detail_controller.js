import { Controller } from '@hotwired/stimulus'
import mrujs from 'mrujs';

export default class extends Controller {
  static targets = [
    'list',
    'title',
    'exportBtn',
  ]

  static values = {
    favoriteId: Number,
    favorite: Object,
    favoriteSamples: Array,
  }

  connect() {
    window.addEventListener('MaterialFavoriteSamplesRefresh', this.refreshFavoriteSamples);
  }

  disconnect() {
    window.addEventListener('MaterialFavoriteSamplesRefresh', this.refreshFavoriteSamples);
  }

  favoriteSamplesValueChanged(favoriteSamples) {
    const html = favoriteSamples.map((favoriteSample, index) => `
      <tr>
        <td class="p-3 border">${index+1}</td>
        <td class="p-3 border">
          <button
            class="border border-gray-300 rounded-lg px-3 text-gray-400 hover:bg-black hover:text-white"
            data-id="${favoriteSample.id}"
            data-action="click->personal-center-material-favorite-detail#handleRemoveFavoriteSample"
          >删除</button>
        </td>
        <td class="p-3 border">
          <div class="whitespace-pre-wrap">${favoriteSample.part || ''}</div>
          <div>
            <a
              class="text-gray-400 hover:text-black transition-all inline-block mt-1"
              title="编辑"
              href="/material_favorites/${this.favoriteIdValue}/samples/${favoriteSample.id}/edit"
              data-turbo-frame="material_favorite_sample_edit_modal"
            >
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                <path d="M15.502 1.94a.5.5 0 0 1 0 .706L14.459 3.69l-2-2L13.502.646a.5.5 0 0 1 .707 0l1.293 1.293zm-1.75 2.456-2-2L4.939 9.21a.5.5 0 0 0-.121.196l-.805 2.414a.25.25 0 0 0 .316.316l2.414-.805a.5.5 0 0 0 .196-.12l6.813-6.814z"/>
                <path fill-rule="evenodd" d="M1 13.5A1.5 1.5 0 0 0 2.5 15h11a1.5 1.5 0 0 0 1.5-1.5v-6a.5.5 0 0 0-1 0v6a.5.5 0 0 1-.5.5h-11a.5.5 0 0 1-.5-.5v-11a.5.5 0 0 1 .5-.5H9a.5.5 0 0 0 0-1H2.5A1.5 1.5 0 0 0 1 2.5z"/>
              </svg>
            </a>
          </div>
        </td>
        <td class="p-3 border">${favoriteSample.materialName || ''}</td>
        <td class="p-3 border">
          ${favoriteSample.categoryName ? `
            <div>分类：${favoriteSample.categoryName}</div>
          ` : ''}
          ${favoriteSample.specModel ? `
            <div>型号：${favoriteSample.specModel}</div>
          ` : ''}
        </td>
        <td class="p-3 border">
          ${favoriteSample.pic ? `
            <img
              class="w-12 h-12 object-scale-down"
              src="${favoriteSample.pic}"
              alt=""
            >
          ` : ''}
        </td>
        <td class="p-3 border">150 - 230</td>
        <td class="p-3 border">
          ${favoriteSample.manufacturerUrl ? `
            <a
              class="underline underline-offset-2"
              href="${favoriteSample.manufacturerUrl}"
              target="_blank"
            >
              ${favoriteSample.manufacturerName}
            </a>
          ` : ''}
        </td>
      </tr>
    `).join('');
    this.listTarget.innerHTML = html;
  }

  favoriteIdValueChanged(favoriteId) {
    this.getFavorite(favoriteId);
    this.getFavoriteSamples(favoriteId);
  }

  favoriteValueChanged(favorite) {
    if (favorite.projectNo) {
      this.titleTarget.textContent = `${favorite.name}（${favorite.projectNo}-${favorite.projectName}）`;
    } else {
      this.titleTarget.textContent = favorite.name;
    }
    this.exportBtnTarget.style.display = favorite.total > 0 ? '' : 'none';
  }

  getFavorite = (favoriteId) => {
    mrujs.fetch(`/admin_api/thtri/inventories/folders/${favoriteId}`).then(res => res.json()).then(res => {
      if (res.code === 0) {
        this.favoriteValue = {
          id: res.data.ID,
          name: res.data.name,
          projectNo: res.data.projectNo,
          projectName: res.data.projectName,
          cover: res.data.isManualCover && res.data.cover?.[0] || '',
          total: res.data.total,
        };
      } else {
        console.error(res);
      }
    }).catch(err => {
      console.error(err);
    });
  }

  getFavoriteSamples = (favoriteId) => {
    mrujs.fetch(`/admin_api/thtri/inventories/folders/${favoriteId}/samples`).then(res => res.json()).then(res => {
      if (res.code === 0) {
        this.favoriteSamplesValue = res.data.list.map(item => ({
          id: item.ID,
          categoryName: item.categoryName,
          folderId: item.folderID,
          inventoryMaterialId: item.inventoryMaterialID,
          manufacturerName: item.manufacturerName,
          manufacturerUrl: item.manufacturerUrl,
          materialName: item.materialName,
          materialUrl: item.materialUrl,
          part: item.part,
          path: item.path,
          pic: item.pic,
          price: item.price,
          sampleId: item.sampleID,
          sampleType: item.sampleType,
          specModel: item.specModel,
        }));
      } else {
        console.error(res);
      }
    }).catch(err => {
      console.error(err);
    });
  }

  refreshFavoriteSamples = () => {
    this.getFavoriteSamples(this.favoriteIdValue);
  }

  handleRemoveFavoriteSample(e) {
    if (!confirm('确定要删除么？')) return;
    const id = e.target.dataset.id;
    this.removeFavoriteSample(id);
  }

  removeFavoriteSample = (id) => {
    mrujs.fetch(`/admin_api/thtri/inventories/folders/${this.favoriteIdValue}/samples/${id}`, {
      method: 'DELETE',
    }).then(res => res.json()).then(res => {
      if (res.code === 0) {
        this.refreshFavoriteSamples();
      } else {
        console.error(res);
      }
    }).catch(err => {
      console.error(err);
    });
  }
}
