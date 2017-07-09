# Renders the contents in multiple columns

module Jekyll
    class Row < Liquid::Block
        # include LiquidExtensions::Helpers
        include Jekyll::Filters

        def initialize(name, params, tokens)
            super
            # @columns = []
        end

        # def unknown_tag(name, params, tokens)
        #     if name == "column"
        #         handle_column(params, tokens)
        #     else
        #         super
        #     end
        # end
        #
        # def handle_column(params, tokens)
        #     @columns << 'tokens'
        # end

        def render(context)
            # @body = super
            # '<div class="row">#{@body}</div>'

            text = super
            #
            # site = context.registers[:site]
            # converter = site.find_converter_instance(Jekyll::Converters::Markdown)
            # '<div class="row">' + converter.convert(text) + '</div>'
            "<div class=\"row\">" + text + "</div>"
        end
    end

    class Column < Liquid::Block
        def initialize(name, params, tokens)
            super
            @attributes = {}
            # @classes = []
            @classes = processAttributes(params.scan(::Liquid::TagAttributes))
            params.scan(::Liquid::TagAttributes) do |key, value|
                @attributes[key] = value
            end
        end

        def processAttributes(attributes)
            classes = []

            additional_classes = attributes.delete("classes")
            if !additional_classes.nil?
                classes << additional_classes
            end

            # No columns specified
            if attributes.empty?
                classes << "col"
            end

            attributes.each do |key, value|

                case value

                when "equal"
                    # Columns use equal width
                    # ex: md:default => col-md

                when "auto"
                    # Columns size based on natural widths of content
                    # ex: md:auto => col-md-auto

                when "hidden"
                    # Hides for breakpoints
                    # ex: md:hidden => hidden-md
                end

                begin
                    # Check if value is integer between 1 & 12
                    num = Integer(value)

                    if num < 1 || num > 12
                        next
                    end
                rescue
                    next
                end

                case key
                when "xs"
                    classes << "col-#{value}"
                when "sm", "md", "lg", "xl" then
                    classes << "col-#{key}-#{value}"
                end
            end

            return classes
        end

        def render(context)
            text = super

            site = context.registers[:site]
            converter = site.find_converter_instance(Jekyll::Converters::Markdown)
            "\t<div class=\"" + @classes.join(" ") + "\">\n\t\t" + converter.convert(text).strip + "\n\t</div>"
            # '<div class="col-md-6">' + text + '</div>'
        end
    end

    Liquid::Template.register_tag('row', Row)
    Liquid::Template.register_tag('col', Column)

end
