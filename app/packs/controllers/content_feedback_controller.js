import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['button']

  rangeRect = null

  connect() {
    document.addEventListener('selectionchange', this.selectionChange);
    window.addEventListener('resize', this.setButton);
  }

  selectionChange = (e) => {
    document.removeEventListener('mouseup', this.setButton);
    const selection = window.getSelection();
    if (selection.isCollapsed) return this.clearButton();
    if (!selection.toString().trim()) return this.clearButton();
    const anchorInThis = this.element.contains(selection.anchorNode);
    const focusInThis = this.element.contains(selection.focusNode);
    if (anchorInThis && focusInThis) {
      document.addEventListener('mouseup', this.setButton, { once: true });
    } else {
      this.clearButton();
    }
  }

  setButton = () => {
    const selection = window.getSelection();
    if (selection.isCollapsed) return;
    if (!selection.toString().trim()) return;
    if (!this.element.contains(selection.anchorNode)) return;
    if (!this.element.contains(selection.focusNode)) return;
    const range = selection.getRangeAt(0);
    const rect = range.getBoundingClientRect();
    // 缓存当前选择的区域
    this.rangeRect = {
      left: rect.left,
      top: rect.top,
      width: rect.width,
      height: rect.height,
    };
    if (!this.hasButtonTarget) return;
    const scrollTop = document.documentElement.scrollTop;
    const scrollLeft = document.documentElement.scrollLeft;
    this.buttonTarget.classList.remove('hidden');
    const width = this.buttonTarget.offsetWidth;
    const height = this.buttonTarget.offsetHeight;
    const buttonLeft = scrollLeft + rect.left + rect.width / 2 - width / 2;
    const buttonTop = scrollTop + rect.top - height - 10;
    this.buttonTarget.style.left = `${buttonLeft}px`;
    this.buttonTarget.style.top = `${buttonTop}px`;
  }

  clearButton = () => {
    if (!this.hasButtonTarget) return;
    this.buttonTarget.classList.add('hidden');
  }

  showDetail = async (e) => {
    this.clearButton();
    const url = `${location.origin}/404.html`;
    const content = document.documentElement.innerHTML;
    const viewport = {
      width: window.innerWidth,
      height: window.innerHeight,
    };
    const scroll = {
      root: [document.documentElement.scrollLeft, document.documentElement.scrollTop],
    }
    const blob = await fetch('/screenshot', {
      method: 'POST',
      body: JSON.stringify({ url, content, viewport, scroll }),
      headers: {
        "Content-Type": "application/json",
      }
    }).then(res => res.blob());
    const img = await new Promise((res, rej) => {
      const elem = document.createElement('img');
      const url = URL.createObjectURL(blob);
      elem.src = url;
      elem.onload = (e) => {
        res(elem);
      };
      elem.onerror = (e) => {
        rej(e);
      };
    });
    const canvas = document.createElement('canvas');
    canvas.className = 'fixed top-0 left-0';
    canvas.width = img.width;
    canvas.height = img.height;
    document.body.appendChild(canvas);
    canvas.addEventListener('click', () => {
      canvas.remove();
    });
    const ctx = canvas.getContext('2d');
    ctx.drawImage(img, 0, 0);
    const { left, top, width, height } = this.rangeRect;
    ctx.strokeStyle = 'red';
    ctx.lineWidth = 2;
    ctx.strokeRect(left - 2, top - 2, width + 4, height + 4);
  }

  disconnect() {
    document.removeEventListener('selectionchange', this.selectionChange);
    window.removeEventListener('resize', this.setButton);
  }
}
