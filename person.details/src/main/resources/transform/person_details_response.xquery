declare namespace adel="http://adelaide.edu.au/integration/app/PersonDataResponse";
declare namespace orgres="http://adelaide.edu.au/enterprise/peoplesoft/sahr/schema/ORGPERSON_RS_UOA";

declare variable $orgPerson := (for $item in /orgres:orgPersonResponse/orgres:orgPerson
return $item
);

declare variable $addressHome := (for $item in /orgres:orgPersonResponse/orgres:orgPerson/orgres:address
 where $item/orgres:ADDRESS_TYPE='HOME'
 order by $item/orgres:EFFDT descending
 return $item
);
declare variable $addressMail := (for $item in /orgres:orgPersonResponse/orgres:orgPerson/orgres:address
 where $item/orgres:ADDRESS_TYPE='MAIL'
 order by $item/orgres:EFFDT descending
 return $item
);
declare variable $orgRelation := (for $item in /orgres:orgPersonResponse/orgres:orgPerson/orgres:orgRelation
where $item/orgres:HR_STATUS='A'
return $item
);
declare variable $homePhone := (for $item in /orgres:orgPersonResponse/orgres:orgPerson/orgres:phone
where $item/orgres:PHONE_TYPE='HOME'
return $item
);
declare variable $workPhone := (for $item in /orgres:orgPersonResponse/orgres:orgPerson/orgres:phone
where $item/orgres:PHONE_TYPE='WORK'
return $item
);
declare variable $cellPhone := (for $item in /orgres:orgPersonResponse/orgres:orgPerson/orgres:phone
where $item/orgres:PHONE_TYPE='CELL'
return $item
);
declare variable $workEmail := (for $item in /orgres:orgPersonResponse/orgres:orgPerson/orgres:email
where $item/orgres:E_ADDR_TYPE='CAMP'
return $item
);
declare variable $homeEmail := (for $item in /orgres:orgPersonResponse/orgres:orgPerson/orgres:email
where $item/orgres:E_ADDR_TYPE='HOME'
return $item
);

<PersonResponse>
{
for $person in $orgPerson
return 
    <Person>
        <PersonID>{data($person/orgres:PERSON_ID)}</PersonID>
        <FullName>{data($person/orgres:FULL_NAME)}</FullName>
        <FirstName>{data($person/orgres:FIRST_NAME)}</FirstName>
        <LastName>{data($person/orgres:LAST_NAME)}</LastName>
        <MiddleName>{data($person/orgres:MIDDLE_NAME)}</MiddleName>
        <PreferredName>{data($person/orgres:PREFFERED_NAME)}</PreferredName>
        <DateOfBirth>{data($person/orgres:BIRTHDATE)}</DateOfBirth>
        <Gender>{data($person/orgres:SEX)}</Gender>
        <NameTitle>{data($person/orgres:NAME_PREFIX)}</NameTitle>
        <ResidencyStatus>{data($person/orgres:CITIZENSHIP)}</ResidencyStatus>
        <PersonType>
 {
 if($orgRelation) then
 data($orgRelation[1]/orgres:PER_ORG)
 else
 ''
 }
 </PersonType>

{
if($addressHome) then
         <Address>
            <AddressType>{data($addressHome[1]/orgres:ADDRESS_TYPE)}</AddressType>
            <Address1>{data($addressHome[1]/orgres:ADDRESS1)}</Address1>
            <Address2>{data($addressHome[1]/orgres:ADDRESS2)}</Address2>
            <City>{data($addressHome[1]/orgres:CITY)}</City>
            <State>{data($addressHome[1]/orgres:STATE)}</State>
            <Country>{data($addressHome[1]/orgres:COUNTRY)}</Country>
            <PostCode>{data($addressHome[1]/orgres:POSTAL)}</PostCode>
        </Address>
        else
        ''
}

{
if($addressMail) then
         <Address>
            <AddressType>{data($addressMail[1]/orgres:ADDRESS_TYPE)}</AddressType>
            <Address1>{data($addressMail[1]/orgres:ADDRESS1)}</Address1>
            <Address2>{data($addressMail[1]/orgres:ADDRESS2)}</Address2>
            <City>{data($addressMail[1]/orgres:CITY)}</City>
            <State>{data($addressMail[1]/orgres:STATE)}</State>
            <Country>{data($addressMail[1]/orgres:COUNTRY)}</Country>
            <PostCode>{data($addressMail[1]/orgres:POSTAL)}</PostCode>
        </Address>
        else
        ''
 }       
 <Contact>
 {
 if($homePhone) then
             <Phone>
                <PhoneType>{data($homePhone[1]/orgres:PHONE_TYPE)}</PhoneType>
                <PhoneNo>{data($homePhone[1]/orgres:PHONE)}</PhoneNo>
                <IsPreferred>{data($homePhone[1]/orgres:PREF_PHONE_FLAG)}</IsPreferred>
            </Phone>
 else
 ''
 }
  {
 if($cellPhone) then
             <Phone>
                <PhoneType>{data($cellPhone[1]/orgres:PHONE_TYPE)}</PhoneType>
                <PhoneNo>{data($cellPhone[1]/orgres:PHONE)}</PhoneNo>
                <IsPreferred>{data($cellPhone[1]/orgres:PREF_PHONE_FLAG)}</IsPreferred>
            </Phone>
 else
 ''
 }
   {
 if($workPhone) then
             <Phone>
                <PhoneType>{data($workPhone[1]/orgres:PHONE_TYPE)}</PhoneType>
                <PhoneNo>{data($workPhone[1]/orgres:PHONE)}</PhoneNo>
                <IsPreferred>{data($workPhone[1]/orgres:PREF_PHONE_FLAG)}</IsPreferred>
            </Phone>
 else
 ''
 }
 {
 if($workEmail) then
             <Email>
                <EmailType>{data($workEmail[1]/orgres:E_ADDR_TYPE)}</EmailType>
                <EmailAddr>{data($workEmail[1]/orgres:EMAIL_ADDR)}</EmailAddr>
                <IsPreferred>{data($workEmail[1]/orgres:PREF_EMAIL_FLAG)}</IsPreferred>
            </Email>
 else
 ''
 }
  {
 if($homeEmail) then
             <Email>
                <EmailType>{data($homeEmail[1]/orgres:E_ADDR_TYPE)}</EmailType>
                <EmailAddr>{data($homeEmail[1]/orgres:EMAIL_ADDR)}</EmailAddr>
                <IsPreferred>{data($homeEmail[1]/orgres:PREF_EMAIL_FLAG)}</IsPreferred>
            </Email>
 else
 ''
 }
        </Contact>
{
if($orgRelation) then
        <Organization>
            <OrganizationName>{data($orgRelation[1]/orgres:PER_ORG)}</OrganizationName>
            <Department>{data($orgRelation[1]/orgres:DEPTID)}</Department>
            <Faculty>{data($orgRelation[1]/orgres:FAC_DIV_UOA)}</Faculty>
            <School>{data($orgRelation[1]/orgres:SCH_SEC_UOA)}</School>
        </Organization>
else
''
}
    </Person>
}
</PersonResponse>