# frozen_string_literal: true

# localhost:3000/api/v1/expenses
class Api::V1::ExpenseController < ApplicationController
  before_action :authenticated?
  before_action :get_apartment
  before_action :get_expense, only: [:mark_paid, :delete]

  def create
    # Validate users
    return render plain: 'Invalid user(s)', status: :bad_request \
      if params[:payer_id].nil? or User.find_by_id(params[:payer_id]).nil? \
         or params[:issuer_id].nil? or User.find_by_id(params[:issuer_id]).nil? \
         or User.find_by_id(params[:payer_id]).apartment_id != @apartment.id \
         or User.find_by_id(params[:issuer_id]).apartment_id != @apartment.id

    # Create expense
    expense = Expense.create(
        :apartment_id => @apartment.id,
        :payer_id => params[:payer_id],
        :issuer_id => params[:issuer_id],
        :title => params[:title],
        :amount => params[:amount],
        :paid => false,
    )
    return render :json => {:errors => expense.errors.full_messages}, status: :bad_request unless expense.valid?
    render plain: 'Expense creation successful', status: :ok
  end

  def get_all
    expenses = Expense.where(:apartment_id => @apartment.id)
    render :json => expenses.map{|x| x.attributes.merge({:issuer => x.issuer, :payer => x.payer, :document => x.document})}, status: :ok
  end

  def mark_paid
      document = Document.find_by_id(params[:document_id])
      return render plain: 'Invalid document ID', status: :bad_request \
        if (params[:document_id] and document.nil?) \
        or (not document.nil? and document.apartment_id != @apartment.id)

      # Update paid and document
      @expense.update_column(:paid, params[:paid])
      document.update_column(:expense_id, params[:document_id]) unless document.nil?

      render plain: 'Expense successfully updated', status: :ok
  end

  def delete
    # Delete expense
    @expense.destroy
    render plain: 'Expense successfully deleted', status: :ok
  end

  private
  def get_expense
    begin
      @expense = Expense.find(params[:expense_id])
    rescue
      return render plain: 'Invalid expense ID', status: :bad_request
    end
    render plain: 'Unauthorized expense ID(s)', status: :unauthorized unless @apartment.id == @expense.apartment_id
  end
end
