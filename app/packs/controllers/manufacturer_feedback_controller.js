import { Controller } from "@hotwired/stimulus";
import { renderStreamMessage } from "@hotwired/turbo";
import mrujs from "mrujs";

export default class extends Controller {
  static values = {
    showPath: String,
    uploadImgPath: String,
  }

  static targets = [
    'screenshotCover',
    'screenshotSuccess',
    'screenshotLoading',
    'screenshotEditorWrapper',
    'screenshotEditorCanvas',
    'referenceContainer',
    'turboModal',
  ]

  loading = false

  img = null

  blob = null

  shapes = []

  connect() {
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
      editorController.render();
      editorController.confirm();
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
    this.shapes = [...shapes];
    this.blob = blob;
    const url = URL.createObjectURL(blob);
    if (this.hasScreenshotCoverTarget) {
      this.screenshotCoverTarget.src = url;
    }
  }

  formSubmit = async (e) => {
    e.preventDefault();
    const formPath = e.target.action;
    if (!formPath) return alert('提交地址不能为空');
    const formData = new FormData(e.target);
    const questionTypeIds = formData.getAll('question_type_ids[]').map(id => Number(id));
    if (questionTypeIds.length === 0) {
      return alert('问题类型不能为空');
    }
    const description = formData.get('description').trim();
    if (!description) {
      return alert('意见反馈不能为空');
    }
    const screenshotFormData = new FormData();
    screenshotFormData.append("file", this.blob);
    const screenshotPath = await mrujs.fetch(this.uploadImgPathValue, {
      method: 'POST',
      body: screenshotFormData,
    }).then(res => {
      if (res.status !== 200) throw new Error('截图上传失败');
      return res.json();
    }).then(res => {
      return res.url;
    }).catch(err => {
      console.log(err.message);
      alert('截图上传失败')
      throw new Error(err);
    });
    let references = [];
    if (this.hasReferenceContainerTarget) {
      const referenceController = this.application.getControllerForElementAndIdentifier(this.referenceContainerTarget, 'reference-group');
      references = referenceController.getFiles();
    }
    const json = {
      question_type_ids: questionTypeIds,
      description,
      screenshot_path: screenshotPath,
      references,
    };
    const result = await mrujs.fetch(formPath, {
      method: 'POST',
      body: JSON.stringify(json),
      headers: {
        'Content-Type': 'application/json',
      },
    })
    .then(res => res.json())
    .catch(err => {
      console.log(err.message);
      alert('提交失败');
      throw new Error(err);
    });

    if (this.hasTurboModalTarget) {
      const turboModalController = this.application.getControllerForElementAndIdentifier(this.turboModalTarget, 'turbo-modal');
      turboModalController.hide();
    }
    alert('提交成功');
  }

  disconnect() {
    window.removeEventListener('contentFeedback:loading-start', this.openModal);
    window.removeEventListener('contentFeedback:loading-end', this.renderScreenshot);
    window.removeEventListener('contentFeedback:loading-success', this.screenshotSuccess);
    window.removeEventListener('contentFeedback:loading-error', this.screenshotError);
  }
}
