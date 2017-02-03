module ApplicationHelper

  def site_name
    # Change the value below between the quotes.
    "Up4"
  end

  def meta_author
    # Change the value below between the quotes.
    "Lucas Paolella"
  end

  def meta_description
    # Change the value below between the quotes.
    "The fastest way to meet new friends on the go!"
  end

  def meta_keywords
    # Change the value below between the quotes.
    "Up4 What are you up for meetup connection friend"
  end

  # Returns the full title on a per-page basis.
  # No need to change any of this we set page_title and site_name elsewhere.
  def full_title(page_title)
    if page_title.empty?
      site_name
    else
      "#{page_title} | #{site_name}"
    end
  end

  def bootstrap_class_for flash_type
    case flash_type
      when "success"
        "alert-success"
      when "error"
        "alert-danger"
      when "danger"
        "alert-danger"
      when "alert"
        "alert-danger"
      when "notice"
        "alert-success"
      when "info"
        "alert-info"
      else
        flash_type.to_s
    end
  end

end
