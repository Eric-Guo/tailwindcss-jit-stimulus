import { Controller } from "@hotwired/stimulus"
import Viewer from "viewerjs"

export default class extends Controller {
  static targets = ['image']

  connect() {
    this.viewer = new Viewer(this.element, {
      filter: (image) => {
        return this.imageTargets.includes(image);
      }
    });
  }

  disconnect() {
    if (this.viewer) this.viewer.destroy();
  }
}
