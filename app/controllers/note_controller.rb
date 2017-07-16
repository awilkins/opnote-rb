class NoteController < ApplicationController

  def index
    list
    render(:action => 'list')
  end

  def list
    @op_notes = OpNote.paginate :page => params[:page], :order => 'start_time DESC'
  end

  def new
    @op_note = flash[:op_note] || OpNote.new
  end

  def create
    @op_note = OpNote.new(params[:op_note])
    if @op_note.save
      flash[:notice] = 'Your Operation note was successfully created.'
      redirect_to(:action => 'list')
    else
      render(:action => 'new')
    end
  end

  def edit
    @op_note = OpNote.find(params[:id])
  end

  def update
    @op_note = OpNote.find(params[:id])
    if @op_note.update_attributes(params[:op_note])
      flash[:notice] = 'Your Operation note was successfully updated.'
      redirect_to(:action => 'list')
    else
      render(:action => 'edit')
    end
  end

  def destroy
    op_note = OpNote.find(params[:id])
    op_note.destroy
    flash[:notice] = 'The Operation note has been deleted.'
    redirect_to(:action => 'list')
  end
  
  def find
  end
  
  def found
    #Build the search string
    search_str = ''
    get_params = Hash.new       # Used for paginator links
    sql_params = Hash.new       # Params are wrapped in '%' for LIKE search

    ['crn', 'surname', 'forename', 'cons_surg', 'surgeon', 'assistant'].each do |i|
      unless(params[:"#{i}"].blank?)
        search_str << ' AND ' unless search_str.blank?
        
        if(i == 'surgeon' || i == 'assistant')
          search_str << "(#{i}1 LIKE :#{i} OR #{i}2 LIKE :#{i} OR #{i}3 LIKE :#{i})"
        else
          search_str << "#{i} LIKE :#{i}"
        end

        get_params[:"#{i}"] = params[:"#{i}"]
        sql_params[:"#{i}"] = '%' + params[:"#{i}"] + '%'
      end
    end
    
    #If search string blank, return to search page.
    if(search_str.blank?)
      flash[:notice] = 'No search criteria specified.'
      redirect_to(:action => 'find')
      return
    end
    
    #Do search    
    @op_notes = OpNote.paginate :page => params[:page], :conditions => [search_str, sql_params], :order => 'start_time DESC'
    
    #If no results, return to search page, otherwise, show results.
    if(@op_notes.length == 0)
      flash[:notice] = 'No operations found.'
      redirect_to(:action => 'find')
    else
      @search_params = get_params
      render(:action => 'list')
    end
  end
  
  def logbook
  end
  
  def logbook_csv
    op_notes=OpNote.find(:all, :conditions => ['cons_surg LIKE :surgeon OR surgeon1 LIKE :surgeon OR surgeon2 LIKE :surgeon OR surgeon3 LIKE :surgeon OR assistant1 LIKE :surgeon OR assistant2 LIKE :surgeon OR assistant3 LIKE :surgeon', {:surgeon => '%' + params[:surgeon] + '%'}], :order => 'start_time')

    if(op_notes.length == 0)
      flash[:notice] = 'No operations found.'
      redirect_to(:action => 'logbook')
      return
    end
    
    require 'csv'
    log_string = ''
    CSV::Writer.generate(log_string) do |csv|
      csv << ['Unit number', 'DOB', 'Surname', 'Forename', 'Sex', 'ASA', 'Consultant', 'Date', 'Start time', 'End time', 'Urgency', 'Operation', 'Surgeon1', 'Surgeon2', 'Surgeon3', 'Assistant1', 'Assistant2', 'Assistant3']
      op_notes.each do |note|
        csv << [note.crn, note.dob, note.surname, note.forename, note.sex, note.asa, note.cons_surg, note.start_time.strftime('%d/%m/%Y'), note.start_time.strftime('%H:%M'), note.end_time.strftime('%H:%M'), note.cepod, note.operation, note.surgeon1, note.surgeon2, note.surgeon3, note.assistant1, note.assistant2, note.assistant3]
      end
    end
    
    send_data(log_string, :filename => 'logbook.csv', :type => 'text/csv')
  end
  
  def pdf
    op_note=OpNote.find(params[:id])
    pdf_note=make_pdf(op_note)
    send_data(pdf_note, :filename => 'opnote.pdf', :type => 'application/pdf')
  end
  
  def auto_complete_for_op_note_cons_anaes
    @anaesthetists = get_consultant_anaesthetists(params[:op_note][:cons_anaes])
    render(:partial => 'anaesthetists')                                       
  end
  
  def auto_complete_for_op_note_anaesthetist1
    @anaesthetists = get_anaesthetists(params[:op_note][:anaesthetist1])
    render(:partial => 'anaesthetists')                                       
  end
  
  def auto_complete_for_op_note_anaesthetist2
    @anaesthetists = get_anaesthetists(params[:op_note][:anaesthetist2])
    render(:partial => 'anaesthetists')                                       
  end
  
  def auto_complete_for_op_note_anaesthetist3
    @anaesthetists = get_anaesthetists(params[:op_note][:anaesthetist3])
    render(:partial => 'anaesthetists')                                       
  end
  
  
  
  private
  
  def make_pdf(opnote)
    require 'rubygems'
    require 'pdf/writer'
    
    pdf = PDF::Writer.new(:paper => 'A4')
    l_margin=pdf.absolute_left_margin
    
    pdf.select_font('Helvetica-Bold')
    pdf.text('OPERATION NOTE', :font_size => 24)
    
    #Patient
    pdf.text(opnote[:surname].upcase + ', ' + 
             opnote[:forename].upcase, :font_size => 16)
             
    pdf.text(opnote[:sex])
    pdf.add_text(l_margin + 80, pdf.y, opnote[:dob].strftime('%d/%m/%Y'))
    pdf.add_text(l_margin + 180, pdf.y, opnote[:crn])
    
    pdf.select_font('Helvetica')
    pdf.font_size = 12
    
    #Diagnosis & operation
    pdf_text_helper(pdf, "\n<b>Diagnosis</b>", 80, opnote[:diagnosis])
    pdf_text_helper(pdf, "<b>Operation</b>", 80, opnote[:operation])
    
    #Times etc
    pdf.text("\n<b>Date</b>")
    pdf.add_text(l_margin + 80, pdf.y, opnote[:start_time].strftime('%d/%m/%Y'))
    pdf.add_text(l_margin + 180, pdf.y, "<b>Urgency</b>")
    pdf.add_text(l_margin + 280, pdf.y, opnote[:cepod])
    
    pdf.text("<b>Start</b>")
    pdf.add_text(l_margin + 80, pdf.y, opnote[:start_time].strftime('%H:%M'))
    pdf.add_text(l_margin + 180, pdf.y, "<b>ASA</b>")
    pdf.add_text(l_margin + 280, pdf.y, opnote[:asa])
    
    pdf.text("<b>Finish</b>")
    pdf.add_text(l_margin + 80, pdf.y, opnote[:end_time].strftime('%H:%M'))
    pdf.add_text(l_margin + 180, pdf.y, "<b>Anaesthetic</b>")
    pdf.add_text(l_margin + 280, pdf.y, opnote[:anaesthetic])
    
    #Personnel
    pdf_text_helper(pdf, "\n<b>Cons Surg</b>", 80, opnote[:cons_surg])
    pdf_text_helper(pdf, "<b>Cons Anaes</b>", 80, (opnote[:cons_anaes].blank? ? "none" : opnote[:cons_anaes]))
    
    s=opnote[:surgeon1]
    unless(opnote[:surgeon2].blank?) : s << ' / ' << opnote[:surgeon2] end
    unless(opnote[:surgeon3].blank?) : s << ' / ' << opnote[:surgeon3] end
    pdf_text_helper(pdf, "\n<b>Surgeon</b>", 80, s)
    
    if(opnote[:assistant1].blank?)
      s='none'
    else
      s=opnote[:assistant1]
      unless(opnote[:assistant2].blank?) : s << ' / ' << opnote[:assistant2] end
      unless(opnote[:assistant3].blank?) : s << ' / ' << opnote[:assistant3] end
    end
    pdf_text_helper(pdf, "<b>Assistant</b>", 80, s)
    
    if(opnote[:anaesthetist1].blank?)
      s='none'
    else
      s=opnote[:anaesthetist1]
      unless(opnote[:anaesthetist2].blank?) : s << ' / ' << opnote[:anaesthetist2] end
      unless(opnote[:anaesthetist3].blank?) : s << ' / ' << opnote[:anaesthetist3] end
    end
    pdf_text_helper(pdf, "<b>Anaesthetist</b>", 80, s)
    
    #Prophylaxis
    dvt=''
    if(opnote[:dvt_lmwh]) : dvt << 'LMWH' end
    
    if(opnote[:dvt_ted])
      unless(dvt.blank?) : dvt << ', ' end
      dvt << 'Stockings'
    end

    if(opnote[:dvt_pneum])
      unless(dvt.blank?) : dvt << ', ' end
      dvt << 'Pneumatic'
    end
    
    if(opnote[:dvt_aspirin])
      unless(dvt.blank?) : dvt << ', ' end
      dvt << 'Aspirin'
    end

    if(dvt.blank?) : dvt << 'none' end
    
    pdf_text_helper(pdf, "\n<b>DVT Proph</b>", 80, dvt)
    pdf_text_helper(pdf, "<b>Antibiotics</b>", 80, opnote[:antibiotics])
    
    #Procedure etc
    pdf_text_helper(pdf, "\n<b>Indication</b>", 80, opnote[:indication])
    pdf_text_helper(pdf, "\n<b>Position</b>", 80, opnote[:position])
    pdf_text_helper(pdf, "\n<b>Incision</b>", 80, opnote[:incision])
    pdf_text_helper(pdf, "\n<b>Findings</b>", 80, opnote[:findings])
    
    proc_text=opnote[:proc_text].chomp
    unless(opnote[:cancer]=='No') : proc_text << "\n\nThis was a <b>" << opnote[:cancer].downcase << "</b> operation for malignant disease." end
    pdf_text_helper(pdf, "\n<b>Procedure</b>", 80, proc_text)
    
    pdf_text_helper(pdf, "\n<b>Blood loss</b>", 80, opnote[:ebl])
    pdf_text_helper(pdf, "<b>Transfusion</b>", 80, opnote[:transfusion])    

    pdf_text_helper(pdf, "\n<b>Post-op</b>", 80, opnote[:post_op])
    
    pdf.render
  end
  
  def pdf_text_helper(pdf, label, inset, text)
    x = pdf.absolute_left_margin + inset
    w = pdf.absolute_right_margin - x
    
    pdf.text(label)
    
    lines = text.split(/\n/, 2)
    
    #Splitting an empty string produces 'nil'. Check for this.
    if(lines[0])
      more = pdf.add_text_wrap(x, pdf.y, w, lines[0])
      
      if(more.length != 0 && lines.length == 2) : more << "\n" end
      if(lines.length == 2) : more << lines[1] end
      
      pdf.text(more, :absolute_left => x)
    end
  end
end
