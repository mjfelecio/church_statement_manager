import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="transactions"
export default class extends Controller {
  static targets = [
    "incomeRows",
    "expenseRows",
    "incomeTemplate",
    "expenseTemplate",
  ];

  addIncomeRow() {
    this.addRow(this.incomeTemplateTarget, this.incomeRowsTarget);
  }

  addExpenseRow() {
    this.addRow(this.expenseTemplateTarget, this.expenseRowsTarget);
  }

  addRow(template, container) {
    const content = template.innerHTML.replaceAll("NEW_RECORD", Date.now());

    container.insertAdjacentHTML("beforeend", content);
  }

  deleteRow(event) {
    if (!confirm("Are you sure you want to delete this transaction?")) {
      return;
    }

    const transactionId = event.target.dataset.transactionId;
    const row = event.target.closest("[data-transaction-row]");
    const amountEl = row.querySelector("[data-statement-target='amount']");

    amountEl.value = 0;
    amountEl.dispatchEvent(new Event("input"));

    if (transactionId) {
      row.querySelector("[name*='_destroy']").value = 1;
      row.style.display = "none";
    } else {
      row.remove();
    }

    this.element.dispatchEvent(new Event("change", { bubbles: true }));
  }
}
