# coding: utf-8
# A date parser to handle unusual dates and edge cases
module DateParser
  # Remap all of the dates
  def remap_dates(index_name, item_type, doc_data)
    datasource = get_dataspec_for_project_source(index_name, item_type)
    
    # Parse/remap date fields
    doc_data.each do |key, value|
      if is_date_field?(datasource, key)
        doc_data[key] = parse_date(value)
      else
        doc_data[key] = value
      end
    end
  end
  
  # Check if field is a date field
  def is_date_field?(datasource, field_name)
    display_type = datasource["source_fields"][field_name]["display_type"] if datasource["source_fields"][field_name]
    return display_type == "Date" || display_type == "DateTime"
  end

  # Parse the date field and handle messy date names
  def parse_date(date)
    date = handle_unknown_present_date(date)
    date = translate_dates(date) if (!date.is_a?(Date) && date)
    date = handle_year_dates(date.to_s.strip.lstrip) if date.to_s.strip.lstrip.length == 4
    (date && !date.is_a?(Date)) ? (return Date.parse(date)) : (return date)
  end

  # Handle dates that are years
  def handle_year_dates(date)
    if /^[12]\d{3}$/ =~ date
      return Date.parse(date+"-01-01") # Maybe not an ideal default
    end
  end
  
  # Translate dates in a different language
  def translate_dates(date)
    de_dates = {
      "Januar" => "January",
      "Februar" => "February",
      "März" => "March",
      "Mai" => "May",
      "Juni" => "June",
      "Juli" => "July",
      "Oktober" => "October",
      "Dezember" => "December"
    }

    # Replace dates as needed
    de_dates.each do |de, en|
      date = date.gsub(de, en)
    end
    return date
  end

  # Blank dates that are unknown or present
  def handle_unknown_present_date(date)
    dates_to_blank = ["Date unknown", "Unknown", "nodate", "0000-00-00 00:00:00",
                      "Present", "Current", "Gegenwart", "None", "Heute"]

    # Check if date field includes any of the items in dates_to_blank array, and return nil if so
    return nil if date == ""
    dates_to_blank.any?{|to_blank| !date.is_a?(Date) && date.to_s.include?(to_blank)} ? (return nil) : (return date)
  end
end
