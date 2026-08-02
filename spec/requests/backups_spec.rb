require 'rails_helper'

RSpec.describe "Backups", type: :request do
  describe "GET /backup" do
    it "renders the manage data page" do
      get backup_path

      expect(response).to be_successful
      expect(response.body).to include("Manage Data")
    end
  end

  describe "GET /backup/preview" do
    it "redirects to the manage data page when no backup is staged" do
      get preview_backup_path

      expect(response).to redirect_to(backup_path)
      expect(flash[:alert]).to eq("No backup data found. Please upload a backup file.")
    end
  end

  describe "DELETE /backup/reset" do
    let(:prepared_by) { Person.create!(name: "Preparer", position: "Treasurer") }
    let(:approved_by) { Person.create!(name: "Approver", position: "Pastor") }
    let(:account) { Account.create!(code: "1000", name: "Cash", category: :income) }

    let!(:statement) do
      Statement.create!(
        month: :january,
        year: 2026,
        initial_balance: 1000,
        prepared_by: prepared_by,
        approved_by: approved_by
      )
    end

    let!(:transaction) do
      Transaction.create!(
        statement: statement,
        account: account,
        description: "Offering",
        amount: 100
      )
    end

    context "when resetting only statements" do
      it "deletes statements and transactions" do
        expect {
          delete reset_backup_path, params: { only_statements: "true" }
        }.to change(Statement, :count).by(-1)
        .and change(Transaction, :count).by(-1)
      end

      it "keeps people and accounts" do
        delete reset_backup_path, params: { only_statements: "true" }

        expect(Person.count).to eq(2)
        expect(Account.count).to eq(1)
      end

      it "redirects to the root path with a notice" do
        delete reset_backup_path, params: { only_statements: "true" }

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq("Statements and transactions have been reset.")
      end
    end

    context "when resetting all data" do
      it "deletes statements and transactions" do
        expect {
          delete reset_backup_path
        }.to change(Statement, :count).by(-1)
        .and change(Transaction, :count).by(-1)
      end

      it "deletes people and accounts" do
        expect {
          delete reset_backup_path
        }.to change(Person, :count).by(-2)
        .and change(Account, :count).by(-1)
      end

      it "redirects to the root path with a notice" do
        delete reset_backup_path

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq("All data has been reset.")
      end
    end
  end
end
