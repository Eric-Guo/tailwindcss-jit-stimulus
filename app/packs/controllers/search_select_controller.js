import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    'search',
    'value',
    'label',
    'options',
  ];

  static values = {
    optionItemClassName: String,
    optionItemActiveClassName: String,
    optionItems: Array,
    optionsHeight: Number,
    placeholder: String,
    value: String,
  };

  connect() {
    window.addEventListener('resize', this.handleResize);
  }

  setOptionsStyle() {
    if (!this.hasOptionsTarget) return;
    const rootRect = this.element.getBoundingClientRect();
    this.optionsTarget.style.width = `${rootRect.width}px`;
    this.optionsTarget.style.maxHeight = this.optionsHeightValue + 'px';
    this.optionsTarget.style.display = '';
    const rect = this.optionsTarget.getBoundingClientRect();
    const rootToScreenButtonDistance = window.innerHeight - rootRect.bottom;
    if (rootToScreenButtonDistance > rect.height) {
      this.optionsTarget.style.top = rootRect.bottom + 'px';
      this.optionsTarget.style.left = rootRect.left + 'px';
      this.optionsTarget.style.bottom = '';
      this.optionsTarget.style.right = '';
    } else {
      this.optionsTarget.style.top = rootRect.top - rect.height + 'px';
      this.optionsTarget.style.left = rootRect.left + 'px';
      this.optionsTarget.style.bottom = '';
      this.optionsTarget.style.right = '';
    }
  }

  optionItemsValueChanged(value) {
    this.setOptionItems(value);
    this.valueValueChanged(this.valueValue);
  }

  handleOptionItemClick(event) {
    const value = event.target.dataset.value;
    this.valueValue = value;
  }

  setOptionItems(items) {
    if (!this.hasOptionsTarget || !Array.isArray(items)) return;
    this.optionsTarget.innerHTML = '';
    items.forEach(item => {
      const option = document.createElement('div');
      option.dataset.value = item.value;
      option.dataset.label = item.label;
      option.dataset.action = 'click->search-select#handleOptionItemClick';
      option.textContent = item.label;
      if (item.value === this.valueValue) {
        option.className = this.optionItemActiveClassNameValue;
      } else {
        option.className = this.optionItemClassNameValue;
      }
      this.optionsTarget.appendChild(option);
    });
  }

  valueValueChanged(value) {
    const optionItems = Array.from(this.optionsTarget.children);
    let selectedOption;
    optionItems.forEach(item => {
      if (item.dataset.value === value) {
        item.className = this.optionItemActiveClassNameValue;
        selectedOption = {
          label: item.dataset.label,
          value: item.dataset.value,
        };
      } else {
        item.className = this.optionItemClassNameValue;
      }
    });
    this.valueTarget.value = value;
    if (selectedOption) {
      this.searchTarget.placeholder = selectedOption.label;
      this.labelTarget.textContent = selectedOption.label;
      this.labelTarget.style.color = '';
    } else {
      this.searchTarget.placeholder = this.placeholderValue;
      this.labelTarget.textContent = this.placeholderValue;
      this.labelTarget.style.color = '#6b7280';
    }
  }

  handleResize = () => {
    this.setOptionsStyle();
  };

  handleFocus = (event) => {
    event.stopPropagation();
    this.labelTarget.style.display = 'none';
    this.searchTarget.style.display = '';
    this.searchTarget.focus();
    this.setOptionsStyle();
    window.addEventListener('click', this.handleBlur, { once: true });
  };

  handleBlur = () => {
    this.labelTarget.style.display = '';
    this.searchTarget.style.display = 'none';
    this.searchTarget.value = '';
    this.optionsTarget.style.display = 'none';
  };

  disconnect() {
    window.removeEventListener('resize', this.handleResize);
  }
}
