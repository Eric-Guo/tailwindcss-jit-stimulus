import { Controller } from "@hotwired/stimulus";
import { renderStreamMessage } from "@hotwired/turbo";
import mrujs from "mrujs";

export default class extends Controller {
  static values = {
    showPath: String,
  }

  static targets = [
    'screenshotCover',
    'screenshotSuccess',
    'screenshotLoading',
    'screenshotEditorWrapper',
    'screenshotEditorCanvas',
  ]

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
    window.addEventListener('screenshotEditor:confirm', this.editorConfirm);
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
    this.img = detail.img;
    this.blob = detail.blob;
    this.shapes = detail.shapes;
    if (this.hasScreenshotSuccessTarget) {
      this.screenshotSuccessTarget.classList.remove('hidden');
    }
    if (this.hasScreenshotLoadingTarget) {
      this.screenshotLoadingTarget.classList.add('hidden');
    }
    if (this.hasScreenshotCoverTarget) {
      this.screenshotCoverTarget.src = this.img.src;
    }
    if (this.hasScreenshotEditorWrapperTarget) {
      const editorController = this.application.getControllerForElementAndIdentifier(this.screenshotEditorWrapperTarget, 'screenshot-editor');
      editorController.setImg(this.img);
      editorController.setShapes([...this.shapes]);
    }
  }

  screenshotError = () => {
    console.log('获取截图数据失败');
  }

  openEditor = (e) => {
    if (!this.img) return;
    if (this.hasScreenshotEditorWrapperTarget) {
      const editorController = this.application.getControllerForElementAndIdentifier(this.screenshotEditorWrapperTarget, 'screenshot-editor');
      editorController.setShapes([...this.shapes]);
      editorController.open();
    }
  }

  closeEditor = (e) => {
    if (this.hasScreenshotEditorWrapperTarget) {
      const editorController = this.application.getControllerForElementAndIdentifier(this.screenshotEditorWrapperTarget, 'screenshot-editor');
      editorController.close();
    }
  }

  editorConfirm = (e) => {
    const { blob, shapes } = e.detail;
    console.log(e.detail);
    this.shapes = [...shapes];
    this.blob = blob;
    const url = URL.createObjectURL(blob);
    if (this.hasScreenshotCoverTarget) {
      this.screenshotCoverTarget.src = url;
    }
  }

  disconnect() {
    window.removeEventListener('contentFeedback:loading-start', this.openModal);
    window.removeEventListener('contentFeedback:loading-end', this.renderScreenshot);
    window.removeEventListener('contentFeedback:loading-success', this.screenshotSuccess);
    window.removeEventListener('contentFeedback:loading-error', this.screenshotError);
  }
}
