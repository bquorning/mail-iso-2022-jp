module MailIso2022Jp
  module Preprocessor
    def self.process(value)
      value.to_s
        .gsub(/#{WAVE_DASH}/o, FULLWIDTH_TILDE)
        .gsub(/#{MINUS_SIGN}/o, FULLWIDTH_HYPHEN_MINUS)
        .gsub(/#{EM_DASH}/o, HORIZONTAL_BAR)
        .gsub(/#{DOUBLE_VERTICAL_LINE}/o, PARALLEL_TO)
    end
  end
end
