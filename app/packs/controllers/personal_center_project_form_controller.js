import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  submit() {
    console.log(123)
    this.element.submit();
  }
}
