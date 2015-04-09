require 'spec_helper'

describe TemplateFieldMerger do

  let(:template_fields) { ['FIRSTNAME', 'SURNAME'] }
  let(:database_rows) do 
    [
      ['1', 'test@example.com',  'FRED', 'BASSETT'],
      ['2', 'test2@example.com', 'HANS', 'OLO']
    ]
  end

  subject(:merged_fields) { TemplateFieldMerger.merge_fields(template_fields, database_rows) }

  it 'should contain two merged rows' do
    expect(merged_fields.size).to be 2
  end

  it 'should merge each database row into an array of hashes' do
    expected_structure = [
      [{ name: 'FIRSTNAME', content: 'FRED' }, { name: 'SURNAME', content: 'BASSETT' }],
      [{ name: 'FIRSTNAME', content: 'HANS' }, { name: 'SURNAME', content: 'OLO' }]
    ]
    expect(merged_fields).to eq expected_structure
  end

end
