describe Todo do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.not_to allow_value(nil).for(:complete) }
  end
end
