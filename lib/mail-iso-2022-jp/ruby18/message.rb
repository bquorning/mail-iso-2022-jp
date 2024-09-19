require 'mail'
require 'nkf'

# Patches for Mail::Message on Ruby 1.8.7
::Mail::Message.prepend(Module.new do
  def process_body_raw
    if @charset.to_s.downcase == 'iso-2022-jp'
      @body_raw = Mail::Preprocessor.process(@body_raw)
      @body_raw = NKF.nkf(NKF_OPTIONS, @body_raw)
    end
    super
  end

  def text_part=(msg = nil)
    if @charset.to_s.downcase == 'iso-2022-jp' && msg && msg.charset.nil?
      msg.charset = @charset
    end
    super(msg)
  end
end)
