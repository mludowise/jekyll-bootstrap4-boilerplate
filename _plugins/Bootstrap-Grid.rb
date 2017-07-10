# Renders the contents in multiple columns

module Jekyll
    class BlockWithAttributes < Liquid::Block
        def initialize(name, params, tokens)
            super
            @attributes = {}
            params.scan(::Liquid::TagAttributes).each do |key, value|
                @attributes[key] = value
            end
        end

    end

    class Row < BlockWithAttributes
        def initialize(name, params, tokens)
            super
        end

        def render(context)
            classes = "row"
            if @attributes.has_key?("class")
                classes += " " + @attributes["class"]
            end
            text = super
            "<div class=\"#{classes}\">" + text + "</div>"
        end
    end

    class Column < BlockWithAttributes
        BREAKPOINTS_A = ["xs", "sm", "md", "lg", "xl"]
        OFFSET_P =      /Offset$/i
        PUSH_P =        /Push$/i
        PULL_P =        /Pull$/i


        def initialize(name, params, tokens)
            super
            processAttributes
        end

        def processAttributes
            classAtt = nil
            widths =   {}
            offsets =  {}
            pushes =   {}
            pulls =    {}
            hidden =   {}

            # Parse attributes
            @attributes.each do |key, value|
                key = key.downcase

                if key.casecmp("class")
                    classAtt = value
                elsif key.casecmp("width")
                    widths["xs"] = value
                elsif BREAKPOINTS_A.include? key
                    widths[key] = value
                elsif OFFSET_P =~ key
                    breakpoint = parseBreakpoint(key, OFFSET_P)
                    columns = getColumns(value)
                    offsets[breakpoint] = columns
                elsif PUSH_P =~ key
                    breakpoint = parseBreakpoint(key, PUSH_P)
                    columns = getColumns(value)
                    pushes[breakpoint] = columns
                elsif PULL_P =~ key
                    breakpoint = parseBreakpoint(key, PULL_P)
                    columns = getColumns(value)
                    pulls[breakpoint] = columns
                elsif key.casecmp("hiddenUp")
                    breakpoint = getBreakpoint(value)
                    hidden["up"] = breakpoint
                elsif key.casecmp("hiddenDown")
                    breakpoint = getBreakpoint(value)
                    hidden["down"] = breakpoint
                end
            end

            @classes = []

            # If no column widths were specified, add "col" class
            if widths.empty?
                @classes << "col"
            end

            # Add col, offset, push, & pull classes
            BREAKPOINTS_A.each do |breakpoint|
                offset = offsets[breakpoint]
                push =   pushes[breakpoint]
                pull =   pulls[breakpoint]

                if widths.has_key?(breakpoint)
                    width = widths[breakpoint]
                    colClass = buildColClass(breakpoint, width)
                    unless colClass.nil?
                        @classes << colClass
                    end
                end

                unless offset.nil?
                    @classes << buildClass("offset", breakpoint, offset)
                end

                unless push.nil?
                    @classes << buildClass("push", breakpoint, push)
                end

                unless pull.nil?
                    @classes << buildClass("pull", breakpoint, pull)
                end
            end

            # Add hidden classes
            hidden.each do |direction, breakpoint|
                @classes << "hidden-#{breakpoint}-#{direction}"
            end

            # Add additional classes
            unless classAtt.nil?
                @classes << classAtt
            end
        end

        # If value is a valid column width (1-12), returns number otherwise nil
        def getColumns(value)
            num = value.to_i
            if num > 0 && num <= 12
                return num
            end
        end

        # Returns lowercase breakpoint if valid (xs, sm, md, lg, xl), otherwise returns nil
        def getBreakpoint(value)
            if value == ""
                return "xs"
            end

            value = value.downcase
            if BREAKPOINTS_A.include? value
                return value
            end
        end

        # Parses a breakpoint from the given string
        def parseBreakpoint(value, pattern)
            value = value.gsub(pattern, "")
            return getBreakpoint(value)
        end

        # e.g. col, col-2, col-sm-2, col-sm, col-md-auto, col-auto
        def buildColClass(breakpoint, width)
            columns = getColumns(width)

            if width != nil
                width = width.downcase
            end

            # Only valid widths are nil, auto, or 1-12
            if width != nil && width != "auto" && columns == nil
                return nil
            end

            return buildClass("col", breakpoint, width)
        end

        # e.g. offset-sm-2, offset-2
        # e.g. push-md-3, push-3
        # e.g. pull-md-3, pull-3
        def buildClass(type, breakpoint, width)
            segments = [type]

            # xs isn't explicit in Bootstrap 4
            if breakpoint != "xs"
                segments << breakpoint
            end

            if width != nil
                segments << width
            end

            return segments.join("-")
        end

        def render(context)
            text = super

            site = context.registers[:site]
            converter = site.find_converter_instance(Jekyll::Converters::Markdown)
            "\t<div class=\"" + @classes.join(" ") + "\">\n\t\t" + converter.convert(text).strip + "\n\t</div>" + @attributes.to_s
            # '<div class="col-md-6">' + text + '</div>'
        end
    end

    Liquid::Template.register_tag('row', Row)
    Liquid::Template.register_tag('col', Column)

end
