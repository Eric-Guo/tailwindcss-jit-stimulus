import { Controller } from '@hotwired/stimulus'
import mrujs from "mrujs";

export default class extends Controller {
  static targets =  ["materialContainer", "filesContainer", "uploadButton2Container", "fileInput", "uploadButton1"]
  static values = {
    uploadPath: String,
    submitPath: String,
  }

  modalController = null

  connect() {
    this.modalController = this.application.getControllerForElementAndIdentifier(this.element, 'modal');
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
          this.uploadButton2ContainerTarget.classList.add('hidden');
          this.uploadButton1Target.classList.remove('hidden');
          this.filesContainerTarget.classList.remove('hidden');
          this.filesContainerTarget.appendChild(fileElem);
        }).catch(err => {
          console.log(err.message);
        });
      })
    }
    this.fileInputTarget.value = '';
  }

  cateChange(e) {
    const materials = JSON.parse(e.target.dataset.materials);
    const select = this.materialContainerTarget.querySelector('select');
    if (select) {
      if (Array.isArray(materials) && materials.length > 0) {
        const html = materials.map(item => `<option value="${item.id}">${item.name}</option>`).join('');
        select.innerHTML = html;
        this.materialContainerTarget.classList.remove('hidden');
      } else {
        select.innerHTML = '';
        this.materialContainerTarget.classList.add('hidden');
      }
    }
  }

  buildFileElem(file_info) {
    const wrapperElem = document.createElement('div');
    wrapperElem.className = 'flex justify-between items-center';

    const inputElem = document.createElement('input');
    inputElem.type = 'hidden';
    inputElem.name = 'files[]';
    inputElem.dataset.needRegisterTarget = 'file';
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
        this.uploadButton1Target.classList.add('hidden');
        this.filesContainerTarget.classList.add('hidden');
        this.uploadButton2ContainerTarget.classList.remove('hidden');
      }
    };

    return wrapperElem;
  }

  getValues() {
    const cateElem = this.element.querySelector('input[type="radio"][name="cate"]:checked');
    const materialElem = this.element.querySelector('select[name="material"]');
    const descriptionElem = this.element.querySelector('textarea[name="description"]');
    const fileElems = Array.from(this.element.querySelectorAll('input[name="files[]"]'));

    return {
      cate: cateElem && cateElem.value,
      material: materialElem && materialElem.value,
      description: descriptionElem.value,
      files: fileElems.map(item => ({
        name: item.dataset.name,
        path: item.value,
      })),
    };
  }

  clearValues() {
    const cateElem = this.element.querySelector('input[type="radio"][name="cate"]:checked');
    const descriptionElem = this.element.querySelector('textarea[name="description"]');
    const materialSelect = this.materialContainerTarget.querySelector('select');
    cateElem.checked = false
    descriptionElem.value = '';
    materialSelect.innerHTML = '';
    this.materialContainerTarget.classList.add('hidden');
    this.filesContainerTarget.innerHTML = '';
    this.filesContainerTarget.classList.add('hidden');
    this.uploadButton2ContainerTarget.classList.remove('hidden');
    this.uploadButton1Target.classList.add('hidden');
  }

  submit() {
    if (this.modalController) {
      const values = this.getValues();
      if (!values.cate) return alert('需求类型不能为空');
      if (!values.description) return alert('具体描述不能为空');
      mrujs.fetch(this.submitPathValue, {
        method: 'POST',
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify(values),
      }).then(res => {
        if (res.status !== 200) throw new Error('提交失败');
        return res.json();
      }).then(res => {
        this.clearValues();
        this.modalController.close();
        alert('提交成功');
      }).catch(err => {
        console.log(err.message);
      });
    }
  }
}
