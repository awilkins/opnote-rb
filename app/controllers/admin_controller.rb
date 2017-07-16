require 'csv'

class AdminController < ApplicationController
  def update_anaesthetists
    if request.post?
      begin
        Anaesthetist.transaction do
          Anaesthetist.destroy_all
          CSV.parse(params[:anaesthetists].read) do |row|
            gasman=Anaesthetist.new()
            gasman.surname = name_capitalize(row[0])
            gasman.initials = row[1].upcase
            gasman.consultant = (row[2].casecmp('y') == 0)
            gasman.save
          end
        end
        @flash[:notice] = "Update successful."
      rescue
        @flash[:notice] = "Update failed. Perhaps the file was not in the correct format."
      end
    end
  end
  
  private
  
  def name_capitalize(name)
    #Check for Mc/Mac
    if(name =~ /^(ma?c)(\w*)$/i)
      return ($1.capitalize + $2.capitalize)
    end
    
    #Check for double barrel
    if(name =~ /^(\w+)-(\w+)$/i)
      return ($1.capitalize + '-' + $2.capitalize)
    end
    
    #Default
    name.capitalize
  end
end
