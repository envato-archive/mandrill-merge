require 'spec_helper'

describe TemplateFieldMerger do

  let(:database_rows) do
    [
      ['1', 'test@example.com',  'FRED', 'BASSETT'],
      ['2', 'test2@example.com', 'HANS', 'OLO']
    ]
  end

  subject(:merged_fields) { TemplateFieldMerger.merge_fields(template_fields, database_rows) }

  context 'when there are multiple template fields' do
    let(:template_fields) { ['FIRSTNAME', 'SURNAME'] }

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

  context 'when there is a single template fields' do
    let(:template_fields) { ['FIRSTNAME'] }

    it 'should contain two merged rows' do
      expect(merged_fields.size).to be 2
    end

    it 'should merge each database row into an array containing a single hash' do
      expected_structure = [
        [{ name: 'FIRSTNAME', content: 'FRED' }],
        [{ name: 'FIRSTNAME', content: 'HANS' }]
      ]
      expect(merged_fields).to eq expected_structure
    end
  end
end
