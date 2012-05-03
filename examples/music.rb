Loveseat::Model.connection = { host: 'localhost', port: 5984, database: 'loveseat' }

class Note
  STRINGS = ['C', 'C#/Db', 'D', 'D#/Eb',
    'E', 'F', 'F#/Gb', 'G', 'G#/Ab', 'A', 'A#/Bb', 'B']

  attr_accessor :numerator, :denominator, :value

  def self.value(note, which = 3)
    index = STRINGS.index(note)
    (index + (which * 12))
  end

  def to_s
    STRINGS[value % 12]
  end
end

class TimeSignature
  attr_accessor :numerator, :denominator
end


class Song
  attr_accessor :name, :time_signature, :notes
end

Loveseat::EmbededDocument.setup(Note) do
  integer :numerator
  integer :denominator
  integer :value
end

Loveseat::EmbededDocument.setup(TimeSignature) do
  integer :numerator
  integer :denominator
end

Loveseat::Document.setup(Song) do
  string :name
  embeded :time_signature, TimeSignature
  embeded :notes, Note
end

Loveseat::DesignDocument.setup(SongViews)

