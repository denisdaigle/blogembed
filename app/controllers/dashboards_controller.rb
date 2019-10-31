class DashboardsController < ApplicationController
  
  def view
      #show user dashboard.
      respond_to do |format|
          format.html { render action: 'dashboard' }
      end
  end
  
end
