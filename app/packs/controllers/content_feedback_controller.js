import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['button']

  rangeRect = null

  current = {}

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

  getScreenshot = async (args) => {
    const url = `${location.origin}/404.html`;
    const { content, viewport, scroll } = args;
    return await fetch('/screenshot', {
      method: 'POST',
      body: JSON.stringify({ url, content, viewport, scroll }),
      headers: {
        "Content-Type": "application/json",
      }
    }).then(res => res.blob());
  }

  blob2Img = async (blob) => {
    return await new Promise((res, rej) => {
      const img = document.createElement('img');
      const url = URL.createObjectURL(blob);
      img.src = url;
      img.onload = (e) => {
        res(img);
      };
      img.onerror = (e) => {
        rej(e);
      };
    });
  }

  loadData = async ({ params }) => {
    console.log(params);
    try {
      this.dispatchLoadingStart();
      this.clearButton();
      const rangeRect = { ...this.rangeRect };
      const content = document.documentElement.innerHTML;
      const viewport = params.fullPage ? {
        width: document.documentElement.scrollWidth,
        height: document.documentElement.scrollHeight,
      } : {
        width: window.innerWidth,
        height: window.innerHeight,
      };
      const scroll = params.fullPage ? {
        root: [0, 0],
      } : {
        root: [document.documentElement.scrollLeft, document.documentElement.scrollTop],
      }
      const blob = await this.getScreenshot({ content, viewport, scroll });
      const img = await this.blob2Img(blob);
      this.current.blob = blob;
      this.current.img = img;
      this.current.shapes = [];
      if (!params.fullPage) {
        const { left, top, width, height } = rangeRect;
        this.current.shapes.push({
          type: 'rect',
          x: left - 2,
          y: top - 2,
          w: width + 4,
          h: height + 4,
        });
      }
      this.dispatchLoadingSuccess(this.current);
    } catch (err) {
      this.dispatchLoadingError();
    } finally {
      this.dispatchLoadingEnd();
    }
  }

  dispatchLoadingStart() {
    const event = new CustomEvent('contentFeedback:loading-start');
    window.dispatchEvent(event);
  }

  dispatchLoadingEnd() {
    const event = new CustomEvent('contentFeedback:loading-end');
    window.dispatchEvent(event);
  }

  dispatchLoadingSuccess(detail) {
    const event = new CustomEvent('contentFeedback:loading-success', { detail });
    window.dispatchEvent(event);
  }

  dispatchLoadingError() {
    const event = new CustomEvent('contentFeedback:loading-error');
    window.dispatchEvent(event);
  }

  disconnect() {
    document.removeEventListener('selectionchange', this.selectionChange);
    window.removeEventListener('resize', this.setButton);
  }
}
