module Prawn
  module Text
    module Formatted
      module Flowing

        # Draws formatted text to the page. Formatted text is comprised of an
        # array of hashes, where each hash defines text and format
        # information. See Text::Formatted#formatted_text_box for more
        # information on the structure of this array
        #
        # == Example
        #
        #   text([{ :text => "hello" },
        #         { :text => "world",
        #           :size => 24,
        #           :style => [:bold, :italic] }])
        #
        # == Options
        #
        # Accepts the same options as Prawn::Text::Flowing#text
        #
        # == Exceptions
        #
        # Same as for Prawn::Text::Flowing#text
        #
        def formatted_text(array, options={})
          # we modify the options. don't change the user's hash
          options = options.dup

          inspect_options_for_text(options)

          if @indent_paragraphs
            Text::Formatted::Parser.array_paragraphs(array).each do |paragraph|
              options[:skip_encoding] = false
              remaining_text = draw_indented_formatted_line(paragraph, options)
              options[:skip_encoding] = true
              if remaining_text == paragraph
                # we were too close to the bottom of the page to print even one line
                @bounding_box.move_past_bottom
                remaining_text = draw_indented_formatted_line(paragraph, options)
              end
              remaining_text = fill_formatted_text_box(remaining_text, options)
              draw_remaining_formatted_text_on_new_pages(remaining_text, options)
            end
          else
            remaining_text = fill_formatted_text_box(array, options)
            options[:skip_encoding] = true
            draw_remaining_formatted_text_on_new_pages(remaining_text, options)
          end
        end

        # Gets height of formatted text in PDF points.
        # See documentation for Prawn::Text::Flowing#height_of.
        #
        # ==Example
        #
        #   height_of_formatted([{ :text => "hello" },
        #                        { :text => "world",
        #                          :size => 24,
        #                          :style => [:bold, :italic] }])
        #
        def height_of_formatted(array, options={})
          if options[:indent_paragraphs]
            raise NotImplementedError, ":indent_paragraphs option not " +
              "available with height_of"
          end
          process_final_gap_option(options)
          box = Text::Formatted::Box.new(array,
                                         options.merge(:height   => 100000000,
                                                       :document => self))
          printed = box.render(:dry_run => true)

          height = box.height - (box.line_height - box.ascender)
          height += box.line_height + box.leading - box.ascender if @final_gap
          height
        end

        private


        def draw_remaining_formatted_text_on_new_pages(remaining_text, options)
          while remaining_text.length > 0
            @bounding_box.move_past_bottom
            previous_remaining_text = remaining_text
            remaining_text = fill_formatted_text_box(remaining_text, options)
            break if remaining_text == previous_remaining_text
          end
        end

        def draw_indented_formatted_line(string, options)
          indent(@indent_paragraphs) do
            fill_formatted_text_box(string,
                                    options.dup.merge(:single_line => true))
          end
        end

        def fill_formatted_text_box(text, options)
          merge_text_box_positioning_options(options)
          box = Text::Formatted::Box.new(text, options)
          remaining_text = box.render

          self.y -= box.height - (box.line_height - box.ascender)
          if @final_gap
            self.y -= box.line_height + box.leading - box.ascender
          end
          remaining_text
        end

      end
    end
  end
end
