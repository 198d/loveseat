class Note < Loveseat::EmbededModel
  STRINGS = ['C', 'C#/Db', 'D', 'D#/Eb',
    'E', 'F', 'F#/Gb', 'G', 'G#/Ab', 'A', 'A#/Bb', 'B']

  setup do
    integer :numerator
    integer :denominator
    integer :value
  end

  def self.value(note, which = 3)
    index = STRINGS.index(note)
    (index + (which * 12))
  end

  def to_s
    STRINGS[value % 12]
  end
end

class Song < Loveseat::Model
  setup do
    string :name

    embeded :time_signature do
      integer :numerator
      integer :denominator
    end

    embeded :notes, Note
  end
end

