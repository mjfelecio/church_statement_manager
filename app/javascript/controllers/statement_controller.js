import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="statement"
export default class extends Controller {
  static targets = [
    "startingBalance",
    "endingBalance",
    "amount",
    "initialBalance",
    "month",
    "year",
  ];
  static values = { startingBalance: Number, endingBalance: Number };

  getInitialBalance() {
    if (this.hasInitialBalanceTarget) {
      return Number(this.initialBalanceTarget.value);
    }

    return Number(this.startingBalanceValue);
  }

  recalculateBalance() {
    // Remove deleted transaction rows (those with _destroy field set to 1)
    const filteredTargets = this.amountTargets.filter((el) => {
      const row = el.closest("[data-transaction-row]");
      const destroyField = row.querySelector("[name*='_destroy']");
      return destroyField.value !== "1";
    });

    const incomeAmount = filteredTargets
      .filter((el) => el.dataset.category === "income")
      .reduce((acc, el) => acc + (parseFloat(el.value) || 0), 0);
    const expenseAmount = filteredTargets
      .filter((el) => el.dataset.category === "expense")
      .reduce((acc, el) => acc + (parseFloat(el.value) || 0), 0);

    this.startingBalanceValue = this.getInitialBalance();
    this.endingBalanceValue =
      this.startingBalanceValue + incomeAmount - expenseAmount;

    this.render();
  }

  async refreshBeginningBalance() {
    if (this.hasInitialBalanceTarget) {
      return;
    }

    const month = this.monthTarget.value;
    const year = this.yearTarget.value;

    const response = await fetch(
      `/statements/beginning_balance?month=${month}&year=${year}`,
    );

    if (!response.ok) return;

    const data = await response.json();

    this.startingBalanceValue = Number(data.beginning_balance);
    this.recalculateBalance();
  }

  render() {
    this.startingBalanceTarget.textContent =
      this.startingBalanceValue.toFixed(2);
    this.endingBalanceTarget.textContent = this.endingBalanceValue.toFixed(2);
  }

  async connect() {
    await this.refreshBeginningBalance();
    this.recalculateBalance();
  }
}
