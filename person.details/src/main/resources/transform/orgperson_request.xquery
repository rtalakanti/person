declare namespace adel = "http://adelaide.edu.au/integration/app/PersonDataRequest";
declare namespace get = "http://adelaide.edu.au/enterprise/peoplesoft/sahr/schema/GETORGPERSON_RQ_UOA";

<get:getOrgPersonRequest
    getCurrentRowOnly="N"
    getActiveRowsOnly="Y"
    includeDeceased="Y"
    includeRelations="Y"
    includeAddresses="Y"
    includePhones="Y"
    includeEmails="Y"
    includeVisas="N"
    getWorkVisaOnly="N"
    includeBankAccounts="N"
    includeTaxDetails="N">
    <get:personId>{replace(data(/adel:PersonRequest/adel:PersonID), 'a', '')}</get:personId>
</get:getOrgPersonRequest>