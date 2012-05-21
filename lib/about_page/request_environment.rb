module AboutPage
  class RequestEnvironment < Environment
    attr_accessor :environment

    def preflight request
      @environment = request.env
    end

    def environment
      @environment
    end

  end
end
