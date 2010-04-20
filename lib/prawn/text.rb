# encoding: utf-8

# text.rb : Implements PDF text primitives
#
# Copyright May 2008, Gregory Brown. All Rights Reserved.
#
# This is free software. Please see the LICENSE and COPYING files for details.
require "prawn/core/text"
require "prawn/core/text/wrap"
require "prawn/text/box"
require "prawn/text/flowing"
require "prawn/text/simple"
require "prawn/text/formatted"
require "zlib"

module Prawn
  module Text

    include Prawn::Core::Text
    include Prawn::Text::Flowing
    include Prawn::Text::Simple
    include Prawn::Text::Formatted

  end
end
