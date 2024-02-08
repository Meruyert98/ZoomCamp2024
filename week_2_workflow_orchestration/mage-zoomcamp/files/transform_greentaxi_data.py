if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@transformer
def transform(data, *args, **kwargs):
    # Remove rows where the passenger count is equal to 0 and the trip distance is equal to zero.
    data = data[(data['passenger_count'] > 0) & (data['trip_distance'] > 0)]
    
    # Create a new column lpep_pickup_date by converting lpep_pickup_datetime to a date.
    data["lpep_pickup_date"] = data["lpep_pickup_datetime"].dt.date

    # Rename columns in Camel Case to Snake Case, e.g. VendorID to vendor_id.
    data.columns = (data.columns
                .str.replace('(?<=[a-z])(?=[A-Z])', '_', regex=True)
                .str.lower()
             )
    return data


@test
def test_output(output, *args) -> None:
    # vendor_id is one of the existing values in the column (currently)
    assert "vendor_id" in output
    # passenger_count is greater than 0
    assert (output['passenger_count'] > 0).all()
    # trip_distance is greater than 0
    assert (output['trip_distance'] > 0).all()
