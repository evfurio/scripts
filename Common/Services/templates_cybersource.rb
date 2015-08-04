module CybersourceRequestTemplates

GET_SIGNATURE_FROM_CYBERSOURCE = <<eos
{"paramsArray": [{"Key": "access_key","Value": "?"},
        {"Key": "profile_id","Value": "?"},
        {"Key": "transaction_uuid","Value": "?"},
        {"Key": "signed_field_names","Value": "access_key,profile_id,transaction_uuid,signed_field_names,unsigned_field_names,signed_date_time,locale,transaction_type,reference_number,amount,currency,payment_method,bill_to_forename,bill_to_surname,bill_to_email,bill_to_address_line1,bill_to_address_city,bill_to_address_state,bill_to_address_country,bill_to_address_postal_code"},
        {"Key": "unsigned_field_names","Value": "card_type,card_number,card_expiry_date,card_cvn"},
        {"Key": "signed_date_time","Value": "?"},
        {"Key": "locale","Value": "en"},
        {"Key": "transaction_type","Value": "create_payment_token"},
        {"Key": "reference_number","Value": "?"},
        {"Key": "amount","Value": 0.00},
        {"Key": "currency","Value": "usd"},
        {"Key": "payment_method","Value": "card"},
        {"Key": "bill_to_forename","Value": "?"},
        {"Key": "bill_to_surname","Value": "?"},
        {"Key": "bill_to_email","Value": "?"},
        {"Key": "bill_to_address_line1","Value": "?"},
        {"Key": "bill_to_address_city","Value": "?"},
        {"Key": "bill_to_address_state","Value": "?"},
        {"Key": "bill_to_address_country","Value": "?"},
        {"Key": "bill_to_address_postal_code","Value": "?"}]}
eos

end