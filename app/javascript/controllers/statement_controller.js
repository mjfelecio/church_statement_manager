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
  static values = { startingBalance: Number, endingBalance: Number, statementMonth: String };

  // Maps month key strings to their numeric order (1-12)
  static monthOrder = {
    january: 1, february: 2, march: 3, april: 4,
    may: 5, june: 6, july: 7, august: 8,
    september: 9, october: 10, november: 11, december: 12,
  };

  getInitialBalance() {
    if (this.hasInitialBalanceTarget) {
      return Number(this.initialBalanceTarget.value);
    }

    return Number(this.startingBalanceValue);
  }

  recalculateBalance() {
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

  async refreshTakenMonths() {
    const year = this.yearTarget.value;
    if (!year) return;

    const response = await fetch(`/statements/taken_months?year=${year}`);
    if (!response.ok) return;

    const { taken_months, earliest } = await response.json();

    if (this.yearTarget instanceof HTMLInputElement && earliest) {
      this.yearTarget.min = earliest.year;
    }

    for (const option of this.monthTarget.options) {
      const monthKey = option.value;
      const monthNum = this.constructor.monthOrder[monthKey];
      let disabled = false;

      if (taken_months.includes(monthKey) && monthKey !== this.statementMonthValue) {
        disabled = true;
      }

      if (earliest) {
        const yearNum = parseInt(year, 10);
        if (yearNum < earliest.year) {
          disabled = true;
        } else if (yearNum === earliest.year && monthNum < this.constructor.monthOrder[earliest.month]) {
          disabled = true;
        }
      }

      option.disabled = disabled;
    }
  }

  render() {
    this.startingBalanceTarget.textContent =
      this.startingBalanceValue.toFixed(2);
    this.endingBalanceTarget.textContent = this.endingBalanceValue.toFixed(2);
  }

  async connect() {
    await this.refreshTakenMonths();
    await this.refreshBeginningBalance();
    this.recalculateBalance();
  }
}
