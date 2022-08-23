import { Controller } from "@hotwired/stimulus";
import { renderStreamMessage } from "@hotwired/turbo";
import mrujs from "mrujs";

export default class extends Controller {
  static values = {
    showPath: String,
  }

  static targets = ['screenshotCover', 'screenshotSuccess', 'screenshotLoading']

  loading = false

  img = null

  blob = null

  shapes = []

  connect() {
    console.log(this.showPathValue);
    window.addEventListener('contentFeedback:loading-start', this.openModal);
    window.addEventListener('contentFeedback:loading-end', this.renderScreenshot);
    window.addEventListener('contentFeedback:loading-success', this.screenshotSuccess);
    window.addEventListener('contentFeedback:loading-error', this.screenshotError);
  }

  openModal = () => {
    this.loading = true;
    mrujs.fetch(this.showPathValue)
      .then(res => res.text())
      .then(html => renderStreamMessage(html));
  }

  renderScreenshot = () => {
    this.loading = false;
  }

  screenshotSuccess = ({ detail }) => {
    this.screenshotSuccessTarget.classList.remove('hidden');
    this.screenshotLoadingTarget.classList.add('hidden');
    this.img = detail.img;
    this.blob = detail.blob;
    this.shapes = detail.shapes;
    this.screenshotCoverTarget.src = this.img.src;
    console.log('获取截图数据完成');
    console.log(detail);
  }

  screenshotError = () => {
    console.log('获取截图数据失败');
  }

  showEditor = (e) => {
    if (!this.img) return;
    console.log('打开图片编辑器');
  }

  disconnect() {
    window.removeEventListener('contentFeedback:loading-start', this.openModal);
    window.removeEventListener('contentFeedback:loading-end', this.renderScreenshot);
    window.removeEventListener('contentFeedback:loading-success', this.screenshotSuccess);
    window.removeEventListener('contentFeedback:loading-error', this.screenshotError);
  }
}
