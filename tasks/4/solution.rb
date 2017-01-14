RSpec.describe 'Version' do
  describe '#initialize' do
    it 'waits for an exception from creation of new instance' do
      expect { Version.new('1.1..0') }.to raise_error(
        ArgumentError, 
        "Invalid version string '1.1..0'"
      )
      expect { Version.new('.3') }.to raise_error(
        ArgumentError, 
        "Invalid version string '.3'"
      )   
      expect { Version.new('1.-3') }.to raise_error(
        ArgumentError, 
        "Invalid version string '1.-3'"
      )       
      expect { Version.new('2.2.') }.to raise_error(
        ArgumentError, 
        "Invalid version string '2.2.'"
      )     
      expect { Version.new(Version.new('1.3beta')) }.to raise_error(
        ArgumentError, 
        "Invalid version string '1.3beta'"
      )    
    end

    it 'allows the version to be an empty string and assumes it to be 0' do
      expect(Version.new('')).to eq Version.new('0')
    end

    it 'can be initialized without a string and assumes the version to be 0' do
      expect(Version.new).to eq Version.new('0')
    end

    it 'can be initialized with another version object' do
      expect(Version.new('1.1.3')).to eq Version.new('1.1.3')
    end    
  end

  describe '#components' do
    it 'returns an array properly with same length like the one of version' do
      expect(Version.new('1.3.5').components).to eq [1, 3, 5]
    end
 
    it 'returns an array properly with length smaller than that of version' do
      expect(Version.new('1.3.5').components(2)).to eq [1, 3]
    end
 
    it 'returns an extended array properly' do
      expect(Version.new('0.3.5').components(5)).to eq [0, 3, 5, 0, 0]
    end   

    it 'does not allow modification of state of the instance' do
      test_object = Version.new('1.3.5')
      test_object.components.push(4)
      expect(test_object.components).to eq [1, 3, 5]
      test_object = Version.new('1.3.5')
      test_object.components(2).push(4)
      expect(test_object.components).to eq [1, 3, 5]
      test_object = Version.new('1.3.5')
      test_object.components(5).push(4)
      expect(test_object.components).to eq [1, 3, 5]
    end
  end

  describe '#to_s' do
    it 'returns a string properly' do
      expect(Version.new('1').to_s        ).to eq '1'
      expect(Version.new('1.2').to_s      ).to eq '1.2'
      expect(Version.new('1.2.3').to_s    ).to eq '1.2.3'
      expect(Version.new('1.2.33.48').to_s).to eq '1.2.33.48'
      expect(Version.new('1.02.2').to_s).to eq "1.2.2"
      expect(Version.new('0.0.1.0.00').to_s).to eq "0.0.1"
      expect(Version.new('').to_s).to eq ""      
    end
  end

  describe "#methods for compare" do
    it 'correctly compares equal versions' do
      expect(Version.new('')).to eq Version.new  
      expect(Version.new('3.1.3')).to eq Version.new('3.1.3')  
      expect(Version.new('1.2.3')).to_not eq Version.new('1.2')    
    end

    it 'compares simple inequalities' do
      expect(Version.new('1')    ).to be > Version.new('0')
      expect(Version.new('0.1')  ).to be > Version.new('0')
      expect(Version.new('0.0.1')).to be > Version.new('0')
      expect(Version.new('0')    ).to_not be > Version.new('0.0.1')
      expect(Version.new('1.2.3')).to_not be > Version.new('1.3.1')
      expect(Version.new('1.2.3.0') > Version.new('1.2.3')).to be false    
      expect(Version.new('1.2.3')).to be < Version.new('1.3.1')   
      expect(Version.new('1.2.3.0')).to_not be < Version.new('1.2.3')  
      expect(Version.new('1.23')).to be > Version.new('1.22')
      expect(Version.new('1.23')).to be > Version.new('1.4')
    end
     
    it 'implements <= and >=' do
      expect(Version.new('1.20.3.0')).to be <= Version.new('10.2.3')
      expect(Version.new('1.2.0.0')).to be <= Version.new('1.2')
      expect(Version.new('1.20.3.0')).to be >= Version.new('1.2.3')
      expect(Version.new('1.2.0.0')).to be >= Version.new('1.2')
    end
    
    it 'implements <=>' do
      expect(Version.new('1.2.3.0') <=> Version.new('1.3.2')).to eq -1
      expect(Version.new('1.3.2.0') <=> Version.new('1.2.3')).to eq 1
      expect(Version.new('1.2.3.0') <=> Version.new('1.2.3')).to eq 0
    end    
  end
end
describe Version::Range do
  describe '#include?' do
    let(:range) { Version::Range.new(Version.new('1.1.11'), Version.new('3.1.12')) }
   
    it 'returns whether a version is in the range' do
      expect(range).to include Version.new('1.2.1')
      expect(range).to include Version.new('1.100')
      expect(range).to include Version.new('1.1.15')
      expect(range).to include Version.new('2.5.55')     
      
      expect(range).to_not include Version.new('3.1.16')
      expect(range).to_not include Version.new('3.2.0')
      expect(range).to_not include Version.new('0.1')
      expect(range).to_not include Version.new('1.1.10')
      expect(range).to_not include Version.new('20.1.10')      

      test_object = Version::Range.new(Version.new('1'), Version.new('2'))
      expect(test_object.include?(Version.new('1.5'))).to be true
      expect(test_object.include?(Version.new('1.0'))).to be true
      expect(test_object.include?(Version.new('2.0'))).to be false
    end
   
    it 'can be given a string' do
      expect(range).to include '1.1.12'
      expect(range).to_not include '3.1.15'
    end    
  end

  describe '#to_a' do
    it 'returns array from all versions in current range' do
      expect(Version::Range.new('1.1.0', '1.2.2').to_a).to eq [
        '1.1', '1.1.1', '1.1.2', '1.1.3', '1.1.4', '1.1.5', '1.1.6',
        '1.1.7', '1.1.8', '1.1.9', '1.2', '1.2.1'
      ]
      expect(Version::Range.new('1.1.0.1', '1.2.2').to_a).to eq [
        '1.1.0.1', '1.1.1', '1.1.2', '1.1.3', '1.1.4', '1.1.5', '1.1.6',
        '1.1.7', '1.1.8', '1.1.9', '1.2', '1.2.1'
      ]
      expect(Version::Range.new('1', '1.1.0').to_a).to eq [
        '1', '1.0.1', '1.0.2', '1.0.3', '1.0.4', '1.0.5', '1.0.6',
        '1.0.7', '1.0.8', '1.0.9'
      ]
      expect(Version::Range.new('1.1.0', Version.new('1.1.0')).to_a).to eq []
      expect(Version::Range.new(Version.new('1.1.2'), '1.1.0').to_a).to eq []
    
      range = Version::Range.new('1.1.2', '1.1.5')
      expect(range.to_a.map(&:to_s)).to eq ['1.1.2', '1.1.3', '1.1.4']

      range = Version::Range.new('1.1.2', '1.3')
      expect(range.to_a.map(&:to_s)).to match_array [
          '1.1.2', '1.1.3', '1.1.4', '1.1.5', '1.1.6', '1.1.7', '1.1.8',
          '1.1.9',
          '1.2', '1.2.1', '1.2.2', '1.2.3', '1.2.4', '1.2.5', '1.2.6', '1.2.7',
          '1.2.8', '1.2.9'
      ]
    end
  end    
end