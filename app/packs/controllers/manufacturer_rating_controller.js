import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['storeInput', 'star', 'description']

  descriptions = {
    1: '比较差',
    2: '比较好',
    3: '非常好'
  }
  
  connect() {
    this.renderStars();
  }

  // 获取得分
  getScore() {
    if (this.hasStoreInputTarget) {
      const value = this.storeInputTarget.value;
      return Number(value) || 0;
    }
    return 0;
  }

  // 设置得分
  setScore(value) {
    if (this.hasStoreInputTarget) {
      this.storeInputTarget.value = value.toString();
    }
  }

  // 渲染星星
  renderStars(overScore = null) {
    const score = overScore || this.getScore();
    this.starTargets.forEach((item, index) => {
      if (score > index) {
        item.classList.add('star-active');
      } else {
        item.classList.remove('star-active');
      }
    });
    const description = this.descriptions[score];
    if (this.hasDescriptionTarget) {
      this.descriptionTarget.textContent = description || '';
    }
  }

  handleStarEnter({ params }) {
    this.renderStars(params.index + 1);
  }

  handleStarLeave() {
    this.renderStars();
  }
  
  handleStarClick({ params }) {
    const score = params.index + 1;
    this.setScore(score);
  }

  disconnect() {}
}
