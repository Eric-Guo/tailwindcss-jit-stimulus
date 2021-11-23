import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['selectAll']

  connect() {
    this.selectAllTarget.indeterminate  = true;
  }

  disconnect() {
  }
}
