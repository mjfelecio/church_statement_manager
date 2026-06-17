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

  deleteRow(event) {
    if (!confirm("Are you sure you want to delete this transaction?")) {
      return;
    }

    const transactionId = event.target.dataset.transactionId;

    // If there is a transactionId, find and remove the specific row
    // and mark it as destroyed, then remove it from the DOM
    if (transactionId) {
      const row = this.rowsTarget.querySelector(
        `#transaction-${transactionId}`,
      );

      row.querySelector("[name*='_destroy']").value = 1;
      row.style.display = "none";
    }
    // Otherwise, remove the closest row
    else {
      event.target.closest("[data-transaction-row]").remove();
    }
  }

  connect() {}
}
