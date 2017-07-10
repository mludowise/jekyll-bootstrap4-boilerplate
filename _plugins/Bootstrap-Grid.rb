# Renders the contents in Bootstrap rows and columns for Bootstrap 4.
#
# `{col}` tags are expected to always be contained inside of a `{row}` block. It's assumed that the page contains a `content` div.
#
# Parameters for Rows
# ===================
#
# `class` - Used to add additional classes to the row `div`. Multiple classes can be separated by spaces but the argument value must be wrapped in quotations if it contains spaces.
#
# Parameters for Columns
# ======================
#
# `width`, `xs`, `sm`, `md`, `lg`, `xl` - Equivalent to the `col-*` or `col-{breakpoint}-*` classes. Sets the column width for the specified device viewport and larger.
# The `width` and `xs` parameters do the same thing and set the size for all device viewports from `xs` to `xl` – they are equivalent to the `col-*` classes.
# If none of these column size parameters are specified, the `col` class will automatically be added to the column div.
#   Allowable values:
#   - `auto`: Equivalent to `col-auto` and `col-{breakpoint}-auto` classes. Column sizes itself based on the natural width of its content.
#   - `*` or empty value: Equivalent to `col` or `col-{breakpoint}` classes. Column resizes to fit the available width.
#   - 1-12: Equivalent to `col-1` or `col-{breakpoint}-1` through `col-12` or `col-{breakpoint}-12` classes. Sets the width of the column based on a gridsize of 12 columns.
#
# `offset`, `xsOffset`, `smOffset`, `mdOffset`, `lgOffset`, `xlOffset` - Equicalent to the `offset-*` or `offset-{breakpoint}-*` classes. Moves columns to the right by the specified number of columns for the appropriate breakpoint. The `offset` and `xsOffset` parameters do the same thing and are equivalent to the `offset-*` classes.
#   Allowable values: 1-12
#
# `push`, `xsPush`, `smPush`, `mdPush`, `lgPush`, `xlPush` - Equivalent to the `push-*` or `push-{breakpoint}-*` classes. The `push` and `xsPush` parameters do the same thing and are both equivalent to the `push-*` classes.
#    Allowable values: 1-12
#
# `pull`, `xsPull`, `smPull`, `mdPull`, `lgPull`, `xlPull` - Equivalent to the `pull-*` or `pull-{breakpoint}-*` classes. The `pull` and `xsPull` parameters do the same thing and are both equivalent to the `pull-*` classes.
#    Allowable values: 1-12
#
# `hiddenUp` - Equivalent to the `hidden-{breakpoint}-up` class. Column will be hidden for the specified breakpoint as well as any larger breakpoints.
#    Allowable values: `xs`, `sm`, `md`, `lg`, `xl`
#
# `hiddenDown` - Equivalent to the `hidden-{breakpoint}-down` class. Column will be hidden for the specified breakpoint as well as any smaller breakpoints.
#    Allowable values: `xs`, `sm`, `md`, `lg`, `xl`
#
# `class` - Used to add additional classes to the column `div`. Multiple classes can be separated by spaces but the argument value must be wrapped in quotations if it contains spaces.
#


module Jekyll
    class BlockWithAttributes < Liquid::Block
        # Custom TagAttributes which allow for nil values
        TAG_ATTRIBUTES = /(\w+)\s*\:?\s*(#{::Liquid::QuotedFragment})?/o

        def initialize(name, params, tokens)
            super

            @attributes = {}
            params.scan(TAG_ATTRIBUTES).each do |key, value|
                # Remove quotations from strings
                unless value.nil?
                    value = value.strip.gsub(/^['"]/, "").gsub(/['"]$/, "")
                end
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
            @debug = []
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

                if key == "class"
                    classAtt = value
                elsif key == "width"
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
                elsif key == "hiddenup"
                    breakpoint = getBreakpoint(value)
                    hidden["up"] = breakpoint
                elsif key == "hiddendown"
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
                    width =  widths[breakpoint]
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
            # convert to lowercase
            unless width.nil?
                width = width.downcase
            end

            if width == nil
                # valid
            elsif width == "*"
                width = nil
            elsif width == "auto"
                # valid
            elsif getColumns(width) != nil
                # valid
            else
                # Invalid width
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
            "\t<div class=\"" + @classes.join(" ") + "\">\n\t\t" + converter.convert(text).strip + "\n\t</div>"
        end
    end

    Liquid::Template.register_tag('row', Row)
    Liquid::Template.register_tag('col', Column)

end
