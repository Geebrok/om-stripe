class ChargesController < ApplicationController

	def create

	  customer = Stripe::Customer.create(
	    :email => params[:stripeEmail],
	    :source  => params[:stripeToken]
	  )

	  charge = Stripe::Charge.create(
	    :customer    => customer.id,
	    :amount      => params[:amount],
	    :description => 'Growth Hacking Crash Course',
	    :currency    => 'usd'
	  )

	  purchase = Purchase.create(email: params[:stripeEmail], description: charge.description, currency: charge.currency, customer_id: customer.id, card: params[:stripeToken], amount: params[:amount], product_id: 1)

	  redirect_to purchase

	rescue Stripe::CardError => e
	  flash[:error] = e.message
	  redirect_to new_charge_path
	end

end
