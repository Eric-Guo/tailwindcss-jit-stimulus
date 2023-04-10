import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static values = {
    width: Number,
    height: Number,
  }

  static targets = ['img', 'tag']

  wrapperSize = {
    width: 0,
    height: 0,
  };

  _imgSize = {
    width: 0,
    height: 0,
  };

  imgViewSize = {
    width: 0,
    height: 0,
  }

  imgViewRange = {
    width: [0, 0],
    height: [0, 0],
  }

  get imgSize() {
    return this._imgSize;
  }

  set imgSize(value) {
    this._imgSize = value;
    this.getImgViewSize();
    this.getImgViewRange();
    this.setTags();
  }

  connect() {
    this.getWrapperSize();
    this.getImgSize();
  }

  getWrapperSize = () => {
    this.wrapperSize = {
      width: this.widthValue,
      height: this.heightValue,
    };
  }

  getImgSize = () => {
    if (!this.hasImgTarget) return;
    this.imgTarget.onload = () => {
      this.imgSize = {
        width: this.imgTarget.naturalWidth,
        height: this.imgTarget.naturalHeight,
      };
    }
    if (this.imgTarget.complete) {
      this.imgSize = {
        width: this.imgTarget.naturalWidth,
        height: this.imgTarget.naturalHeight,
      };
    }
  }

  getImgViewSize = () => {
    const wrapperRate = this.wrapperSize.width / this.wrapperSize.height;
    const imgRate = this.imgSize.width / this.imgSize.height;
    if (wrapperRate > imgRate) {
      this.imgViewSize.width = this.wrapperSize.width;
      this.imgViewSize.height = this.wrapperSize.width / imgRate;
    } else {
      this.imgViewSize.width = this.wrapperSize.height * imgRate;
      this.imgViewSize.height = this.wrapperSize.height;
    }
  }

  getImgViewRange = () => {
    if (this.imgViewSize.width > this.wrapperSize.width) {
      const diff_half = (this.imgViewSize.width - this.wrapperSize.width) / 2;
      this.imgViewRange.width = [diff_half, this.imgViewSize.width - diff_half];
      this.imgViewRange.height = [0, this.imgViewSize.height];
    } else {
      const diff_half = (this.imgViewSize.height - this.wrapperSize.height) / 2;
      this.imgViewRange.width = [0, this.imgViewSize.width];
      this.imgViewRange.height = [diff_half, this.imgViewSize.height - diff_half];
    }
  }

  inImgViewRange = (x, y) => {
    return x >= this.imgViewRange.width[0] && x <= this.imgViewRange.width[1] && y >= this.imgViewRange.height[0] && y <= this.imgViewRange.height[1];
  }

  getImgViewPosition = (x, y) => {
    return {
      left: x - (this.imgViewSize.width - this.wrapperSize.width) / 2,
      top: y - (this.imgViewSize.height - this.wrapperSize.height) / 2,
    }
  }

  setTags = () => {
    this.tagTargets.forEach(tag => {
      const xRate = Number(tag.dataset.x);
      const yRate = Number(tag.dataset.y);
      const x = xRate * this.imgViewSize.width;
      const y = yRate * this.imgViewSize.height;
      if (!this.inImgViewRange(x, y)) return;
      const { left, top } = this.getImgViewPosition(x, y);
      tag.style.left = `${left}px`;
      tag.style.top = `${top}px`;
      tag.style.display = '';
      const dot = tag.querySelector('[data-type=dot]');
      const line = tag.querySelector('[data-type=line]');
      const text = tag.querySelector('[data-type=text]');
      console.log(xRate);
      if (xRate > 0.5) {
        const dotWidth = dot.offsetWidth;
        const lineWidth = line.offsetWidth;
        const textWidth = text.offsetWidth;
        line.style.transform = `translateX(-${dotWidth+lineWidth}px)`;
        text.style.transform = `translateX(-${dotWidth+lineWidth+lineWidth+textWidth}px)`;
      }
      const popoverCard = tag.querySelector('.popover-card');
      if (!popoverCard) return;
      popoverCard.classList.forEach(item => {
        if (item.startsWith('placement-')) {
          popoverCard.classList.remove(item);
        }
      });
      const placementClass = `placement-${yRate > 0.5 ? 'top' : 'bottom'}-${xRate > 0.5 ? 'right' : 'left'}`;
      popoverCard.classList.add(placementClass);
    });
  }

  disconnect() { }
}
