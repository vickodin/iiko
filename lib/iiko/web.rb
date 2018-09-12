require 'mechanize'

module Iiko
  class Web
    IIKO_USER_AGENT = 'iiko agent'

    attr_reader :agent, :result, :files, :settings, :logged, :headers

    def initialize(settings)
      @settings = settings # :url, :user, :password, :user_agent
      validate_arguments

      @agent = Mechanize.new { |agent| agent.user_agent = settings[:user_agent] || IIKO_USER_AGENT }

      #default_headers = { "Accept-Language" => 'ru-RU,ru;q=0.8,en-US;q=0.6,en;q=0.4' }
      #@headers = settings[:headers] ? settings[:headers].merge(default_headers) : default_headers
    end

    def login
      agent.get(service_url) do |login_page|
        @result = login_page.form_with(name: 'f') do |form|
          form.j_username = settings[:user]
          form.j_password = settings[:password]
        end.submit
        # TODO: Check success login
        @logged = true
      end
    end

    def ttk(file_name = nil)
      login unless logged

      @result = agent.get(service_url(:ttk))
      write_file(file_name, 'ttk', 'csv')
    end

    def goods(file_name = nil)
      login unless logged

      @result = agent.get(service_url(:goods))
      write_file(file_name, 'goods', 'csv')
    end

    private

    def write_file(file_name = nil, name, extension)
      unless file_name
        file = extra_file(name, extension)
        #file.write(result.body)
        file.close
        file_name = file.path
      end
      File.write(file_name, result.body, mode: 'wb')
      file_name
    end

    def extra_file(name, extension)
      Tempfile.new([name, ".#{extension}"], encoding: 'ascii-8bit')
    end

    def validate_arguments
      [:url, :user, :password].each do |arg|
        raise ArgumentError, "#{arg} is required" unless settings[arg]
      end
    end

    def service_url(service = nil)
      routes = {
        ttk: '/service/export/csv/assemblyCharts.csv',
        goods: '/service/export/csv/goods.csv',
      }

      [settings[:url], routes[service]].join
    end
  end

end
