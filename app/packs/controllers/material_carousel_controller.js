import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['carouselItem', 'dotItem']
  static values = {
    enterClass: Array,
    leaveClass: Array,
    duration: Number,
    dotActiveClass: String,
  }

  connect() {
    this._currentIndex = 0;
    this._disabled = false;
  }

  // 动画过程中或者数量小于2个，禁止轮播
  disabled() {
    return this._disabled || this.carouselItemTargets.length <= 1;
  }

  // 上一个索引
  prevIndex() {
    const i = this._currentIndex - 1;
    return i < 0 ? this.carouselItemTargets.length - 1 : i;
  }
  
  // 下一个索引
  nextIndex() {
    const i = this._currentIndex + 1;
    return i > this.carouselItemTargets.length - 1 ? 0 : i;
  }

  // 通过索引获取轮播项
  getCarouselItemByIndex(index) {
    return this.carouselItemTargets[index];
  }

  // 通过索引获取dot
  getDotItemByIndex(index) {
    return this.dotItemTargets[index];
  }

  // 判断是否支持动画
  supportAnimation() {
    return 'onanimationstart' in window && 'onanimationend' in window;
  }

  // 获取动画class，direction: 1 左进右出，2 右进左出
  getAnimationClass(direction = 1) {
    const [leftEnter, rightEnter] = this.enterClassValue;
    const [leftLeave, rightLeave] = this.leaveClassValue;
    return [
      direction === 1 ? leftEnter.split(' ') : rightEnter.split(' '),
      direction === 1 ? leftLeave.split(' ') : rightLeave.split(' '),
      this.dotActiveClassValue.split(' '),
    ];
  }

  // 跳到某一项
  toIndex(index, direction = null) {
    if (this.disabled() || this._currentIndex === index) return;
    if (!direction) {
      if (this._currentIndex === this.carouselItemTargets.length - 1 && index === 0 ) {
        direction = 2;
      } else if (this._currentIndex === 0 && index === this.carouselItemTargets.length - 1) {
        direction = 1;
      } else {
        direction = this._currentIndex > index ? 1 : 2
      }
    }
    this._disabled = true;
    const leaveCarouselItem = this.getCarouselItemByIndex(this._currentIndex);
    const enterCarouselItem = this.getCarouselItemByIndex(index);
    const leaveDotItem = this.getDotItemByIndex(this._currentIndex);
    const enterDotItem = this.getDotItemByIndex(index);
    const [enterClass, leaveClass, dotClass] = this.getAnimationClass(direction);
    leaveCarouselItem.classList.add(...leaveClass);
    enterCarouselItem.style.display = '';
    enterCarouselItem.classList.add(...enterClass);
    leaveDotItem.classList.remove(...dotClass);
    enterDotItem.classList.add(...dotClass);
    this._currentIndex = index;
    const animationEnd = () => {
      leaveCarouselItem.style.display = 'none';
      leaveCarouselItem.classList.remove(...leaveClass);
      enterCarouselItem.classList.remove(...enterClass);
      this._disabled = false;
    };
    if (this.supportAnimation()) {
      leaveCarouselItem.onanimationend = null;
      enterCarouselItem.onanimationend = animationEnd;
    } else {
      const time = this.durationValue * 1000;
      setTimeout(animationEnd, time > 0 ? time : 500);
    }
  }

  toPrev() {
    this.toIndex(this.prevIndex(), 1);
  }
  
  toNext() {
    this.toIndex(this.nextIndex(), 2);
  }  
}
