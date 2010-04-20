module Prawn
  module Text
    module Simple

      # Draws text on the page, beginning at the point specified by the :at
      # option the string is assumed to be pre-formatted to properly fit the
      # page.
      # 
      #   pdf.draw_text "Hello World", :at => [100,100]
      #   pdf.draw_text "Goodbye World", :at => [50,50], :size => 16
      #
      # If your font contains kerning pair data that Prawn can parse, the text
      # will be kerned by default. You can disable kerning by including a false
      # <tt>:kerning</tt> option. If you want to disable kerning on an entire
      # document, set default_kerning = false for that document
      #
      # === Text Positioning Details:
      #
      # Prawn will position your text by the left-most edge of its baseline, and
      # flow along a single line.  (This means that :align will not work)
      #
      # == Rotation
      #
      # Text can be rotated before it is placed on the canvas by specifying the
      # <tt>:rotate</tt> option with a given angle. Rotation occurs
      # counter-clockwise.
      #
      # == Encoding
      #
      # Note that strings passed to this function should be encoded as UTF-8.
      # If you get unexpected characters appearing in your rendered document,
      # check this.
      #
      # If the current font is a built-in one, although the string must be
      # encoded as UTF-8, only characters that are available in WinAnsi are
      # allowed.
      #
      # If an empty box is rendered to your PDF instead of the character you
      # wanted it usually means the current font doesn't include that character.
      #
      # == Options (default values marked in [])
      #
      # <tt>:at</tt>:: <tt>[x, y]</tt>(required). The position at which to
      #                start the text
      # <tt>:kerning</tt>:: <tt>boolean</tt>. Whether or not to use kerning (if
      #                     it is available with the current font)
      #                     [value of default_kerning?]
      # <tt>:size</tt>:: <tt>number</tt>. The font size to use. [current font
      #                  size]
      # <tt>:style</tt>:: The style to use. The requested style must be part of
      #                   the current font familly. [current style]
      #
      # <tt>:rotate</tt>:: <tt>number</tt>. The angle to which to rotate text
      #
      # == Exceptions
      #
      # Raises <tt>ArgumentError</tt> if <tt>:at</tt> option omitted
      #
      # Raises <tt>ArgumentError</tt> if <tt>:align</tt> option included
      #
      def draw_text(text, options)
        # we modify the options. don't change the user's hash
        options = options.dup
        inspect_options_for_draw_text(options)
        # dup because normalize_encoding changes the string
        text = text.to_s.dup
        save_font do
          process_text_options(options)
          font.normalize_encoding!(text) unless @skip_encoding
          font_size(options[:size]) { draw_text!(text, options) }
        end
      end

      private

      def inspect_options_for_draw_text(options)
        if options[:at].nil?
          raise ArgumentError, "The :at option is required for draw_text"
        elsif options[:align]
          raise ArgumentError, "The :align option does not work with draw_text"
        end
        if options[:kerning].nil? then
          options[:kerning] = default_kerning?
        end
        valid_options = Prawn::Core::Text::VALID_OPTIONS + [:at, :rotate]
        Prawn.verify_options(valid_options, options)
      end

    end
  end
end
