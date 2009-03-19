require 'robocup/parser'
require 'player/status/observable'

module Player

=begin
  Каждому сообщению от сервера соответствует объект Status класса.
  Объекты данного класа предоставляют простой интерфейс для получения информации о состоянии игры.

  Пример,

    simple_server_sexp = '(time (now 696.94))(GYR (n torso) (rt -0.24 3.30 -0.06))'
    Status.data = simple_server_sexp
    p Status.time         # => 696.94
    p Status.gyroscope    # => [-0.24, 3.3, -0.06]
=end
  module Status
    extend self
    extend Observable
    
    attr_reader :data
    @data = {}
    
    def data=(sexp)
      new_data = Robocup::Parser.parse sexp
      data.merge!(new_data) {|*args| notify_observers(*args); args.last }
    end
      
    def time
      data[:time][:now]
    end

    def game_time
      data[:GS][:t]
    end
  
    def game_mode
      data[:GS][:pm]
    end
  
    def gyroscope
      data[:GYR][:torso][:rt]
    end    
  end # Status
end # Player