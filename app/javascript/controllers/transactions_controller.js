import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="transactions"
export default class extends Controller {
  static targets = ["rows", "template"];

  addRow() {
    const content = this.templateTarget.innerHTML.replaceAll(
      "NEW_RECORD",
      Date.now(),
    );

    this.rowsTarget.insertAdjacentHTML("beforeend", content);
  }

  connect() {}
}
