# coding: utf-8

require 'mail'

module Mail
  superklass = Gem::Version.new(Mail::VERSION.version) >= Gem::Version.new("2.8.0") ? NamedUnstructuredField : UnstructuredField

  class SubjectField < superklass
    include FieldWithIso2022JpEncoding
    def b_value_encode(string)
      encode64(string)
    end
  end
end
