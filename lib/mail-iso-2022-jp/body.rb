# coding: utf-8

::Mail::Body.prepend(Module.new do
  def initialize(string = '')
    if string.respond_to?(:encoding) && string.encoding.to_s == 'ISO-2022-JP'
      string.force_encoding('US-ASCII')
    end
    super(string)
  end
end)
