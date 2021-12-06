import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['nav1Item', 'nav2Item', 'nav3Item', 'nav2Container', 'nav3Container']

  nav1ItemClick(e) {
    this.nav1ItemTargets.forEach(item => {
      this.nav3ContainerTarget.classList.add('hidden');
      const nav3Elem = this.nav3ContainerTarget.querySelector('nav.sidebar-nav');
      nav3Elem.innerHTML = '';
      if (item.contains(e.target)) {
        item.classList.add('active');
        const children = JSON.parse(item.dataset.children);
        const nav2Elem = this.nav2ContainerTarget.querySelector('nav.sidebar-nav');
        if (children) {
          nav2Elem.innerHTML = children.map(item => this.generalNavItem({ ...item, targetName: 'nav2Item', clickName: 'nav2ItemClick' })).join('');
          this.nav2ContainerTarget.classList.remove('hidden');
          this.nav2ContainerTarget.classList.add('show-animation');
          setTimeout(() => {
            this.nav2ContainerTarget.classList.remove('show-animation');
          }, 500);
        }
        else {
          nav2Elem.innerHTML = '';
          this.nav2ContainerTarget.classList.add('hidden');
        }
      } else {
        item.classList.remove('active');
      }
    });
  }

  nav2ItemClick(e) {
    this.nav2ItemTargets.forEach(item => {
      if (item.contains(e.target)) {
        item.classList.add('active');
        const children = JSON.parse(item.dataset.children);
        const navElem = this.nav3ContainerTarget.querySelector('nav.sidebar-nav');
        if (children) {
          navElem.innerHTML = children.map(item => this.generalNavItem({ ...item, targetName: 'nav3Item', clickName: 'nav3ItemClick' })).join('');
          this.nav3ContainerTarget.classList.remove('hidden');
          this.nav3ContainerTarget.classList.add('show-animation');
          setTimeout(() => {
            this.nav3ContainerTarget.classList.remove('show-animation');
          }, 500);
        }
        else {
          navElem.innerHTML = '';
          this.nav3ContainerTarget.classList.add('hidden');
        }
      } else {
        item.classList.remove('active');
      }
    });
  }

  nav3ItemClick(e) {
    this.nav3ItemTargets.forEach(item => {
      if (item.contains(e.target)) {
        item.classList.add('active');
      } else {
        item.classList.remove('active');
      }
    });
  }

  show() {
    document.body.classList.add('overflow-hidden');
  }
  
  reset() {
    document.body.classList.remove('overflow-hidden');
    this.nav1ItemTargets.forEach(item => {
      item.classList.remove('active');
    });
    this.nav2ContainerTarget.classList.add('hidden');
    const nav2Elem = this.nav2ContainerTarget.querySelector('nav.sidebar-nav');
    nav2Elem.innerHTML = '';
    this.nav3ContainerTarget.classList.add('hidden');
    const nav3Elem = this.nav3ContainerTarget.querySelector('nav.sidebar-nav');
    nav3Elem.innerHTML = '';
  }

  generalNavItem(data) {
    return `
      <div class="flex justify-between items-center sidebar-nav-item pl-1 pr-4" data-sidebar-nav-target="${data.targetName}" data-action="click->sidebar-nav#${data.clickName}" data-children='${JSON.stringify(data.children)}'>
        <div class="sidebar-nav-item-content truncate">
          ${data.url ? `
            <a class="relative" href="${data.url}" title="${data.title} ${data.subtitle}">
              <span class="text-xl leading-8">${data.title}</span>
              <span class="text-base leading-7">${data.subtitle}</span>
              <span class="sidebar-nav-text-underline"></span>
            </a>
          ` : `
            <span class="relative" title="${data.title} ${data.subtitle}">
              <span class="text-xl leading-8">${data.title}</span>
              <span class="text-base leading-7">${data.subtitle}</span>
              <span class="sidebar-nav-text-underline"></span>
            </span>
          `}
        </div>
        ${data.children ? `
          <div class="sidebar-nav-item-icon">
            <svg viewBox="0 0 1024 1024" width="100%" height="1em">
              <path fill="currentColor" d="M250.595556 184.888889a92.529778 92.529778 0 0 1 0.284444-129.991111 92.529778 92.529778 0 0 1 130.844444-0.853334l391.395556 391.68a92.188444 92.188444 0 0 1 0 130.56L381.44 967.964444a92.529778 92.529778 0 0 1-131.128889-130.56l326.826667-326.257777L250.595556 184.888889z"></path>
            </svg>
          </div>
        ` : ''}
      </div>
    `;
  }
}
