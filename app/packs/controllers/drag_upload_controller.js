import { Controller } from "@hotwired/stimulus"
import mrujs from "mrujs";
import { partial } from 'filesize';

const humanSize = partial({standard: "jedec"});

export default class extends Controller {
  static targets = [
    'value',
    'fileInput',
    'preview',
    'dropzone',
  ]

  static values = {
    value: String,
    fileTypes: Array,
    fileMaxSize: Number,
  }

  connect() {}

  fileTypesValueChanged(fileTypes) {
    this.fileInputTarget.accept = fileTypes.join(',');
  }

  valueValueChanged(value) {
    this.valueTarget.value = value;
    this.previewTarget.src = value;
    this.previewTarget.style.display = value ? '' : 'none';
    this.dropzoneTarget.style.display = value ? 'none' : '';
  }

  /**
   * 检查文件类别
   * @param {string} fileType 
   * @returns {boolean}
   */
  checkFileType(fileType) {
    if (!Array.isArray(this.fileTypesValue) || this.fileTypesValue.length === 0) return true;
    return this.fileTypesValue.some(item => new RegExp(`^${item.replace(/(?<!\.)\*/, '.*')}$`, 'i').test(fileType));
  }

  /**
   * 检查文件大小
   * @param {number} size
   * @returns {boolean}
   */
  checkFileMaxSize(size) {
    return this.fileMaxSizeValue > 0 && size <= this.fileMaxSizeValue;
  }

  /**
   * 上传文件
   * @param {File} file 
   * @returns {void}
   */
  uploadFile(file) {
    if (!this.checkFileType(file.type)) {
      alert('文件类型不正确');
      return;
    }
    if (!this.checkFileMaxSize(file.size)) {
      alert(`文件大小不超过${humanSize(this.fileMaxSizeValue)}`);
      return;
    }
    const formData = new FormData();
    formData.append('file', file);
    mrujs.fetch('/admin_api/thtri/updateImages', {
      method: 'POST',
      body: formData,
    }).then(res => res.json()).then(res => {
      if (res.code === 0) {
        this.valueValue = `/${res.data.file.url}`;
      } else {
        alert(res.msg);
      }
    });
  }

  handleFileClick(e) {
    e.preventDefault();
    this.fileInputTarget.click();
  }

  handleDragover(e) {
    e.preventDefault();
  }

  handleDrop(e) {
    e.preventDefault();
    const file = e.dataTransfer.files[0];
    if (!file) return;
    this.uploadFile(file);
  }

  handleFileChange(e) {
    const file = e.target.files[0];
    if (!file) return;
    this.uploadFile(file);
    e.target.value = '';
  }
}
