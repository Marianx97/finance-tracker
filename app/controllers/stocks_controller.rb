class StocksController < ApplicationController
  def search
    if params[:stock].present?
      @stock = Stock.new_lookup(params[:stock])

      puts '@stock' + @stock.to_s

      if !@stock
        flash.now[:alert] = 'Please enter a valid symbol to search'
      end
    else
      flash.now[:alert] = 'Please enter a symbol to search'
    end

    render turbo_stream: turbo_stream.replace('results_turbo_stream', partial: 'users/results')
  end
end
