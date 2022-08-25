import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    'wrapper',
    'canvas',
    'drawActionButton',
    'textInput',
  ]

  img = null

  shapes = []

  isDragging = false
  initialCoordinate = null

  drawType = null

  drawCallback = null

  animateId = null

  connect() {
    if (this.hasWrapperTarget) {
      this.wrapperTarget.addEventListener('mousedown', this.startDrag);
    }
  }

  open = () => {
    this.element.classList.remove('hidden');
    this.animate();
  }

  close = () => {
    this.cancelDrawButton();
    this.cancelAnimate();
    this.element.classList.add('hidden');
  }

  startDrag = (e) => {
    this.isDragging = true;
    document.addEventListener('mouseup', () => {
      this.isDragging = false;
    }, { once: true });
    const target = e.currentTarget;
    const clientPos = { x: e.clientX, y: e.clientY };
    const offsetPos = { x: e.offsetX, y: e.offsetY };
    switch(this.drawType) {
      case 'rect':
      case 'arrow': {
        const shape = this.addShape(this.drawType, { ...offsetPos });
        const drawing = (e) => {
          if (!this.isDragging) return;
          const x = e.offsetX;
          const y = e.offsetY;
          shape.w = x - shape.x;
          shape.h = y - shape.y;
        };
        target.addEventListener('mousemove', drawing);
        document.addEventListener('mouseup', () => {
          target.removeEventListener('mousemove', drawing);
        }, { once: true });
        break;
      }
      case 'text': {
        if (this.hasTextInputTarget) {
          const input = this.textInputTarget;
          const text = input.textContent.trim();
          if (text) {
            const pos = { x: input.offsetLeft + 8, y: input.offsetTop + 24 };
            this.addShape(this.drawType, { ...pos, text });
          }
          input.innerHTML = '';
          input.classList.remove('hidden');
          input.style.left = `${offsetPos.x - 8}px`;
          input.style.top = `${offsetPos.y - 16}px`;
          setTimeout(() => {
            input.focus();
          }, 0);
        }
        break;
      }
      default: {
        this.initialCoordinate = clientPos;
        const dragging = (e) => {
          if (!this.isDragging) return;
          const x = e.clientX;
          const y = e.clientY;
          target.scrollBy({
            left: this.initialCoordinate.x - x,
            top: this.initialCoordinate.y - y,
          });
          this.initialCoordinate = { x, y };
        };
        target.addEventListener('mousemove', dragging);
        document.addEventListener('mouseup', () => {
          this.initialCoordinate = null;
          target.removeEventListener('mousemove', dragging);
        }, { once: true });
      }
    }
  }

  // 绘制方形
  drawRect = (e) => {
    const TYPE = 'rect';
    if (this.drawType === TYPE) {
      this.cancelDrawButton();
    } else {
      this.toggleDrawButton(TYPE, e.currentTarget);
    }
  }

  // 绘制箭头
  drawArrow = (e) => {
    const TYPE = 'arrow';
    if (this.drawType === TYPE) {
      this.cancelDrawButton();
    } else {
      this.toggleDrawButton(TYPE, e.currentTarget);
    }
  }

  // 绘制文本
  drawText = (e) => {
    const TYPE = 'text';
    if (this.drawType === TYPE) {
      this.cancelDrawButton();
    } else {
      this.toggleDrawButton(TYPE, e.currentTarget);
    }
  }

  activeTextInput = (e) => {
    e.stopPropagation();
  }

  confirmTextInput = (e) => {
    if (['Enter', 'NumpadEnter'].includes(e.code)) {
      if (this.hasTextInputTarget) {
        const input = this.textInputTarget;
        const text = input.textContent.trim();
        if (text) {
          const pos = { x: input.offsetLeft + 8, y: input.offsetTop + 24 };
          this.addShape(this.drawType, { ...pos, text });
        }
        this.textInputTarget.classList.add('hidden');
        input.innerHTML = '';
      }
    }
  }

  toggleDrawButton = (type, target) => {
    this.drawType = type;
    this.cancelDrawEvent();
    const escFun = (e) => {
      if (this.isDragging) return;
      if (e.code === 'Escape') this.cancelDrawButton();
    };
    window.addEventListener('keydown', escFun);
    target.classList.add('text-blue-600');
    this.drawActionButtonTargets.forEach(button => {
      if (target !== button) {
        button.classList.remove('text-blue-600');
      }
    });
    this.drawCallback = () => {
      window.removeEventListener('keydown', escFun);
      if (this.hasTextInputTarget) {
        this.textInputTarget.classList.add('hidden');
        this.textInputTarget.innerHTML = '';
      }
    };
  }

  // 取消绘制button
  cancelDrawButton = () => {
    this.drawType = null;
    this.drawActionButtonTargets.forEach(button => {
      button.classList.remove('text-blue-600');
    });
    this.cancelDrawEvent();
  }

  // 取消绘制事件
  cancelDrawEvent = () => {
    if (this.drawCallback) this.drawCallback();
    this.drawCallback = null;
  }

  // 设置图片
  setImg = (img) => {
    this.img = img;
    if (this.img && this.hasCanvasTarget) {
      this.canvasTarget.width = this.img.width;
      this.canvasTarget.height = this.img.height;
    }
  }

  // 设置形状
  setShapes = (shapes) => {
    this.shapes = shapes || [];
  }

  // 添加形状
  addShape = (type, args = {}) => {
    if (type === 'text') {
      const { x, y, text = '' } = args;
      if (!text) throw new Error('文本不能为空');
      const shape = { type, x, y, text };
      this.shapes.push(shape);
      return shape;
    } else {
      const { x, y, w = 0, h = 0 } = args;
      const shape = { type, x, y, w, h };
      this.shapes.push(shape);
      return shape;
    }
  }

  // 渲染
  render = () => {
    if (this.hasCanvasTarget) {
      const ctx = this.canvasTarget.getContext('2d');
      if (this.img) {
        ctx.drawImage(this.img, 0, 0);
      }
      this.shapes.forEach(shape => {
        switch(shape.type) {
          case 'rect': {
            ctx.strokeStyle = '#FFE829';
            ctx.lineWidth = 2;
            ctx.strokeRect(shape.x, shape.y, shape.w, shape.h);
            ctx.fillStyle = 'rgba(233, 164, 26, 0.3)';
            ctx.fillRect(shape.x, shape.y, shape.w, shape.h);
            break;
          }
          case 'arrow': {
            ctx.strokeStyle = '#FF411D';
            ctx.lineWidth = 2;

            const x1 = shape.x + shape.w, y1 = shape.y + shape.h;
            const angle = Math.atan2(shape.h, shape.w);
            const l = 20;
            const x3 = x1 - l * Math.cos(angle + 30 * Math.PI / 180);
            const y3 = y1 - l * Math.sin(angle + 30 * Math.PI / 180);
            const x4 = x1 - l * Math.cos(angle - 30 * Math.PI / 180);
            const y4 = y1 - l * Math.sin(angle - 30 * Math.PI / 180);

            ctx.beginPath();
            ctx.moveTo(shape.x, shape.y);
            ctx.lineTo(x1, y1);
            ctx.moveTo(x3, y3);
            ctx.lineTo(x1, y1);
            ctx.moveTo(x4, y4);
            ctx.lineTo(x1, y1);
            ctx.stroke();
            break;
          }
          case 'text': {
            ctx.font = '24px serif';
            ctx.fillStyle = 'red';
            ctx.fillText(shape.text, shape.x, shape.y);
            break;
          }
        }
      });
    }
    this.animate();
  }

  animate = () => {
    this.animateId = requestAnimationFrame(this.render);
  }

  cancelAnimate = () => {
    if (this.animateId) cancelAnimationFrame(this.animateId);
    this.animateId = null;
  }

  redo = (e) => {
    this.cancelDrawButton();
    this.shapes.pop();
  }

  confirm = async (e) => {
    if (this.hasCanvasTarget) {
      const blob = await new Promise(res => {
        this.canvasTarget.toBlob(blob => res(blob));
      });
      const event = new CustomEvent('screenshotEditor:confirm', { detail: {
        blob,
        shapes: [...this.shapes],
      } });
      window.dispatchEvent(event);
    }
    this.close();
  }

  disconnect() {
    this.cancelDrawButton();
    this.cancelAnimate();
  }
}
