class ChargesController < ApplicationController
  def new
  end

  def create
    @amount = params[:amount]

    @amount = @amount.gsub('$', '').gsub(',', '')

    begin
      @amount = Float(@amount).round(2)
    rescue
      flash[:error] = 'Charge not completed. Please enter a valid amount in USD ($).'
      redirect_to edit_user_registration_path
      return
    end

    @amount = (@amount * 100).to_i # Must be an integer!

    if @amount < 500
      flash[:error] = 'Charge not completed. Donation amount must be at least $5.'
      redirect_to edit_user_registration_path
      return
    end

    charge = Stripe::Charge.create(
      :amount => @amount,
      :currency => 'usd',
      :source => params[:stripeToken],
      :description => 'AHEC Modules Wallet Transfer',
      :metadata => {"user_id" => current_user.id}
    )

    if charge
      current_user.balance += (@amount.to_f / 100)
      current_user.save
    end 

    redirect_to edit_user_registration_path

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_charge_path
  end
end
