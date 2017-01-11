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
      expect { Version.new('2.2.') }.to raise_error(
        ArgumentError, 
        "Invalid version string '2.2.'"
      )     
      expect { Version.new(Version.new('1.3.')) }.to raise_error(
        ArgumentError, 
        "Invalid version string '1.3.'"
      )    
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
      expect(Version.new('1.3.5').components(5)).to eq [1, 3, 5, 0, 0]
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
      expect(Version.new('1.02.2').to_s).to eq "1.2.2"
      expect(Version.new('0.0.1.0.00').to_s).to eq "0.0.1"
      expect(Version.new('').to_s).to eq ""      
    end
  end
  describe "#methods for compare" do
    it "compares versions" do
      expect(Version.new('1.2.3')).to_not be > Version.new('1.3.1')
      expect(Version.new('1.2.3.0') > Version.new('1.2.3')).to be false    
      expect(Version.new('1.20.3.0')).to be >= Version.new('1.2.3')
      expect(Version.new('1.2.0.0')).to be >= Version.new('1.2')
      expect(Version.new('')).to eq Version.new  
      expect(Version.new('1.2.3')).to_not eq Version.new('1.2')    
      expect(Version.new('1.2.3')).to be < Version.new('1.3.1')   
      expect(Version.new('1.2.3.0')).to_not be < Version.new('1.2.3')  
      expect(Version.new('1.20.3.0')).to be <= Version.new('10.2.3')
      expect(Version.new('1.2.0.0')).to be <= Version.new('1.2')
    end
  end
end
describe Version::Range do
  describe '#include?' do
    it 'returns whether a version is in the range' do
      test_object = Version::Range.new(Version.new('1'), Version.new('2'))
      expect(test_object.include?(Version.new('1.5'))).to be true
      expect(test_object.include?(Version.new('1.0'))).to be true
      expect(test_object.include?(Version.new('2.0'))).to be false
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
    end
  end    
end