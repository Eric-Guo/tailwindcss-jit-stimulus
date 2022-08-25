import { Controller } from '@hotwired/stimulus'
import mrujs from "mrujs";

export default class extends Controller {
  static targets =  [
    'filesContainer',
    'uploadButton1Container',
    'uploadButton2Container',
    'fileInput',
    'file'
  ]
  static values = {
    uploadPath: String,
  }

  fileInputClick() {
    this.fileInputTarget.click();
  }

  fileInputChange(e) {
    const files = Array.from(e.target.files);
    if (this.uploadPathValue) {
      files.forEach(file => {
        const formData = new FormData();
        formData.append("file", file);
        mrujs.fetch(this.uploadPathValue, {
          method: 'POST',
          body: formData,
        }).then(res => {
          if (res.status !== 200) throw new Error('上传失败');
          return res.json();
        }).then(res => {
          const fileElem = this.buildFileElem({ name: res.name, url: res.url });
          this.uploadButton1ContainerTarget.classList.remove('hidden');
          this.uploadButton2ContainerTarget.classList.add('hidden');
          this.filesContainerTarget.classList.remove('hidden');
          this.filesContainerTarget.appendChild(fileElem);
        }).catch(err => {
          console.log(err.message);
        });
      })
    }
    this.fileInputTarget.value = '';
  }

  buildFileElem(file_info) {
    const wrapperElem = document.createElement('div');
    wrapperElem.className = 'flex justify-between items-center';

    const inputElem = document.createElement('input');
    inputElem.type = 'hidden';
    inputElem.name = 'files[]';
    inputElem.dataset.referenceGroupTarget = 'file';
    inputElem.dataset.name = file_info.name;
    inputElem.value = file_info.url;
    wrapperElem.appendChild(inputElem);

    const nameElem = document.createElement('div');
    nameElem.textContent = file_info.name;
    nameElem.title = file_info.name;
    nameElem.className = 'truncate';
    wrapperElem.appendChild(nameElem);

    const buttonGroupElem = document.createElement('div');
    buttonGroupElem.className = 'flex items-center ml-2';
    wrapperElem.appendChild(buttonGroupElem);

    const statusButton = document.createElement('button');
    statusButton.innerHTML = `
      <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-check-circle" viewBox="0 0 16 16">
        <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
        <path d="M10.97 4.97a.235.235 0 0 0-.02.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-1.071-1.05z"/>
      </svg>
    `;
    buttonGroupElem.appendChild(statusButton);

    const removeButton = document.createElement('button');
    removeButton.className = 'text-neutral-300 hover:text-black transition-all duration-300 hidden';
    removeButton.innerHTML = `
      <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-x-lg" viewBox="0 0 16 16">
        <path fill-rule="evenodd" d="M13.854 2.146a.5.5 0 0 1 0 .708l-11 11a.5.5 0 0 1-.708-.708l11-11a.5.5 0 0 1 .708 0Z"/>
        <path fill-rule="evenodd" d="M2.146 2.146a.5.5 0 0 0 0 .708l11 11a.5.5 0 0 0 .708-.708l-11-11a.5.5 0 0 0-.708 0Z"/>
      </svg>
    `;
    buttonGroupElem.appendChild(removeButton);

    wrapperElem.onmouseover = () => {
      statusButton.classList.add('hidden');
      removeButton.classList.remove('hidden');
    };

    wrapperElem.onmouseout = () => {
      statusButton.classList.remove('hidden');
      removeButton.classList.add('hidden');
    };

    removeButton.onclick = () => {
      wrapperElem.remove();
      if (this.filesContainerTarget.childElementCount === 0) {
        this.filesContainerTarget.classList.add('hidden');
        this.uploadButton1ContainerTarget.classList.add('hidden');
        this.uploadButton2ContainerTarget.classList.remove('hidden');
      }
    };

    return wrapperElem;
  }

  getFiles() {
    return this.fileTargets.map(item => ({
      name: item.dataset.name,
      path: item.value,
    }));
  }

  reset() {
    this.filesContainerTarget.innerHTML = '';
    this.filesContainerTarget.classList.add('hidden');
    this.uploadButton1ContainerTarget.classList.add('hidden');
    this.uploadButton2ContainerTarget.classList.remove('hidden');
  }
}
