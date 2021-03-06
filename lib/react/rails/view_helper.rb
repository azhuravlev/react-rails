module React
  module Rails
    module ViewHelper

      # Render a UJS-type HTML tag annotated with data attributes, which
      # are used by react_ujs to actually instantiate the React component
      # on the client.
      #
      def react_component(name, args = {}, options = {}, &block)
        options = {:tag => options} if options.is_a?(Symbol)
        context_suffix = options.delete(:context_suffix) || ''
        block = Proc.new{concat React::Renderer.render(name, args, context_suffix)} if options[:prerender] == true

        html_options = options.reverse_merge(:data => {})
        html_options[:data].tap do |data|
          data[:react_class] = name
          data[:react_props] = React::Renderer.react_props(args) unless args.empty?
        end
        html_tag = html_options[:tag] || :div
        
        # remove internally used properties so they aren't rendered to DOM
        [:tag, :prerender].each{|prop| html_options.delete(prop)}
        
        content_tag(html_tag, '', html_options, &block)
      end

    end
  end
end
