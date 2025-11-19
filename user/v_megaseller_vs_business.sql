 SELECT m.contact_number,
    m.cleaned_number,
    b.accounttype,
    b.address_city,
    b.address_shopname,
    b.fullname,
    b.phonenumber,
    b.sellerid,
    b.storename,
    b.trimmed_phonenumber
   FROM (stg.cleaned_megaseller m
     JOIN stg.trim_business b ON ((b.trimmed_phonenumber = m.cleaned_number)));