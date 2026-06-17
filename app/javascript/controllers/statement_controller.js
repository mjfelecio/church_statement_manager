import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="statement"
export default class extends Controller {
  static targets = ["startingBalance", "endingBalance", "amount"];
  static values = { startingBalance: Number, endingBalance: Number };

  recalculateBalance() {
    // Remove deleted transaction rows (those with _destroy field set to 1)
    const filteredTargets = this.amountTargets.filter((el) => {
      const row = el.closest("[data-transaction-row]");
      const destroyField = row.querySelector("[name*='_destroy']");
      return destroyField.value !== "1";
    });

    const assetAmount = filteredTargets
      .filter((el) => el.dataset.category === "asset")
      .reduce((acc, el) => acc + (parseFloat(el.value) || 0), 0);
    const incomeAmount = filteredTargets
      .filter((el) => el.dataset.category === "income")
      .reduce((acc, el) => acc + (parseFloat(el.value) || 0), 0);
    const expenseAmount = filteredTargets
      .filter((el) => el.dataset.category === "expense")
      .reduce((acc, el) => acc + (parseFloat(el.value) || 0), 0);

    this.startingBalance = assetAmount;
    this.endingBalance = assetAmount + incomeAmount - expenseAmount;

    this.render();
  }

  render() {
    this.startingBalanceTarget.textContent = this.startingBalance.toFixed(2);
    this.endingBalanceTarget.textContent = this.endingBalance.toFixed(2);
  }

  connect() {
    this.recalculateBalance();
  }
}
