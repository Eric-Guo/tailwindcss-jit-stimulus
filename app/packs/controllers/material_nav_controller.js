import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['navItem']

  // 点击菜单
  navItemClick(e) {
    this.navItemTargets.forEach(item => {
      if (item.contains(e.target) && !this.navItemIsActive(item)) {
        this.openNavItem(item);
      } else {
        item.classList.remove('active');
      }
    });
  }

  // 判断一级菜单是否展开
  navItemIsActive(target) {
    return target.classList.contains('active');
  }

  // 展开菜单
  openNavItem(target) {
    target.classList.add('active');
    target.scrollIntoView({ behavior: 'smooth' });
  }

  // 关闭菜单
  closeNavItem(target) {
    target.classList.remove('active');
  }
}
