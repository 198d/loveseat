class Song < Loveseat::Model
  setup do
    string :name

    embeded :time_signature do
      integer :numerator
      integer :denominator
    end

    embeded :notes, 'Note' do
      integer :numerator
      integer :denominator
      integer :value # 1-48? Middle C = 24?
    end
  end
end

