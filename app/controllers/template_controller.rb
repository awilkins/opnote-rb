class TemplateController < ApplicationController

  def index
    list
    render(:action => 'list')
  end

  def list
    flash.keep(:op_note)
    @surgeons = OpTemplate.find(:all, :group => 'surgeon', :order => 'surgeon')
  end
  
  #This is a dirty hack.
  #User registration really is a major requirement.
  def list_for
    flash.keep(:op_note)
    template = OpTemplate.find(params[:id])
    @op_templates = OpTemplate.find(:all, :conditions => [ "surgeon = ?", template.surgeon], :order => 'operation')
    render(:partial => 'templates_for')
  end

  def new
    @op_template = OpTemplate.new
  end

  def create
    @op_template = OpTemplate.new(params[:op_template])
    if @op_template.save
      flash[:notice] = 'Your Operation template was successfully created.'
      redirect_to(:action => 'list')
    else
      render(:action => 'new')
    end
  end

  def edit
    @op_template = OpTemplate.find(params[:id])
  end

  def update
    @op_template = OpTemplate.find(params[:id])
    if @op_template.update_attributes(params[:op_template])
      flash[:notice] = 'Your Operation Template was successfully updated.'
      redirect_to(:action => 'list')
    else
      render(:action => 'edit')
    end
  end

  def destroy
    op_template = OpTemplate.find(params[:id])
    op_template.destroy
    flash[:notice] = 'The Operation Template has been deleted.'
    redirect_to(:action => 'list')
  end
  
  def use
    op_note = flash[:op_note] || OpNote.new
    op_template = OpTemplate.find(params[:id])

    op_note.surgeon1 = op_template.surgeon
    op_note.operation = op_template.operation
    op_note.position = op_template.position
    op_note.incision = op_template.incision
    op_note.proc_text = op_template.proc_text
    op_note.post_op = op_template.post_op
    
    flash[:op_note] = op_note
    
    redirect_to(:controller => 'note', :action => 'new')
  end
  
  def skip
    flash.keep(:op_note)
    redirect_to(:controller => 'note', :action => 'new')    
  end
end
