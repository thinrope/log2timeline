# array of double precision float
package Parse::Evtx2::VariantType::Type0x8c;
use base qw( Parse::Evtx2::VariantType );

use Carp::Assert;

sub parse_self {
	my $self = shift;
	
	my $start = $self->{'Start'};
	
	my $data;
	assert($self->{'Context'} == 1, "not tested in value context. Please submit a sample.") if DEBUG;
	if ($self->{'Context'} == 1) {
		# context is SubstArray
		# length is predetermined, no length will preceed the data
		assert($self->{'Length'} >= 8, "packet too small") if DEBUG;
		assert($self->{'Length'} % 8 == 0, "unexpected length") if DEBUG;		
		$data = $self->{'Chunk'}->get_data($start, $self->{'Length'});
	} else {
		# context is Value
	}
	
	my $i;
	my $elements = $self->{'Length'} / 8;
	my @data;
	for ($i=0; $i<$elements; $i++ ) {
		$data[$i] = sprintf("[%u] %e", 
			$i, 
			unpack("d", substr($data, $i*8, 8))
		);
	}	
	$self->{'String'} = join("\n", @data);

}

1;