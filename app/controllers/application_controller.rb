class ApplicationController < ActionController::Base
    
    def ask
       
        @question = params[:q]
        @action = params[:a]
      
        #Resulting HTML file from setup save attempt.
        respond_to do |format|
            format.js { render action: 'yes_no_popup' }
        end
        
    end
    
    def inform
       
        @info = params[:i]
      
        #Resulting HTML file from setup save attempt.
        respond_to do |format|
            format.js { render action: 'info_popup' }
        end
        
    end
    
end
