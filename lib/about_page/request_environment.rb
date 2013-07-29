module AboutPage
  class RequestEnvironment < Environment
    attr_accessor :environment

    render_with 'environment'

    def preflight request
      @environment = request.env
    end

    def environment
      @environment
    end

  end
end
