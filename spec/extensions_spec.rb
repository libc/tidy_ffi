require 'spec_helper'

describe TidyFFI::TidyFFIExtensions do
  include TidyFFI::TidyFFIExtensions

  describe '#find_tidy' do
    it 'raises TidyFFI::LibTidyNotInstalled if the library could not be found' do
      stub(File).exists? { false }
      expect { find_tidy }.to raise_error(TidyFFI::LibTidyNotInstalled)
    end
  end
end
