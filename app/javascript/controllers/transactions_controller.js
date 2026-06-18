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

    const row = event.target.closest("[data-transaction-row]");
    const amountEl = row.querySelector("[data-statement-target='amount']");

    // Remove any existing value and dispatch an input event to recalculate the balance
    amountEl.value = 0;
    amountEl.dispatchEvent(new Event("input"));

    // If there is a transactionId, find and remove the specific row
    // and mark it as destroyed, then remove it from the DOM
    if (transactionId) {
      row.querySelector("[name*='_destroy']").value = 1;
      row.style.display = "none";
    } else {
      row.remove();
    }
  }

  updateAccountCategory(event) {
    const category = event.target.selectedOptions[0].dataset.category;

    const amountEl = event.target
      .closest("[data-transaction-row]")
      .querySelector("[data-statement-target='amount']");

    amountEl.dataset.category = category;
    amountEl.dispatchEvent(new Event("input"));
  }
}
