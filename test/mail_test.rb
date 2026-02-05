$:.unshift File.dirname(__FILE__)
require "test_helper"
require "nkf"
require "mail"
require "mail-iso-2022-jp"

class MailTest < Minitest::Test
  def test_sends_with_ISO_2022_JP_encoding
    mail = Mail.new(charset: "ISO-2022-JP") do
      from "山田太郎 <taro@example.com>"
      sender "X事務局 <info@example.com>"
      reply_to "X事務局 <info@example.com>"
      to "佐藤花子 <hanako@example.com>"
      cc "X事務局 <info@example.com>"
      resent_from "山田太郎 <taro@example.com>"
      resent_sender "X事務局 <info@example.com>"
      resent_to "佐藤花子 <hanako@example.com>"
      resent_cc "X事務局 <info@example.com>"
      subject "日本語 件名"
      body "日本語本文"
    end

    assert_equal "ISO-2022-JP", mail.charset
    assert_equal NKF::JIS, NKF.guess(mail.subject)
    assert_equal "From: =?ISO-2022-JP?B?GyRCOzNFREJATzobKEI=?= <taro@example.com>\r\n", mail[:from].encoded
    assert_equal "Sender: =?ISO-2022-JP?B?WBskQjt2TDM2SRsoQg==?= <info@example.com>\r\n", mail[:sender].encoded
    assert_equal "Reply-To: =?ISO-2022-JP?B?WBskQjt2TDM2SRsoQg==?= <info@example.com>\r\n", mail[:reply_to].encoded
    assert_equal "To: =?ISO-2022-JP?B?GyRCOjRGIzJWO1IbKEI=?= <hanako@example.com>\r\n", mail[:to].encoded
    assert_equal "Cc: =?ISO-2022-JP?B?WBskQjt2TDM2SRsoQg==?= <info@example.com>\r\n", mail[:cc].encoded
    assert_equal "Resent-From: =?ISO-2022-JP?B?GyRCOzNFREJATzobKEI=?= <taro@example.com>\r\n", mail[:resent_from].encoded
    assert_equal "Resent-Sender: =?ISO-2022-JP?B?WBskQjt2TDM2SRsoQg==?= <info@example.com>\r\n", mail[:resent_sender].encoded
    assert_equal "Resent-To: =?ISO-2022-JP?B?GyRCOjRGIzJWO1IbKEI=?= <hanako@example.com>\r\n", mail[:resent_to].encoded
    assert_equal "Resent-Cc: =?ISO-2022-JP?B?WBskQjt2TDM2SRsoQg==?= <info@example.com>\r\n", mail[:resent_cc].encoded
    assert_equal "Subject: =?ISO-2022-JP?B?GyRCRnxLXDhsGyhCIBskQjdvTD4bKEI=?=\r\n", mail[:subject].encoded
    assert_equal NKF::JIS, NKF.guess(mail.body.encoded)
  end

  def test_sends_with_ISO_2022_JP_encoding_and_empty_subject
    mail = Mail.new(charset: "ISO-2022-JP") do
      from "山田太郎 <taro@example.com>"
      to "佐藤花子 <hanako@example.com>"
      cc "X事務局 <info@example.com>"
      subject "Hello"
      body "日本語本文"
    end

    assert_equal "ISO-2022-JP", mail.charset
    assert_equal "From: =?ISO-2022-JP?B?GyRCOzNFREJATzobKEI=?= <taro@example.com>\r\n", mail[:from].encoded
    assert_equal "To: =?ISO-2022-JP?B?GyRCOjRGIzJWO1IbKEI=?= <hanako@example.com>\r\n", mail[:to].encoded
    assert_equal "Cc: =?ISO-2022-JP?B?WBskQjt2TDM2SRsoQg==?= <info@example.com>\r\n", mail[:cc].encoded

    assert_equal "Subject: Hello\r\n", mail[:subject].encoded
    assert_equal NKF::JIS, NKF.guess(mail.body.encoded)
  end

  def test_encodes_header
    mail = Mail.new(charset: "ISO-2022-JP") do
      header "Subject: hello world\r\n"
    end

    assert_equal "Subject: hello world\r\n", mail.header.encoded
  end

  def test_sends_with_ISO_2022_JP_encoding_and_quoted_display_name
    mail = Mail.new(charset: "ISO-2022-JP") do
      from '" <Yamada 太郎>" <taro@example.com>'
      to '"<佐藤 Hanako> " <hanako@example.com>'
      cc '" <X事務局> " <info@example.com>'
      subject ""
      body "日本語本文"
    end

    assert_equal "ISO-2022-JP", mail.charset
    assert_equal "From: =?ISO-2022-JP?B?Ig==?= =?ISO-2022-JP?B?PFlhbWFkYQ==?= =?ISO-2022-JP?B?GyRCQkBPOhsoQj4i?= <taro@example.com>\r\n", mail[:from].encoded
    assert_equal "To: =?ISO-2022-JP?B?IjwbJEI6NEYjGyhC?= =?ISO-2022-JP?B?SGFuYWtvPg==?= =?ISO-2022-JP?B?Ig==?= <hanako@example.com>\r\n", mail[:to].encoded
    assert_equal "Cc: =?ISO-2022-JP?B?Ig==?= =?ISO-2022-JP?B?PFgbJEI7dkwzNkkbKEI+?= =?ISO-2022-JP?B?Ig==?= <info@example.com>\r\n", mail[:cc].encoded

    if Gem::Version.new(Mail::VERSION.version) >= Gem::Version.new("2.7")
      assert_equal "", mail[:subject].encoded
    else
      assert_equal "Subject: \r\n", mail[:subject].encoded
    end

    assert_equal NKF::JIS, NKF.guess(mail.body.encoded)
  end

  def test_sends_with_UTF_8_encoding
    mail = Mail.new do
      from "山田太郎 <taro@example.com>"
      to "佐藤花子 <hanako@example.com>"
      cc "事務局 <info@example.com>"
      subject "日本語件名"
      body "日本語本文"
    end

    assert_equal "UTF-8", mail.charset
    assert_equal NKF::UTF8, NKF.guess(mail.subject)
    assert_equal "From: =?UTF-8?B?5bGx55Sw5aSq6YOO?= <taro@example.com>\r\n", mail[:from].encoded
    assert_equal "To: =?UTF-8?B?5L2Q6Jek6Iqx5a2Q?= <hanako@example.com>\r\n", mail[:to].encoded
    assert_equal "Cc: =?UTF-8?B?5LqL5YuZ5bGA?= <info@example.com>\r\n", mail[:cc].encoded
    assert_equal "Subject: =?UTF-8?Q?=E6=97=A5=E6=9C=AC=E8=AA=9E=E4=BB=B6=E5=90=8D?=\r\n", mail[:subject].encoded
    assert_equal NKF::UTF8, NKF.guess(mail.body.encoded)
  end

  def test_handles_array_correctly
    mail = Mail.new(charset: "ISO-2022-JP") do
      from ["山田太郎 <taro@example.com>", "山田次郎 <jiro@example.com>"]
      to ["佐藤花子 <hanako@example.com>", "佐藤好子 <yoshiko@example.com>"]
      cc ["X事務局 <info@example.com>", "事務局長 <boss@example.com>"]
      subject "日本語件名"
      body "日本語本文"
    end

    assert_equal "From: =?ISO-2022-JP?B?GyRCOzNFREJATzobKEI=?= <taro@example.com>, \r\n =?ISO-2022-JP?B?GyRCOzNFRDwhTzobKEI=?= <jiro@example.com>\r\n", mail[:from].encoded
    assert_equal "To: =?ISO-2022-JP?B?GyRCOjRGIzJWO1IbKEI=?= <hanako@example.com>, \r\n =?ISO-2022-JP?B?GyRCOjRGIzklO1IbKEI=?= <yoshiko@example.com>\r\n", mail[:to].encoded
    assert_equal "Cc: =?ISO-2022-JP?B?WBskQjt2TDM2SRsoQg==?= <info@example.com>, \r\n =?ISO-2022-JP?B?GyRCO3ZMMzZJRDkbKEI=?= <boss@example.com>\r\n", mail[:cc].encoded
  end

  def test_raises_exeception_if_the_encoding_of_subject_is_not_UTF_8
    assert_raises MailIso2022Jp::InvalidEncodingError do
      Mail.new(charset: "ISO-2022-JP") do
        from ["山田太郎 <taro@example.com>"]
        to ["佐藤花子 <hanako@example.com>"]
        subject NKF.nkf("-Wj", "日本語 件名")
        body "日本語本文"
      end
    end
  end

  def test_raises_exeception_if_the_encoding_of_mail_body_is_not_UTF_8
    assert_raises MailIso2022Jp::InvalidEncodingError do
      Mail.new(charset: "ISO-2022-JP") do
        from ["山田太郎 <taro@example.com>"]
        to ["佐藤花子 <hanako@example.com>"]
        subject "日本語件名"
        body NKF.nkf("-Wj", "日本語本文")
      end
    end
  end

  def test_handles_wave_dash_U_301C_and_fullwidth_tilde_U_FF5E_correctly
    wave_dash = [0x301c].pack("U")
    fullwidth_tilde = [0xff5e].pack("U")

    text1 = "#{wave_dash}#{fullwidth_tilde}"
    text2 = "#{wave_dash}#{wave_dash}"

    mail = Mail.new(charset: "ISO-2022-JP") do
      from "taro@example.com"
      to "hanako@example.com"
      subject text1
      body text1
    end

    assert_equal "Subject: #{text2}\r\n", NKF.nkf("-mw", mail[:subject].encoded)
    assert_equal "\e$B!A!A\e(B", mail.body.encoded
    assert_equal text2, NKF.nkf("-w", mail.body.encoded)
  end

  def test_handles_minus_sign_U_2212_and_fullwidth_hypen_minus_u_ff0d_correctly
    minus_sign = [0x2212].pack("U")
    fullwidth_hyphen_minus = [0xff0d].pack("U")

    text1 = "#{minus_sign}#{fullwidth_hyphen_minus}"
    text2 = "#{minus_sign}#{minus_sign}"

    mail = Mail.new(charset: "ISO-2022-JP") do
      from "taro@example.com"
      to "hanako@example.com"
      subject text1
      body text1
    end

    assert_equal "Subject: =?ISO-2022-JP?B?GyRCIV0hXRsoQg==?=\r\n", mail[:subject].encoded
    assert_equal "Subject: #{text2}\r\n", NKF.nkf("-mw", mail[:subject].encoded)
    assert_equal "\e$B!]!]\e(B", mail.body.encoded
    assert_equal text2, NKF.nkf("-w", mail.body.encoded)
  end

  def test_handles_em_dash_U_2014_and_horizontal_bar_U_2015_correctly
    em_dash = [0x2014].pack("U")
    horizontal_bar = [0x2015].pack("U")

    text1 = "#{em_dash}#{horizontal_bar}"
    text2 = "#{em_dash}#{em_dash}"

    mail = Mail.new(charset: "ISO-2022-JP") do
      from "taro@example.com"
      to "hanako@example.com"
      subject text1
      body text1
    end

    assert_equal "Subject: #{text2}\r\n", NKF.nkf("-mw", mail[:subject].encoded)
    assert_equal "\e$B!=!=\e(B", mail.body.encoded
    assert_equal text2, NKF.nkf("-w", mail.body.encoded)
  end

  def test_handles_double_vertical_line_U_2016_and_parallel_to_U_2225_correctly
    double_vertical_line = [0x2016].pack("U")
    parallel_to = [0x2225].pack("U")

    text1 = "#{double_vertical_line}#{parallel_to}"
    text2 = "#{double_vertical_line}#{double_vertical_line}"

    mail = Mail.new(charset: "ISO-2022-JP") do
      from "taro@example.com"
      to "hanako@example.com"
      subject text1
      body text1
    end

    assert_equal "Subject: #{text2}\r\n", NKF.nkf("-mw", mail[:subject].encoded)
    assert_equal "\e$B!B!B\e(B", mail.body.encoded
    assert_equal text2, NKF.nkf("-w", mail.body.encoded)
  end

  # FULLWIDTH REVERSE SOLIDUS (0xff3c) ＼
  # FULLWIDTH CENT SIGN       (0xffe0) ￠
  # FULLWIDTH POUND SIGN      (0xffe1) ￡
  # FULLWIDTH NOT SIGN        (0xffe2) ￢
  def test_handles_some_special_characters_correctly
    special_characters = [0xff3c, 0xffe0, 0xffe1, 0xffe2].pack("U")

    mail = Mail.new(charset: "ISO-2022-JP") do
      from "taro@example.com"
      to "hanako@example.com"
      subject special_characters
      body special_characters
    end

    assert_equal "Subject: #{special_characters}\r\n", NKF.nkf("-mw", mail[:subject].encoded)
    assert_equal special_characters, NKF.nkf("-w", mail.body.encoded)
  end

  def test_handles_numbers_in_circle_correctly
    text = "①②③④⑤⑥⑦⑧⑨"

    mail = Mail.new(charset: "ISO-2022-JP") do
      from "taro@example.com"
      to "hanako@example.com"
      subject text
      body text
    end

    assert_equal "Subject: #{text}\r\n", NKF.nkf("-mw", mail[:subject].encoded)
    assert_equal text, NKF.nkf("-w", mail.body.encoded)
  end

  def test_handles_hashigodaka_and_tatsusaki_correctly
    text = "髙﨑"

    mail = Mail.new(charset: "ISO-2022-JP") do
      from "taro@example.com"
      to "hanako@example.com"
      subject text
      body text
    end

    assert_equal "Subject: #{text}\r\n", NKF.nkf("-mw", mail[:subject].encoded)
    assert_equal "Subject: =?ISO-2022-JP?B?GyRCfGJ5dRsoQg==?=\r\n", mail[:subject].encoded
    assert_equal text, NKF.nkf("-w", mail.body.encoded)

    assert_equal NKF.nkf("--oc=CP50220 -j", text).force_encoding("ascii-8bit"),
      mail.body.encoded.force_encoding("ascii-8bit")
  end

  def test_handles_hankaku_kana_correctly
    text = "ｱｲｳｴｵ"

    mail = Mail.new(charset: "ISO-2022-JP") do
      from "taro@example.com"
      to "hanako@example.com"
      subject text
      body text
    end

    assert_equal "Subject: #{text}\r\n", NKF.nkf("-mxw", mail[:subject].encoded)
    assert_equal text, NKF.nkf("-xw", mail.body.encoded)
  end

  def test_handles_frozen_texts_correctly
    mail = Mail.new(charset: "ISO-2022-JP") do
      from "taro@example.com"
      to "hanako@example.com"
      subject "text".freeze
      body "text".freeze
    end

    assert_equal "Subject: text\r\n", NKF.nkf("-mxw", mail[:subject].encoded)
    assert_equal "text", NKF.nkf("-xw", mail.body.encoded)
  end

  def test_converts_ibm_special_characters_correctly
    text = "髙﨑"
    j = NKF.nkf("--oc=CP50220 -j", text)

    assert_equal "GyRCfGJ5dRsoQg==", Base64.encode64(j).delete("\n")
  end

  def test_converts_wave_dash_to_zenkaku
    fullwidth_tilde = "～"

    assert_equal [0xef, 0xbd, 0x9e], fullwidth_tilde.unpack("C*")
    wave_dash = "〜"

    assert_equal [0xe3, 0x80, 0x9c], wave_dash.unpack("C*")

    j = NKF.nkf("--oc=CP50220 -j", fullwidth_tilde)

    assert_equal wave_dash, NKF.nkf("-w", j)
  end

  def test_keeps_hankaku_kana_as_is
    text = "ｱｲｳｴｵ"
    j = NKF.nkf("--oc=CP50220 -x -j", text)
    e = Base64.encode64(j).delete("\n")

    assert_equal "GyhJMTIzNDUbKEI=", e
    assert_equal "ｱｲｳｴｵ", NKF.nkf("-xw", j)
  end

  def test_replaces_unconvertable_characters_with_question_marks
    text = "(\xe2\x88\xb0\xe2\x88\xb1\xe2\x88\xb2)"

    mail = Mail.new(charset: "ISO-2022-JP") do
      from "taro@example.com"
      to "hanako@example.com"
      subject text
      body text
    end

    assert_equal "Subject: (???)\r\n", NKF.nkf("-mJwx", mail[:subject].encoded)
    assert_equal "(???)", NKF.nkf("-Jwx", mail.body.encoded)
  end

  def test_encodes_the_text_part_of_multipart_mail
    text = "こんにちは、世界！"

    mail = Mail.new(charset: "ISO-2022-JP") do
      from "taro@example.com"
      to "hanako@example.com"
      subject "Greetings"
    end

    mail.html_part = Mail::Part.new do
      content_type "text/html; charset=UTF-8"
      body "<p>#{text}</p>"
    end

    mail.text_part = Mail::Part.new do
      body text
    end

    assert_equal NKF::JIS, NKF.guess(mail.text_part.body.encoded)
  end

  def test_does_not_encode_the_text_part_of_multipart_mail_if_the_charset_is_set
    text = "こんにちは、世界！"

    mail = Mail.new(charset: "ISO-2022-JP") do
      from "taro@example.com"
      to "hanako@example.com"
      subject "Greetings"
    end

    mail.html_part = Mail::Part.new do
      content_type "text/html; charset=UTF-8"
      body "<p>#{text}</p>"
    end

    mail.text_part = Mail::Part.new(charset: "UTF-8") do
      body text
    end

    assert_equal NKF::UTF8, NKF.guess(mail.text_part.body.encoded)
  end

  def test_handles_lowercase_charset_in_unstructured_fields
    mail = Mail.new(charset: "iso-2022-jp")
    mail["User-Agent"] = "test mailer"

    assert_equal "User-Agent: test mailer\r\n", mail["User-Agent"].encoded
  end
end
