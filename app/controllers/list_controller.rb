class ListController < ApplicationController

  def index
    list
    render(:action => 'list')
  end

  def list
    @op_lists = OpList.paginate :page => params[:page], :order => 'start_time DESC'
  end

  def new
    @op_list=OpList.new
  end

  def create
    @op_list = OpList.new(params[:op_list])    
    if @op_list.save
      flash[:notice] = 'Your Operation list was successfully created.'
      redirect_to(:action => 'view', :id => @op_list.id)
    else
      render(:action => 'new')
    end
  end

  def edit
    @op_list = OpList.find(params[:id])
  end

  def update
    @op_list = OpList.find(params[:id])
    if @op_list.update_attributes(params[:op_list])
      flash[:notice] = 'Your Operation list was successfully updated.'
      redirect_to(:action => 'view', :id => @op_list.id)
    else
      render(:action => 'edit')
    end
  end

  def destroy
    op_list = OpList.find(params[:id])
    op_list.destroy
    redirect_to(:action => 'list')
  end

  def view
    @op_list = OpList.find(params[:id])
  end

  def new_entry
    @op_list = OpList.find(params[:id])
    @op_list_entry = OpListEntry.new()
  end

  def create_entry
    @op_list = OpList.find(params[:id])
    @op_list_entry = OpListEntry.new(params[:op_list_entry])
    
    if @op_list.op_list_entries << @op_list_entry
      flash[:notice] = 'Your Operation was successfully added.'
      redirect_to(:action => 'view', :id => params[:id])
    else
      render(:action => 'new_entry')
    end
  end

  def edit_entry
    @op_list_entry = OpListEntry.find(params[:id])
    @op_list = @op_list_entry.op_list
  end
  
  def update_entry
    @op_list_entry = OpListEntry.find(params[:id])
    @op_list = @op_list_entry.op_list
    if @op_list_entry.update_attributes(params[:op_list_entry])
      flash[:notice] = 'Your Operation was successfully updated.'
      redirect_to(:action => 'view', :id => @op_list.id)
    else
      render(:action => 'edit_entry')
    end
  end

  def destroy_entry
    op_list_entry = OpListEntry.find(params[:id])
    op_list_entry.destroy
    flash[:notice] = 'The Operation has been deleted.'
    redirect_to(:action => 'view', :id => op_list_entry.op_list.id)
  end
  
  def sort_entries
    @op_list = OpList.find(params[:id])
    @op_list.op_list_entries.each do |list_entry|
      list_entry.position = params[:oplist].index(list_entry.id.to_s) + 1
      list_entry.save
    end
    
    render(:nothing => true)
  end
  
  def note
    op_note = OpNote.new
    op_list_entry = OpListEntry.find(params[:id])

    op_note.crn = op_list_entry.crn
    op_note.dob = op_list_entry.dob
    op_note.surname = op_list_entry.surname
    op_note.forename = op_list_entry.forename
    op_note.sex = op_list_entry.sex
    op_note.operation = op_list_entry.operation
    
    flash[:op_note] = op_note
    
    redirect_to(:controller => 'template', :action => 'list')
  end

  def pdf
    op_list=OpList.find(params[:id])
    pdf_list=make_pdf(op_list)
    send_data(pdf_list, :filename => 'oplist.pdf', :type => 'application/pdf')
  end

  def auto_complete_for_op_list_anaesthetist
    @anaesthetists = get_anaesthetists(params[:op_list][:anaesthetist])
    render(:partial => 'anaesthetists')                                       
  end
  
  
  
  private
  
  def make_pdf(op_list)
    require 'rubygems'
    require 'pdf/writer'
    
    pdf = PDF::Writer.new(:paper => 'A4', :orientation => :landscape)
    l_margin=pdf.absolute_left_margin
    pdf.select_font('Helvetica-Bold')
    
    pdf.text('OPERATION LIST', :font_size => 20, :justification => :center)
    
    pdf.text("\nHospital: ARI   " <<
             "Surgeon: #{op_list.surgeon}   " <<
             "Anaesthetist: #{op_list.anaesthetist}   " <<
             "Theatre: #{op_list.theatre}   " <<
             "Date: #{op_list[:start_time].strftime('%d/%m/%Y')}   " <<
             "Time: #{op_list[:start_time].strftime('%H:%M')}", 
             :font_size => 12, :justification => :center)
             
    op_list.op_list_entries.each do |entry|
      pdf.select_font('Helvetica-Bold')
      pdf.text("\n#{entry.surname}, #{entry.forename}", :font_size => 14)
      pdf.add_text(l_margin + 200, pdf.y, entry.sex)
      pdf.add_text(l_margin + 280, pdf.y, entry.dob.strftime('%d/%m/%Y'))
      pdf.add_text(l_margin + 380, pdf.y, entry.crn)
      pdf.add_text(l_margin + 500, pdf.y, "Ward #{entry.ward}")
      
      pdf.select_font('Times-Roman')
      pdf.text(entry.operation)
      pdf.text(entry.notes, :font_size => 12)
    end
    
    pdf.select_font('Helvetica')
    pdf.text("\n\nI certify that this list is accurate: <b>#{op_list.list_author_name}</b>", :font_size => 14)
        
    pdf.render
  end

end