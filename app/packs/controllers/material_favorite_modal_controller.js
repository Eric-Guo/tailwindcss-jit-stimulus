import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    'newFavoriteBtn',
    'newFavoriteForm',
    'newFavoriteAction',
    'footer',
    'formMask',
  ];

  static values = {
    newFavoriteOpen: Boolean,
  };
  
  connect() { }

  newFavoriteOpenValueChanged(open) {
    if (open) {
      this.newFavoriteBtnTarget.style.display = "none";
      this.newFavoriteFormTarget.style.display = '';
      this.newFavoriteActionTarget.style.display = '';
      this.footerTarget.style.display = 'none';
      this.formMaskTarget.style.display = '';
    } else {
      this.newFavoriteBtnTarget.style.display = '';
      this.newFavoriteFormTarget.style.display = 'none';
      this.newFavoriteActionTarget.style.display = 'none';
      this.footerTarget.style.display = '';
      this.formMaskTarget.style.display = 'none';
    }
  }

  showFavoriteForm() {
    this.newFavoriteOpenValue = true;
  }

  cancelNewFavorite() {
    this.newFavoriteOpenValue = false;
  }
}
