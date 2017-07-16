# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # Returns a string with a div containing all the error messages for the object located as an instance variable by the name
  # of <tt>object_name</tt>. This div can be tailored by the following options:
  #
  # * <tt>header_tag</tt> - Used for the header of the error div (default: h2)
  # * <tt>id</tt> - The id of the error div (default: errorExplanation)
  # * <tt>class</tt> - The class of the error div (default: errorExplanation)
  # * <tt>obj_title</tt> - A 'real' name for the object
  # * <tt>realname</tt> - A hash of column => real names
  #
  # NOTE: This is a pre-packaged presentation of the errors with embedded strings and a certain HTML structure. If what
  # you need is significantly different from the default presentation, it makes plenty of sense to access the object.errors
  # instance yourself and set it up. View the source of this method to see how easy it is.
  def human_error_messages_for(object_name, options = {})
    options = options.symbolize_keys
    object = instance_variable_get("@#{object_name}")
    options[:obj_title] = object_name.to_s.gsub("_", " ") unless options.has_key?(:obj_title)
    unless object.errors.empty?
      content_tag("div",
        content_tag(
          options[:header_tag] || "h2",
          "#{pluralize(object.errors.count, "error")} prohibited this #{options[:obj_title]} from being saved"
        ) +
        content_tag("p", "There were problems with the following fields:") +
        content_tag("ul", object.errors.collect { |err| 
        content_tag("li", ((options.has_key?(:realname) && options[:realname].has_key?(err[0]))? options[:realname][err[0]] : err[0].capitalize) + ' ' + err[1] )}),
        "id" => options[:id] || "errorExplanation", "class" => options[:class] || "errorExplanation"
      )
    end
  end

end
