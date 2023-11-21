import { Controller } from '@hotwired/stimulus'
import mrujs from 'mrujs';

export default class extends Controller {
  static targets = [
    'list'
  ]

  static values = {
    favorites: Array,
  }

  connect() {
    this.getFavorites();
    window.addEventListener('MaterialFavoritesRefresh', this.getFavorites);
  }

  favoritesValueChanged(favorites) {
    this.listTarget.innerHTML = '';
    const html = favorites.map(favorite => {
      const cover = (favorite.cover || []).filter(Boolean);
      const coverHtml = cover.length > 0 ? cover.map(img => `
        <div class="material-favorite-cover-item">
          <img src="${img.replace(/(?<!\:)\/\//g, '/')}" alt="" class="w-full h-full object-cover" />
        </div>
      `).join('') : `<div class="material-favorite-cover-item bg-neutral-200"></div>`;

      return `
        <div class="relative">
          <div class="material-favorite-cover aspect-[4/3]">
            ${coverHtml}
          </div>
          <div class="mt-4">
            <div class="text-base">${favorite.name}</div>
            <div class="text-sm flex justify-between items-center">
              <div>收藏材料数量：${favorite.total}</div>
              <div class="flex gap-2">
                ${favorite.total > 0 ? `<a
                  class="text-gray-400 px-2 py-1 border border-gray-400 rounded-[10px] hover:text-white hover:bg-black hover:border-white transition-all"
                  href="/admin_api/thtri/inventories/folders/${favorite.id}/samples/exportExcel"
                  target="_blank"
                >
                  导出excel材料清单
                </a>` : ''}
                <button
                  class="text-gray-400 px-2 py-1 border border-gray-400 rounded-[10px] hover:text-white hover:bg-black hover:border-white transition-all"
                  data-id="${favorite.id}"
                  data-action="click->personal-center-material-favorites#handleRemoveFavorite"
                >
                  删除
                </button>
              </div>
            </div>
          </div>
          <a class="absolute top-2.5 right-2.5" href="/material_favorites/${favorite.id}/edit" data-turbo-frame="material_favorite_edit_modal">
            <button class="bg-black text-white p-2 rounded">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                <path d="M12.146.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1 0 .708l-10 10a.5.5 0 0 1-.168.11l-5 2a.5.5 0 0 1-.65-.65l2-5a.5.5 0 0 1 .11-.168l10-10zM11.207 2.5 13.5 4.793 14.793 3.5 12.5 1.207 11.207 2.5zm1.586 3L10.5 3.207 4 9.707V10h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.293l6.5-6.5zm-9.761 5.175-.106.106-1.528 3.821 3.821-1.528.106-.106A.5.5 0 0 1 5 12.5V12h-.5a.5.5 0 0 1-.5-.5V11h-.5a.5.5 0 0 1-.468-.325z"/>
              </svg>
            </button>
          </a>
        </div>
      `;
    }).join('');
    this.listTarget.innerHTML = html;
  }

  /**
   * 获取收藏夹列表
   */
  getFavorites = () => {
    mrujs.fetch('/admin_api/thtri/inventories/folders').then(res => res.json()).then(res => {
      if (res.code === 0) {
        this.favoritesValue = res.data.list.map(item => ({
          id: item.ID,
          name: item.name,
          cover: item.cover,
          projectName: item.projectName,
          projectNo: item.projectNo,
          total: item.total,
        }));
      } else {
        console.error(res);
      }
    }).catch((reason) => {
      console.error(reason);
    });
  }

  handleRemoveFavorite(e) {
    const id = e.target.dataset.id;
    if(!confirm('确定要删除么')) return;
    this.removeFavorite(id);
  }

  /**
   * 删除收藏夹
   * @param {number} id 
   * @returns {void}
   */
  removeFavorite = (id) => {
    if (!id) return;
    mrujs.fetch(`/admin_api/thtri/inventories/folders/${id}`, {
      method: 'DELETE',
    }).then(res => res.json()).then(res => {
      if (res.code === 0) {
        this.getFavorites();
      } else {
        console.error(res);
      }
    }).catch(err => {
      console.error(err);
    });
  }

  disconnect() {
    window.removeEventListener('MaterialFavoritesRefresh', this.getFavorites);
  }
}
