class TemplateFieldMerger

  def self.merge_fields(merge_fields, db_rows)
    merged_template_rows = []
    db_rows.each do |row|
      row.shift(2) # id and email fields are not merge fields
      merged_row_fields = []
      merge_fields.each_with_index do |tag, i|
        merged_row_fields << { name: tag, content: row[i] }
      end
      merged_template_rows << merged_row_fields
    end
    merged_template_rows
  end

end
