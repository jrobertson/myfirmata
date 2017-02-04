#!/usr/bin/env ruby

# file: myfirmata.rb

require 'sps-sub'
require 'arduino_firmata'




Thread.abort_on_exception=true

class DummyNotifier
  
  def notice(message)
    puts Time.now.to_s + ' - ' + message
  end
  
end

class MyFirmata

  def initialize(device_name: Socket.gethostname, sps_address: nil, 
                          sps_port: 59000, plugins: {}, basetopic: 'MyFirmata')

    @arduino = ArduinoFirmata.connect  # use default arduino    

    @basetopic = basetopic
    @device_name, @sps_address, @sps_port = device_name, sps_address, sps_port

    if sps_address then
      @publisher = @subscriber = SPSSub.new address: @sps_address, 
                                            port: @sps_port, callback: self
    else
      @publisher = DummyNotifier.new
    end

    @plugins = initialize_plugins(plugins || [])    
    
    at_exit do
      
      @plugins.each do |x|
        if x.respond_to? :on_exit then
          puts 'stopping ' + x.inspect
          Thread.new { x.on_exit() }
        end
      end
      
    end

  end

  # triggered from a sps-sub callback
  #
  def ontopic(topic, msg)

    component = topic[/\w+$/]

    method_name = "on_#{component}_message".to_sym

    @plugins.each do |x|      

      if x.respond_to? method_name then
        x.method(method_name).call(msg)
      end

    end
  end

  def start()
    
    @plugins.each do |x|
      
      if x.respond_to? :on_start then
                
        Thread.new do  
          
            x.on_start()           
          
        end.join
        
      end
    end
        
    if @subscriber then
            
      subtopics = %w(output do)
      topics = subtopics\
          .map {|x| "%s/%s/%s/#" % [@basetopic, @device_name, x]}.join(' | ')
      @subscriber.subscribe topic: topics
      
    else
      loop while true
    end
    
  end


  private

  
  def initialize_plugins(plugins)

    @plugins = plugins.inject([]) do |r, plugin|
      
      name, settings = plugin
      return r if settings[:active] == false and !settings[:active]
      
      klass_name = @basetopic + 'Plugin' + name.to_s

      device_id = "%s/%s" % [@basetopic, @device_name]
      vars = {device_id: device_id, notifier: @publisher}

      r << Kernel.const_get(klass_name)\
                            .new(@arduino, settings: settings, variables: vars)
      def r.to_s()
        klass_name
      end
      
      r
    end
  end  

end
