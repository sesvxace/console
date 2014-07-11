#--
# SES Console: Setup
# =============================================================================
#   This macro is automatically run whenever the SES Console is opened during
# game testing. Provides general initialization for the console and external
# macros.
#++

# Macros
# =============================================================================
# Top-level namespace for the default SES Console macro package.
module SES::Console::Macros
  # ===========================================================================
  # BEGIN CONFIGURATION
  # ===========================================================================
  
  # Default prompt to use for user input during macro evaluation.
  SES::Console.prompt[:macro] = '?> '
  
  # Used to search for files to automatically load when the console is opened
  # for the first time. Files which set up some form of environment should be
  # placed here.
  AUTOLOAD = SES::Console::MACRO_DIR + '/autoload/**/*.*'
  # ===========================================================================
  # END CONFIGURATION
  # ===========================================================================
  class << self
    # Default prompt for user input during macro execution.
    # @return [String]
    attr_reader :prompt
  end
  
  # Assign the prompt to the appropriate `SES::Console.prompt` value.
  @prompt ||= SES::Console.prompt[:macro]
  
  # Customized writer for the user input prompt. Automatically updates the
  # prompt in both the `SES::Console::Macros` and `SES::Console` modules.
  # 
  # @param value [String] the desired prompt
  # @return [String] the assigned prompt
  def prompt=(value)
    SES::Console.prompt[:macro] = value.to_s
    @prompt = SES::Console.prompt[:macro]
  end
  # Setup
  # ===========================================================================
  # Provides the welcome message and logic determining its display.
  module Setup
    class << self
      # The welcome message to display when this macro is first run.
      # @return [String]
      attr_accessor :message
      
      # Whether or not the setup macro has been run.
      # @return [Boolean]
      attr_accessor :run
      alias_method :run?, :run
    end
    
    # The default message to display when the SES Console is opened for the
    # first time during a given test run.
    @message = "Welcome to the SES Console.\n" <<
               'Type `exit` or `Kernel.exit` to return to the game.'
    
    # Writes the given message (`@message` by default) to standard output.
    # 
    # @param message [String] the message to write
    # @return [nil]
    def self.display_message(message = @message)
      STDOUT.puts(message)
    end
    
    # Display the message and set `@run` to true if the SES Console has not
    # yet been run during this test run.
    unless run?
      Dir[AUTOLOAD].each { |macro| load macro }
      display_message
      @run = true
    end
  end
end