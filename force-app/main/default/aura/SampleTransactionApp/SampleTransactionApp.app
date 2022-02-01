<aura:application extends="force:slds">
    <aura:attribute name="selectedLookUpRecords" type="User[]" default="[]"/>
    <c:SampleTransaction objectAPIName="account"
                               IconName="standard:account"
                               lstSelectedRecords="{!v.selectedLookUpRecords}"
                               label="Account Name"/>
</aura:application>