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
    this.syncCode(container.lastElementChild);
    this.syncDisabledOptions();
  }

  updateCode(event) {
    const row = event.target.closest("[data-transaction-row]");
    this.syncCode(row);
  }

  visibleRows() {
    return [...this.element.querySelectorAll("[data-transaction-row]")].filter(
      (row) => {
        const destroyField = row.querySelector("[name*='_destroy']");
        return !destroyField || destroyField.value !== "1";
      },
    );
  }

  syncDisabledOptions() {
    const selects = this.visibleRows()
      .map((row) => row.querySelector("select"))
      .filter(Boolean);
    const used = new Set(
      selects.map((select) => select.value).filter((value) => value !== ""),
    );

    selects.forEach((select) => {
      const ownValue = select.value;
      select.querySelectorAll("option").forEach((option) => {
        if (option.value === "" || option.value === ownValue) {
          option.disabled = false;
        } else {
          option.disabled = used.has(option.value);
        }
      });
    });
  }

  syncAllCodes() {
    this.element
      .querySelectorAll("[data-transaction-row]")
      .forEach((row) => this.syncCode(row));
  }

  syncCode(row) {
    if (!row) return;
    const select = row.querySelector("select");
    const display = row.querySelector("[data-account-code]");
    if (!select || !display) return;
    const text = select.selectedOptions[0]?.textContent || "";
    const match = text.match(/\(([^)]+)\)/);
    display.textContent = match ? match[1] : "";
  }

  connect() {
    this.syncAllCodes();
    this.syncDisabledOptions();
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

    this.syncDisabledOptions();
    this.element.dispatchEvent(new Event("change", { bubbles: true }));
  }
}
