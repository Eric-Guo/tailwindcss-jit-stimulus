import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ['text']

  copyText() {
    if (!this.hasTextTarget) return;
    const text = this.textTarget.textContent.trim();
    if (!text) return;
    /* 使用Clipboard API复制文本 */
    navigator.clipboard.writeText(text).then(function() {
      /* 复制成功后的操作 */
      alert('复制成功');
    }, function(err) {
      /* 复制失败后的操作 */
      alert('复制失败，请手动复制');
    });
  }
}
