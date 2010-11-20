module VCLog

  # The HistoryFile class will parse a history into an array
  # of release tags. Of course to do this, it assumes a specific
  # file format.
  #
  class HistoryFile

    FILE = 'HISTORY.*'

    LINE = /^[=#]/
    VERS = /(\d+\.)+\d+/
    DATE = /(\d+\-)+\d+/

    # Release tags.
    attr :tags

    #
    def initialize(source=nil)
      if File.file?(source)
        @file = source
        @root = File.dirname(source)
      elsif File.directory?(source)
        @file = Dir.glob(File.join(source,FILE)).first
        @root = source
      else
        @file = Dir.glob(FILE).first
        @root = Dir.pwd
      end
      raise "no history file" unless @file

      @tags = extract_tags
    end

    # Parse history file.
    def extract_tags
      tags = []
      desc = ''
      text = File.read(@file)
      text.lines.each do |line|
        if LINE =~ line
          vers = (VERS.match(line) || [])[0]
          date = (DATE.match(line) || [])[0]
          next unless vers
          tags << [vers, date, desc = '']
        else
          desc << line
        end
      end

      tags.map do |vers, date, desc|
        index = desc.index(/^Changes:/) || desc.index(/^\*/) || desc.size
        desc = desc[0...index].strip.fold
        #[vers, date, desc]
        Tag.new(vers, nil, date, nil, desc)
      end
    end

  end

end